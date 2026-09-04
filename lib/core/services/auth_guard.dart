import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/widgets/auth_required_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthGuard {
  static final Preferences _prefs = Get.find<Preferences>();

  /// Check if user is guest
  static bool get isGuest {
    return _prefs.getBool(AppStrings.isGuest) ?? false;
  }

  /// Check if user is authenticated (not guest)
  static bool get isAuthenticated {
    return !isGuest;
  }

  /// Show auth required dialog if user is guest
  /// Returns true if user is authenticated, false if guest
  static bool requireAuth({
    required String title,
    required String message,
    VoidCallback? onGuestDismiss,
  }) {
    if (isGuest) {
      showAuthRequiredDialog(
        title: title,
        message: message,
        onDismiss: onGuestDismiss,
      );
      return false;
    }
    return true;
  }

  /// Execute action only if authenticated, otherwise show dialog
  static void executeIfAuthenticated({
    required String title,
    required String message,
    required VoidCallback action,
    VoidCallback? onGuestDismiss,
  }) {
    if (requireAuth(title: title, message: message, onGuestDismiss: onGuestDismiss)) {
      action();
    }
  }

  /// Navigate to route only if authenticated
  static void navigateIfAuthenticated({
    required String route,
    String? title,
    String? message,
    dynamic arguments,
    VoidCallback? onGuestDismiss,
  }) {
    executeIfAuthenticated(
      title: title ?? 'Authentication Required'.tr,
      message: message ?? 'Please sign in to continue'.tr,
      action: () => Get.toNamed(route, arguments: arguments),
      onGuestDismiss: onGuestDismiss,
    );
  }
}
