import 'package:flutter/material.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';

import 'flutter_admob_module_platform_interface.dart';

class FlutterAdmobModule {
  Future<String?> getPlatformVersion() {
    return FlutterAdmobModulePlatform.instance.getPlatformVersion();
  }

  void initialize(
      BuildContext context, String? appId, IInitialize? iInitialize) {
    return FlutterAdmobModulePlatform.instance
        .initialize(context, appId, iInitialize);
  }

  Future<void> loadGdpr(BuildContext context, bool childDirected) {
    return FlutterAdmobModulePlatform.instance.loadGdpr(context, childDirected);
  }

  void loadInterstitial(BuildContext context, String adUnitId) {
    FlutterAdmobModulePlatform.instance.loadInterstitial(context, adUnitId);
  }

  void loadRewards(BuildContext context, String adUnitId) {
    FlutterAdmobModulePlatform.instance.loadRewards(context, adUnitId);
  }

  Future<void> setTestDevices(BuildContext context, List<String> testDevices) {
    return FlutterAdmobModulePlatform.instance
        .setTestDevices(context, testDevices);
  }

  Widget showBanner(BuildContext context, SizeBanner sizeBanner,
      String adUnitId, CallbackAds? callbackAds) {
    return FlutterAdmobModulePlatform.instance
        .showBanner(context, sizeBanner, adUnitId, callbackAds);
  }

  void showInterstitial(
      BuildContext context, String adUnitId, CallbackAds? callbackAds) {
    FlutterAdmobModulePlatform.instance
        .showInterstitial(context, adUnitId, callbackAds);
  }

  Widget showNativeAds(BuildContext context, SizeNative sizeNative,
      String adUnitId, CallbackAds? callbackAds) {
    return FlutterAdmobModulePlatform.instance
        .showNativeAds(context, sizeNative, adUnitId, callbackAds);
  }

  void showRewards(BuildContext context, String adUnitId,
      CallbackAds? callbackAds, IRewards? iRewards) {
    FlutterAdmobModulePlatform.instance
        .showRewards(context, adUnitId, callbackAds, iRewards);
  }
}
