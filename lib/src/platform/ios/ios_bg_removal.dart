import 'package:flutter/services.dart';

class IosBgRemoval {
  static const MethodChannel _channel = MethodChannel('canvas_studio/bg_removal');

  static Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod('isAvailable');
      return result == true;
    } on PlatformException {
      return false;
    }
  }

  static Future<String?> removeBackground(String imagePath) async {
    try {
      return await _channel.invokeMethod('removeBackground', {'image_path': imagePath});
    } on PlatformException {
      return null;
    }
  }
}
