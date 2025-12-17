import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomIconTextButton extends StatelessWidget {
  const CustomIconTextButton({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.onTap,
    this.isProgressButton = false,
    this.isTextButton = false,
    this.isIconButton = false,
    this.height,
    this.width,
    this.buttonColor,
    this.forgroundColor,
  });

  final String buttonText;
  final bool isProgressButton;
  final bool isIconButton;
  final bool isTextButton;
  final String icon;
  final double? height;
  final Color? buttonColor;
  final Color? forgroundColor;
  final double? width;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: buttonColor ?? MyColors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 6.sp,
                fontWeight: FontWeight.w600,
                color: forgroundColor ?? MyColors.white.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(width: 2.w),
            if (isTextButton)
              Text(
                '14'.tr,
                style: AppTextStyles.heading1().copyWith(fontSize: 8.sp),
              ),
            if (isIconButton)
              SvgPicture.asset(
                icon,
                height: 26.h,
                width: 26.w,
                colorFilter:
                    forgroundColor != null
                        ? ColorFilter.mode(forgroundColor!, BlendMode.srcIn)
                        : null,
              ),
            if (isProgressButton)
              SizedBox(
                width: 20.w,
                child: LinearProgressIndicator(
                  value: 0.7,
                  borderRadius: BorderRadius.circular(100.r),
                  color: MyColors.redButtonColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
