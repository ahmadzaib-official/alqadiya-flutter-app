import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Toaster {
  static void showToast(String? message, {Color? color}) {
    if (message == null || message.trim().isEmpty) return;
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: color ?? MyColors.backgroundColor,
      textColor: Colors.white,
      fontSize: 14.0.sp,
    );
  }

  static void showErrorAlertSnackBar(String message) {
    if (message.trim().isEmpty) return;
    Get.snackbar(
      'Something went wrong!',
      message,
      backgroundColor: MyColors.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      colorText: Colors.white,
      isDismissible: false,
      snackbarStatus: (value) {
        DebugPoint.log(value);
      },
    );
  }

  static void showConfirmAlertSnackBar(String message) {
    if (message.trim().isEmpty) return;

    Get.snackbar(
      'Successfully',
      message,
      backgroundColor: Colors.green,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      isDismissible: false,
      colorText: Colors.white,

      snackbarStatus: (value) {
        DebugPoint.log(value);
      },
    );
  }

  static void showAlertSnackBar(String message) {
    if (message.trim().isEmpty) return;

    Get.snackbar(
      'Alert',
      message,
      backgroundColor: Colors.red,
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      icon: Icon(Icons.error_outline, color: Colors.white, size: 30.sp),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      borderRadius: 10.r,
      margin: EdgeInsets.only(bottom: 12.h),
      snackbarStatus: (value) {
        debugPrint('Snackbar Status: $value');
      },
      overlayBlur: 2,
      // ignore: deprecated_member_use
      overlayColor: Colors.black.withValues(alpha: 0.2),
      animationDuration: const Duration(milliseconds: 500),
    );
  }
}
