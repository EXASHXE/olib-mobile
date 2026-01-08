import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'hive_service.dart';

/// Update checker service for checking new app versions
class UpdateService {
  static const String _versionUrl = 'https://bookbook.space/version.json';
  static const String _lastCheckKey = 'last_update_check';
  static const String _dismissedVersionKey = 'dismissed_version';
  
  /// Check interval: once per day
  static const Duration _checkInterval = Duration(hours: 24);
  
  /// Remote version info
  static String? latestVersion;
  static String? downloadUrl;
  static Map<String, String>? changelog;
  static bool forceUpdate = false;
  static bool hasUpdate = false;
  
  /// Flag to indicate app is blocked due to force update
  /// When true, search and download features should be disabled
  static bool isBlocked = false;
  
  /// Check for updates (non-blocking, silent on errors)
  static Future<bool> checkForUpdate({bool force = false}) async {
    try {
      // Check if we should skip (already checked recently)
      if (!force && !_shouldCheck()) {
        debugPrint('UpdateService: Skipping check (checked recently)');
        return false;
      }
      
      // Fetch remote version
      final response = await http.get(
        Uri.parse(_versionUrl),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        debugPrint('UpdateService: Failed to fetch version (${response.statusCode})');
        return false;
      }
      
      final data = json.decode(response.body) as Map<String, dynamic>;
      latestVersion = data['version'] as String?;
      downloadUrl = data['url'] as String?;
      forceUpdate = data['force_update'] as bool? ?? false;
      
      // Parse changelog
      if (data['changelog'] != null) {
        final changelogData = data['changelog'] as Map<String, dynamic>;
        changelog = changelogData.map((k, v) => MapEntry(k, v.toString()));
      }
      
      // Get current version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      // Compare versions
      hasUpdate = _isNewerVersion(latestVersion!, currentVersion);
      
      // Save check time
      await HiveService.settingsBox.put(
        _lastCheckKey, 
        DateTime.now().millisecondsSinceEpoch,
      );
      
      debugPrint('UpdateService: Current=$currentVersion, Latest=$latestVersion, HasUpdate=$hasUpdate');
      
      return hasUpdate;
    } catch (e) {
      debugPrint('UpdateService: Error checking for update: $e');
      return false;
    }
  }
  
  /// Check if we should perform update check
  static bool _shouldCheck() {
    final lastCheck = HiveService.settingsBox.get(_lastCheckKey);
    if (lastCheck == null) return true;
    
    final lastCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheck as int);
    return DateTime.now().difference(lastCheckTime) > _checkInterval;
  }
  
  /// Compare version strings (e.g., "1.0.1" > "1.0.0")
  static bool _isNewerVersion(String remote, String current) {
    final remoteParts = remote.split('.').map(int.parse).toList();
    final currentParts = current.split('.').map(int.parse).toList();
    
    for (int i = 0; i < remoteParts.length && i < currentParts.length; i++) {
      if (remoteParts[i] > currentParts[i]) return true;
      if (remoteParts[i] < currentParts[i]) return false;
    }
    
    return remoteParts.length > currentParts.length;
  }
  
  /// Check if user has dismissed this version
  static bool isVersionDismissed() {
    final dismissed = HiveService.settingsBox.get(_dismissedVersionKey);
    return dismissed == latestVersion;
  }
  
  /// Dismiss the current update notification
  static Future<void> dismissUpdate() async {
    if (latestVersion != null) {
      await HiveService.settingsBox.put(_dismissedVersionKey, latestVersion);
    }
  }
  
  /// Get changelog text for current locale
  static String getChangelog(String locale) {
    if (changelog == null) return '';
    return changelog![locale] ?? changelog!['en'] ?? '';
  }
  
  /// Show manual update check dialog (for Settings page)
  /// This handles the loading, checking, and result display in one call
  static Future<void> showManualCheckDialog(BuildContext context) async {
    final locale = Localizations.localeOf(context).languageCode;
    final isZh = locale == 'zh';
    
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(isZh ? '正在检查更新...' : 'Checking for updates...'),
          ],
        ),
      ),
    );
    
    // Force check (bypass cache)
    final update = await checkForUpdate(force: true);
    
    // Close loading dialog
    if (context.mounted) Navigator.of(context).pop();
    
    if (!context.mounted) return;
    
    // Import these dynamically to avoid circular dependencies
    final primaryColor = Theme.of(context).primaryColor;
    
    if (update) {
      final log = getChangelog(isZh ? 'zh' : 'en');
      
      showDialog(
        context: context,
        barrierDismissible: !forceUpdate,
        builder: (ctx) => AlertDialog(
          title: Text(forceUpdate 
              ? (isZh ? '必须更新' : 'Update Required')
              : (isZh ? '发现新版本' : 'Update Available')),
          content: Text(forceUpdate
              ? (isZh 
                  ? '发现新版本 $latestVersion\n\n$log\n\n当前版本已不可用。'
                  : 'New version $latestVersion\n\n$log\n\nThis version is no longer supported.')
              : (isZh 
                  ? '新版本 $latestVersion 已发布\n\n$log'
                  : 'Version $latestVersion is available\n\n$log')),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () {
                  dismissUpdate();
                  Navigator.of(ctx).pop();
                },
                child: Text(isZh ? '稍后更新' : 'Later'),
              ),
            ElevatedButton(
              onPressed: () {
                if (!forceUpdate) Navigator.of(ctx).pop();
                if (downloadUrl != null) {
                  // Use url_launcher
                  _launchUpdateUrl();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(isZh ? '立即更新' : 'Update Now', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      // Already up to date
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(isZh ? '已是最新版本' : 'Up to Date'),
          content: Text(isZh ? '当前版本已是最新版本' : 'You are using the latest version.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              child: Text(isZh ? '好的' : 'OK', style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }
  
  static Future<void> _launchUpdateUrl() async {
    if (downloadUrl == null) return;
    final uri = Uri.parse(downloadUrl!);
    // Dynamic import to avoid issues
    try {
      // ignore: depend_on_referenced_packages
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Failed to launch URL: $e');
    }
  }
}
