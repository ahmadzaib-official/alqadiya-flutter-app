import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';

class LeaveDialog {
  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: MyColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(color: MyColors.redButtonColor, width: 1),
            ),
            title: Text(
              'Leave Game?'.tr,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 8.sp,
                color: MyColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              'Are you sure you want to leave the game?'.tr,
              style: AppTextStyles.heading2().copyWith(
                fontSize: 6.sp,
                color: MyColors.white.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustomButton(
                width: 40.w,
                height: 40.h,
                text: 'No'.tr,
                borderRadius: 100.r,
                backgroundColor: MyColors.white.withValues(alpha: 0.1),
                onPressed: () => Navigator.of(context).pop(false),
                fontSize: 5.sp,
              ),
              SizedBox(width: 4.w),
              CustomButton(
                width: 40.w,
                height: 40.h,
                text: 'Yes'.tr,
                borderRadius: 100.r,
                backgroundColor: MyColors.redButtonColor,
                onPressed: () => Navigator.of(context).pop(true),
                fontSize: 5.sp,
              ),
            ],
          ),
    );
  }

  static Future<void> showAndNavigateHome(BuildContext context) async {
    final shouldLeave = await show(context);
    if (shouldLeave == true) {
      Get.offAllNamed(AppRoutes.homescreen);
    }
  }
}
