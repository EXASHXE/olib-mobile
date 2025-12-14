import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'hive_service.dart';

/// Unity Ads Service for managing banner and rewarded ads
class AdService {
  // ⚠️ Set to false to completely disable all ads (Unity Ads not available in China)
  static const bool adsEnabled = false;
  
  static const String _androidGameId = '6003580';
  static const String _iosGameId = '6003581';
  
  // Ad Placement IDs (default Unity placements)
  static const String bannerPlacement = 'Banner_Android';
  static const String bannerPlacementIos = 'Banner_iOS';
  static const String rewardedPlacement = 'Rewarded_Android';
  static const String rewardedPlacementIos = 'Rewarded_iOS';
  
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  
  /// Check if ads should be shown (platform support + enabled flag)
  static bool get isMobilePlatform => 
      adsEnabled && (Platform.isAndroid || Platform.isIOS);
  
  /// Initialize Unity Ads
  static Future<void> init() async {
    // Skip if ads are disabled
    if (!adsEnabled) {
      debugPrint('Unity Ads: Ads are disabled');
      return;
    }
    
    if (_isInitialized) return;
    
    // Unity Ads only supports Android and iOS
    if (!Platform.isAndroid && !Platform.isIOS) {
      debugPrint('Unity Ads: Skipping initialization on unsupported platform');
      return;
    }
    
    final gameId = Platform.isAndroid ? _androidGameId : _iosGameId;
    
    await UnityAds.init(
      gameId: gameId,
      testMode: kDebugMode, // Enable test mode in debug builds
      onComplete: () {
        _isInitialized = true;
        debugPrint('Unity Ads initialized successfully');
      },
      onFailed: (error, message) {
        debugPrint('Unity Ads initialization failed: $error - $message');
      },
    );
  }
  
  /// Get correct placement ID based on platform
  static String getBannerPlacement() {
    return Platform.isAndroid ? bannerPlacement : bannerPlacementIos;
  }
  
  static String getRewardedPlacement() {
    return Platform.isAndroid ? rewardedPlacement : rewardedPlacementIos;
  }
  
  /// Show rewarded ad
  static Future<bool> showRewardedAd({
    required Function onComplete,
    required Function onSkipped,
  }) async {
    if (!_isInitialized) {
      debugPrint('Unity Ads not initialized');
      return false;
    }
    
    final placement = getRewardedPlacement();
    
    UnityAds.showVideoAd(
      placementId: placement,
      onComplete: (placementId) {
        onComplete();
      },
      onFailed: (placementId, error, message) {
        debugPrint('Rewarded ad failed: $error - $message');
        onSkipped();
      },
      onSkipped: (placementId) {
        onSkipped();
      },
    );
    
    return true;
  }
  
  // ============ Ad-Free Time Management ============
  
  static const String _adFreeUntilKey = 'ad_free_until';
  static const String _rewardWatchCountKey = 'reward_watch_count';
  static const String _rewardWatchDateKey = 'reward_watch_date';
  
  /// Check if user is currently ad-free
  static bool isAdFree() {
    final adFreeUntil = HiveService.settingsBox.get(_adFreeUntilKey);
    if (adFreeUntil == null) return false;
    
    final until = DateTime.fromMillisecondsSinceEpoch(adFreeUntil as int);
    return DateTime.now().isBefore(until);
  }
  
  /// Get remaining ad-free time
  static Duration getAdFreeRemaining() {
    final adFreeUntil = HiveService.settingsBox.get(_adFreeUntilKey);
    if (adFreeUntil == null) return Duration.zero;
    
    final until = DateTime.fromMillisecondsSinceEpoch(adFreeUntil as int);
    final remaining = until.difference(DateTime.now());
    
    return remaining.isNegative ? Duration.zero : remaining;
  }
  
  /// Get today's reward watch count
  static int getTodayWatchCount() {
    final savedDate = HiveService.settingsBox.get(_rewardWatchDateKey);
    final today = _getDateString(DateTime.now());
    
    if (savedDate != today) {
      // Reset count for new day
      return 0;
    }
    
    return HiveService.settingsBox.get(_rewardWatchCountKey, defaultValue: 0) as int;
  }
  
  /// Grant ad-free time based on watch count
  /// 1st watch: 1 hour, 2nd watch: 3 hours, 3rd+ watch: rest of day
  static Future<Duration> grantAdFreeTime() async {
    final today = _getDateString(DateTime.now());
    final savedDate = HiveService.settingsBox.get(_rewardWatchDateKey);
    
    int watchCount = 0;
    if (savedDate == today) {
      watchCount = HiveService.settingsBox.get(_rewardWatchCountKey, defaultValue: 0) as int;
    }
    
    // Increment watch count
    watchCount++;
    await HiveService.settingsBox.put(_rewardWatchCountKey, watchCount);
    await HiveService.settingsBox.put(_rewardWatchDateKey, today);
    
    // Calculate ad-free duration
    Duration grantDuration;
    if (watchCount == 1) {
      grantDuration = const Duration(hours: 1);
    } else if (watchCount == 2) {
      grantDuration = const Duration(hours: 3);
    } else {
      // 3rd+ watch: rest of the day (until midnight)
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      grantDuration = midnight.difference(now);
    }
    
    // Calculate new ad-free until time
    final currentRemaining = getAdFreeRemaining();
    final newUntil = DateTime.now().add(currentRemaining + grantDuration);
    
    await HiveService.settingsBox.put(
      _adFreeUntilKey, 
      newUntil.millisecondsSinceEpoch,
    );
    
    return grantDuration;
  }
  
  /// Get description of next reward
  static String getNextRewardDescription(String locale) {
    final count = getTodayWatchCount();
    final isZh = locale.startsWith('zh');
    
    if (count == 0) {
      return isZh ? '观看广告免除1小时广告' : 'Watch to get 1 hour ad-free';
    } else if (count == 1) {
      return isZh ? '再看一次免除3小时广告' : 'Watch again for 3 hours ad-free';
    } else if (count == 2) {
      return isZh ? '再看一次免除今日所有广告' : 'Watch again for ad-free rest of day';
    } else {
      return isZh ? '今日已达免广告上限' : 'Max ad-free rewards reached today';
    }
  }
  
  static String _getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
