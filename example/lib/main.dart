// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_admob_module/flutter_admob_module.dart';
import 'package:flutter_core_ads_manager/callback_ads.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_initialize.dart';
import 'package:flutter_core_ads_manager/iadsmanager/i_rewards.dart';
import 'package:flutter_core_ads_manager/size_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterAdmobModulePlugin = FlutterAdmobModule();
  bool _isShowBanner = false;
  bool _isShowNative = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterAdmobModulePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _flutterAdmobModulePlugin.initialize(
                        context,
                        "appId",
                        IInitialize(
                          onInitializationComplete: () async {
                            debugPrint('Initialization complete!');
                            await _flutterAdmobModulePlugin.loadGdpr(
                                context, true);
                            _flutterAdmobModulePlugin.loadInterstitial(context,
                                "ca-app-pub-3940256099942544/1033173712");
                            _flutterAdmobModulePlugin.loadRewards(context,
                                "ca-app-pub-3940256099942544/5224354917");
                          },
                        ),
                      );
                    },
                    child: const Text('Initialize'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isShowNative = true;
                      });
                    },
                    child: const Text("Show Open App"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isShowBanner = true;
                      });
                    },
                    child: const Text("Show Banner"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _flutterAdmobModulePlugin.showInterstitial(
                        context,
                        "ca-app-pub-3940256099942544/1033173712",
                        CallbackAds(
                          onAdLoaded: (message) {},
                          onAdFailedToLoad: (error) {},
                        ),
                      );
                    },
                    child: const Text("Show Intersititial"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isShowNative = true;
                      });
                    },
                    child: const Text("Show Native"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _flutterAdmobModulePlugin.showRewards(
                          context,
                          "ca-app-pub-3940256099942544/2247696110",
                          CallbackAds(
                            onAdFailedToLoad: (error) {},
                            onAdLoaded: (message) {},
                          ), IRewards(
                        onUserEarnedReward: (rewardsItem) {
                          debugPrint(
                              "onUserEarnedReward: ${rewardsItem.amount}");
                        },
                      ));
                    },
                    child: const Text("Show Rewards"),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_isShowBanner)
                      _flutterAdmobModulePlugin.showBanner(
                        context,
                        SizeBanner.MEDIUM,
                        "ca-app-pub-3940256099942544/6300978111",
                        CallbackAds(
                          onAdLoaded: (message) {
                            debugPrint('onAdLoaded $message');
                          },
                          onAdFailedToLoad: (error) {
                            debugPrint('onAdFailedToLoad $error');
                          },
                        ),
                      ),
                    if (_isShowNative)
                      _flutterAdmobModulePlugin.showNativeAds(
                        context,
                        SizeNative.SMALL,
                        "ca-app-pub-2589910488755453/7014118453",
                        CallbackAds(
                          onAdLoaded: (message) {
                            print('onAdLoaded $message');
                          },
                          onAdFailedToLoad: (error) {
                            print('onAdFailedToLoad $error');
                          },
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
