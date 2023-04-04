import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admob_module/ads/banner_view.dart';
import 'package:flutter_admob_module/ads/native_view.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/rewards/rewards_item.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'flutter_admob_module_platform_interface.dart';

/// An implementation of [FlutterAdmobModulePlatform] that uses method channels.
class MethodChannelFlutterAdmobModule extends FlutterAdmobModulePlatform
    implements IAds {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_admob_module');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void initialize(
      BuildContext context, String? appId, IInitialize? iInitialize) {
    MobileAds.instance.initialize();
    iInitialize?.onInitializationComplete!();
  }

  void loadForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        debugPrint("gdpr admob: $status");
        if (status == ConsentStatus.required) {
          consentForm.show(
            (formError) {
              loadForm();
            },
          );
        }
      },
      (formError) {
        // Handle the error
      },
    );
  }

  @override
  Future<void> loadGdpr(BuildContext context, bool childDirected) {
    loadForm();
    return Future.value();
  }

  InterstitialAd? _interstitialAd;
  var _intersititalAdIsReady = false;

  @override
  void loadInterstitial(BuildContext context, String adUnitId) {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          debugPrint('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
          _intersititalAdIsReady = true;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _intersititalAdIsReady = false;
        },
      ),
    );
  }

  RewardedAd? _rewardedAd;
  var _rewardsAdIsReady = false;

  @override
  void loadRewards(BuildContext context, String adUnitId) {
    RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _rewardedAd = ad;
            _rewardsAdIsReady = true;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('RewardedAd failed to load: $error');
            _rewardsAdIsReady = false;
          },
        ));
  }

  @override
  Future<void> setTestDevices(
      BuildContext context, List<String> testDevices) async {
    await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testDevices));
    return Future.value();
  }

  @override
  Widget showBanner(BuildContext context, SizeBanner sizeBanner,
      String adUnitId, CallbackAds? callbackAds) {
    return BannerView(
      adUnitId: adUnitId,
      callbackAds: callbackAds,
    );
  }

  @override
  void showInterstitial(
      BuildContext context, String adUnitId, CallbackAds? callbackAds) {
    if (_intersititalAdIsReady) {
      _interstitialAd?.show();
      callbackAds?.onAdLoaded!('ad loaded.');
    } else {
      callbackAds?.onAdFailedToLoad!('int failed to load');
    }
    _intersititalAdIsReady = false;
    loadInterstitial(context, adUnitId);
  }

  @override
  Widget showNativeAds(BuildContext context, SizeNative sizeNative,
      String adUnitId, CallbackAds? callbackAds) {
    return NativeView(
      adUnitId: adUnitId,
      callbackAds: callbackAds,
      sizeNative: sizeNative,
    );
  }

  @override
  void showRewards(BuildContext context, String adUnitId,
      CallbackAds? callbackAds, IRewards? iRewards) {
    if (_rewardsAdIsReady) {
      _rewardedAd?.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          // Reward the user for watching an ad.
          var item = RewardsItem(
              amount: rewardItem.amount.toInt(), type: rewardItem.type);
          iRewards?.onUserEarnedReward!(item);
        },
      );
      callbackAds?.onAdLoaded;
    } else {
      callbackAds?.onAdFailedToLoad;
    }
    loadRewards(context, adUnitId);
  }
}
