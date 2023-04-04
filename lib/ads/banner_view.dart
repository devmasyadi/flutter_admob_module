import 'package:flutter/material.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerView extends StatefulWidget {
  final String? adUnitId;
  final CallbackAds? callbackAds;
  const BannerView({super.key, this.adUnitId, this.callbackAds});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId ?? "",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          widget.callbackAds?.onAdLoaded!('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          widget
              .callbackAds?.onAdFailedToLoad!('BannerAd failed to load: $err');
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    if (widget.adUnitId != null && widget.adUnitId!.isNotEmpty) {
      loadAd();
    } else {
      widget.callbackAds?.onAdFailedToLoad!("adUnit empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          ),
        ),
      );
    }
    return Container();
  }
}
