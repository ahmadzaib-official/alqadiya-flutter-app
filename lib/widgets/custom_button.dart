import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? loadingIndicator;
  final bool isLoading;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final Widget? preffix;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.loadingIndicator,
    this.borderRadius,
    this.isLoading = false,
    this.preffix,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? MyColors.redButtonColor,
          disabledBackgroundColor: MyColors.redButtonColor.withValues(
            alpha: 0.5,
          ),
          minimumSize: Size(double.infinity, 48.h),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              preffix != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (preffix != null) ...[
              Spacer(flex: 1),
              preffix!,
              Spacer(flex: 2),
            ],
            Text(
              text,
              style: AppTextStyles.heading1().copyWith(
                color: textColor ?? Colors.white,
                fontSize: fontSize?.toDouble() ?? 12.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (preffix != null) ...[Spacer(flex: 5)],
            if (isLoading) ...[
              SizedBox(width: 10.w),
              loadingIndicator ??
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? outlineColor;
  final Color? textColor;
  final Widget? loadingIndicator;
  final bool isLoading;
  final double? fontSize;
  final double? height;

  const CustomOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.height,
    this.outlineColor,
    this.textColor,
    this.fontSize,
    this.loadingIndicator,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity, // ✅ Ensures full width
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: MyColors.redButtonColor.withValues(
            alpha: 0.5,
          ),
          minimumSize: Size(double.infinity, 50.h),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
            side: BorderSide(
              color: outlineColor ?? MyColors.redButtonColor,
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                style: AppTextStyles.bodyTextMedium16().copyWith(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize?.toDouble() ?? 12.sp,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLoading) ...[
              SizedBox(width: 10.w),
              loadingIndicator ??
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomButtonMedium extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final int? fontSize;
  final void Function()? onPressed;

  const CustomButtonMedium({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.onPressed,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? MyColors.redButtonColor,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          minimumSize: const Size(double.infinity, 48),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),

        child: Text(
          text,
          style: AppTextStyles.labelMedium14().copyWith(
            color: textColor ?? Colors.white,
            fontSize: fontSize?.toDouble() ?? 15.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
