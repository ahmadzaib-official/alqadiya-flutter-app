import 'package:another_flushbar/flushbar.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static void show({
    required String message,
    required Color backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final context = Get.context;

    if (context == null || !Get.isDialogOpen! && Get.context != null) {
      Flushbar(
        messageText: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 8.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        borderRadius: BorderRadius.circular(8.r),
        duration: duration,
        flushbarPosition: FlushbarPosition.TOP,
        animationDuration: const Duration(milliseconds: 600),
        isDismissible: true,
        dismissDirection: FlushbarDismissDirection.VERTICAL,
      ).show(context!);
    }
  }

  static void showError(String message) {
    show(message: message, backgroundColor: MyColors.backgroundColor);
  }

  static void showSuccess(String message) {
    show(message: message, backgroundColor: Colors.green.shade600);
  }

  static void showInfo(String message) {
    show(message: message, backgroundColor: Colors.blue.shade600);
  }
}

class AppToaster {
  static void warning(String message) => Get.rawSnackbar(
    title: "Alert",
    message: message,
    backgroundColor: Colors.amberAccent,
  );

  static void info(String message) =>
      Get.rawSnackbar(title: "Info", message: message);

  static void error(String message) => Get.rawSnackbar(
    title: "Error",
    message: message,
    backgroundColor: Colors.redAccent,
  );
}
