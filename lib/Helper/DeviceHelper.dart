import 'package:flutter/services.dart';

class DeviceIdHelper {
  static const MethodChannel _channel = MethodChannel('device_id_channel');

  static Future<String?> getAndroidId() async {
    try {
      final String? androidId =
      await _channel.invokeMethod<String>('getAndroidId');
      return androidId;
    } on PlatformException catch (e) {
      print("Failed to get Android ID: ${e.message}");
      return null;
    }
  }
}