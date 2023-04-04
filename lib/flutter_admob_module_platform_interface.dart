import 'package:flutter_core_ads_manager/iadsmanager/i_ads.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_admob_module_method_channel.dart';

abstract class FlutterAdmobModulePlatform extends PlatformInterface
    implements IAds {
  /// Constructs a FlutterAdmobModulePlatform.
  FlutterAdmobModulePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAdmobModulePlatform _instance =
      MethodChannelFlutterAdmobModule();

  /// The default instance of [FlutterAdmobModulePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAdmobModule].
  static FlutterAdmobModulePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAdmobModulePlatform] when
  /// they register themselves.
  static set instance(FlutterAdmobModulePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
