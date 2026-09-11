import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';

class GoBackDialog {
  static Future<bool?> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,

      builder:
          (context) => AlertDialog(
            // contentPadding: EdgeInsets.zero,
            backgroundColor: MyColors.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(color: MyColors.greenColor, width: 1),
            ),
            title: Column(
              children: [
                SvgPicture.asset(
                  MyIcons.arrowback,
                  width: 24.sp,
                  height: 24.sp,
                  colorFilter: const ColorFilter.mode(
                    MyColors.greenColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Return to the previous page'.tr,
                  style: AppTextStyles.heading1().copyWith(
                    fontSize: 8.sp,
                    color: MyColors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                'You will be returned to the previous page. Do you want to continue?'
                    .tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 6.sp,

                  color: MyColors.white.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              CustomButton(
                width: 40.w,
                height: 40.h,
                text: 'Cancel'.tr,
                borderRadius: 100.r,
                backgroundColor: MyColors.white.withValues(alpha: 0.1),
                onPressed: () => Navigator.of(context).pop(false),
                fontSize: 5.sp,
              ),
              SizedBox(width: 4.w),
              CustomButton(
                width: 40.w,
                height: 40.h,
                text: 'Yes, return'.tr,
                borderRadius: 100.r,
                backgroundColor: MyColors.greenColor,
                onPressed: () => Navigator.of(context).pop(true),
                fontSize: 5.sp,
              ),
            ],
          ),
    );
  }

  static Future<void> showAndGoBack(BuildContext context) async {
    final shouldGoBack = await show(context);
    if (shouldGoBack == true) {
      Get.back();
    }
  }
}
