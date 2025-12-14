import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import '../services/ad_service.dart';
import '../providers/ad_provider.dart';

/// Banner ad widget that respects ad-free status
class BannerAdWidget extends ConsumerWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);
    
    if (!shouldShowAds) {
      return const SizedBox.shrink();
    }
    
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: UnityBannerAd(
        placementId: AdService.getBannerPlacement(),
        onLoad: (placementId) {
          debugPrint('Banner loaded: $placementId');
        },
        onFailed: (placementId, error, message) {
          debugPrint('Banner failed: $error - $message');
        },
        onClick: (placementId) {
          debugPrint('Banner clicked: $placementId');
        },
      ),
    );
  }
}

/// Bottom banner ad wrapper (for screens that need it)
class BottomBannerAd extends ConsumerWidget {
  final Widget child;
  
  const BottomBannerAd({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowAds = ref.watch(shouldShowAdsProvider);
    
    return Column(
      children: [
        Expanded(child: child),
        if (shouldShowAds) const BannerAdWidget(),
      ],
    );
  }
}
