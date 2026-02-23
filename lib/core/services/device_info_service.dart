import 'dart:io' show Platform;
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

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

  /// Get a unique device identifier that persists across app reinstalls
  /// Uses hardware-based identifiers when possible
  static Future<String> getDeviceId() async {
    final prefs = Get.find<Preferences>();

    // Check if device ID already exists in storage
    String? existingDeviceId = prefs.getString(AppStrings.deviceId);

    if (existingDeviceId != null && existingDeviceId.isNotEmpty) {
      return existingDeviceId;
    }

    // Generate device ID based on platform
    String deviceId;

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Use Android ID - persists across app reinstalls but resets on factory reset
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // Use identifierForVendor - persists until all apps from vendor are uninstalled
        deviceId = iosInfo.identifierForVendor ?? _generateFallbackId();
      } else {
        deviceId = _generateFallbackId();
      }
    } catch (e) {
      // Fallback if device info fails
      deviceId = _generateFallbackId();
    }

    // Store for quick access
    await prefs.setString(AppStrings.deviceId, deviceId);

    return deviceId;
  }

  /// Generate a fallback device ID
  static String _generateFallbackId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final deviceType = getDeviceType();
    return '$deviceType-$timestamp-${_generateRandomString(8)}';
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
