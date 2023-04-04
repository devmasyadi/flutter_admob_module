import 'package:flutter/material.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeView extends StatefulWidget {
  final String? adUnitId;
  final CallbackAds? callbackAds;
  final SizeNative? sizeNative;
  const NativeView(
      {super.key, this.adUnitId, this.callbackAds, this.sizeNative});

  @override
  State<NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView> {
  bool _isLoaded = false;
  NativeAd? myNative;

  void loadAd() {
    myNative = NativeAd(
      adUnitId: widget.adUnitId!,
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
        mediaAspectRatio: MediaAspectRatio.any,
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: widget.sizeNative == SizeNative.MEDIUM
            ? TemplateType.medium
            : TemplateType.small,
      ),
      listener: NativeAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          setState(() {
            _isLoaded = true;
          });
          debugPrint('Ad loaded. $ad');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          debugPrint('Ad failed to load: $error');
          setState(() {
            _isLoaded = false;
          });
          widget.callbackAds?.onAdFailedToLoad!('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
        // Called when a click is recorded for a NativeAd.
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.adUnitId != null && widget.adUnitId!.isNotEmpty) {
      loadAd();
      myNative?.load();
    } else {
      widget.callbackAds?.onAdFailedToLoad!("adUnit empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (myNative != null && _isLoaded) {
      if (widget.sizeNative == SizeNative.MEDIUM) {
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: AdWidget(ad: myNative!),
        );
        // return SizedBox(
        //   height: 300,
        //   child: AdWidget(ad: myNative!),
        // );
      } else {
        return SizedBox(
          height: 100,
          width: double.infinity,
          child: AdWidget(ad: myNative!),
        );
      }
    }
    return Container();
  }
}
