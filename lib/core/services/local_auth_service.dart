import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart' show PlatformException;

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  late final LocalAuthentication _localAuth;

  factory LocalAuthService() {
    return _instance;
  }

  LocalAuthService._internal() {
    _localAuth = LocalAuthentication();
  }

  /// Check if device supports biometric authentication
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Check if device supports device credentials
  Future<bool> canUseDeviceCredentials() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Authenticate user with biometric or device credentials
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      // Check if device supports biometrics
      final canAuthenticate =
          await canCheckBiometrics() || await canUseDeviceCredentials();

      if (!canAuthenticate) {
        return false;
      }

      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          biometricOnly: false,
          useErrorDialogs: useErrorDialogs,
        ),
      );

      return isAuthenticated;
    } on PlatformException catch (e) {
      // Handle specific platform exceptions
      if (e.code == 'NotAvailable') {
        // Biometrics not available
        return false;
      } else if (e.code == 'NotEnrolled') {
        // No biometrics enrolled
        return false;
      } else if (e.code == 'LockedOut') {
        // Too many attempts
        return false;
      } else if (e.code == 'PermanentlyLockedOut') {
        // Biometric locked out permanently
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Stop any ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      // Handle error
    }
  }
}
