import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ad_service.dart';

/// State for ad-free status
class AdFreeState {
  final bool isAdFree;
  final Duration remaining;
  final int todayWatchCount;
  
  const AdFreeState({
    required this.isAdFree,
    required this.remaining,
    required this.todayWatchCount,
  });
  
  factory AdFreeState.initial() {
    return AdFreeState(
      isAdFree: AdService.isAdFree(),
      remaining: AdService.getAdFreeRemaining(),
      todayWatchCount: AdService.getTodayWatchCount(),
    );
  }
  
  AdFreeState copyWith({
    bool? isAdFree,
    Duration? remaining,
    int? todayWatchCount,
  }) {
    return AdFreeState(
      isAdFree: isAdFree ?? this.isAdFree,
      remaining: remaining ?? this.remaining,
      todayWatchCount: todayWatchCount ?? this.todayWatchCount,
    );
  }
  
  /// Format remaining time as string
  String getRemainingString(String locale) {
    if (!isAdFree || remaining == Duration.zero) {
      return locale.startsWith('zh') ? '无' : 'None';
    }
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    if (locale.startsWith('zh')) {
      if (hours > 0) {
        return '$hours小时${minutes > 0 ? '$minutes分钟' : ''}';
      }
      return '$minutes分钟';
    } else {
      if (hours > 0) {
        return '${hours}h${minutes > 0 ? ' ${minutes}m' : ''}';
      }
      return '${minutes}m';
    }
  }
}

/// Notifier for ad-free status
class AdFreeNotifier extends StateNotifier<AdFreeState> {
  AdFreeNotifier() : super(AdFreeState.initial());
  
  /// Refresh state from storage
  void refresh() {
    state = AdFreeState.initial();
  }
  
  /// Grant ad-free time after watching rewarded ad
  Future<Duration> grantAdFreeTime() async {
    final granted = await AdService.grantAdFreeTime();
    refresh();
    return granted;
  }
}

/// Provider for ad-free status
final adFreeProvider = StateNotifierProvider<AdFreeNotifier, AdFreeState>((ref) {
  return AdFreeNotifier();
});

/// Provider to check if ads should be shown (only on mobile platforms)
final shouldShowAdsProvider = Provider<bool>((ref) {
  // Only show ads on mobile platforms
  if (!AdService.isMobilePlatform) return false;
  
  final adFreeState = ref.watch(adFreeProvider);
  return !adFreeState.isAdFree && AdService.isInitialized;
});
