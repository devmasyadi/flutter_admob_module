import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_admob_module/flutter_admob_module_method_channel.dart';

void main() {
  MethodChannelFlutterAdmobModule platform = MethodChannelFlutterAdmobModule();
  const MethodChannel channel = MethodChannel('flutter_admob_module');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
