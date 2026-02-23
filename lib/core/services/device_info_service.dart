import 'dart:io' show Platform;
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class DeviceInfoService {
  /// Get device type (ios, android, web)
  static String getDeviceType() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    } else {
      return 'unknown';
    }
  }

  /// Get or generate a unique device identifier
  /// This creates a persistent UUID stored in SharedPreferences
  static Future<String> getDeviceId() async {
    final prefs = Get.find<Preferences>();

    // Check if device ID already exists
    String? existingDeviceId = prefs.getString(AppStrings.deviceId);

    if (existingDeviceId != null && existingDeviceId.isNotEmpty) {
      return existingDeviceId;
    }

    // Generate new device ID using timestamp and random component
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final deviceType = getDeviceType();
    final newDeviceId = '$deviceType-$timestamp-${_generateRandomString(8)}';

    // Store for future use
    await prefs.setString(AppStrings.deviceId, newDeviceId);

    return newDeviceId;
  }

  /// Generate a random alphanumeric string
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().microsecondsSinceEpoch;
    return List.generate(
      length,
      (index) => chars[(random + index) % chars.length],
    ).join();
  }
}
