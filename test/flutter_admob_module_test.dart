import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_module/flutter_admob_module.dart';
import 'package:flutter_admob_module/flutter_admob_module_platform_interface.dart';
import 'package:flutter_admob_module/flutter_admob_module_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAdmobModulePlatform
    with MockPlatformInterfaceMixin
    implements FlutterAdmobModulePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAdmobModulePlatform initialPlatform = FlutterAdmobModulePlatform.instance;

  test('$MethodChannelFlutterAdmobModule is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAdmobModule>());
  });

  test('getPlatformVersion', () async {
    FlutterAdmobModule flutterAdmobModulePlugin = FlutterAdmobModule();
    MockFlutterAdmobModulePlatform fakePlatform = MockFlutterAdmobModulePlatform();
    FlutterAdmobModulePlatform.instance = fakePlatform;

    expect(await flutterAdmobModulePlugin.getPlatformVersion(), '42');
  });
}
