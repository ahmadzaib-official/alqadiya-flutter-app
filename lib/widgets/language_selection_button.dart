import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LanguageSelectionButton extends StatelessWidget {
  const LanguageSelectionButton({
    super.key,
    this.color,
    this.height,
    this.width,
    this.margin,
    this.textFontSize,
    this.onTap,
    this.isShadow = true,
  });
  final Color? color;
  final double? height;
  final double? width;
  final double? textFontSize;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isShadow;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50.h,
        width: width ?? 80.w,
        margin: margin ?? null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.sp),
          color: color ?? Colors.transparent,
          boxShadow:
              isShadow
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'عربي',
              style: AppTextStyles.captionRegular12().copyWith(
                fontSize: textFontSize ?? 12.sp,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset(MyIcons.flag, height: 20.h),
          ],
        ),
      ),
    );
  }
}
