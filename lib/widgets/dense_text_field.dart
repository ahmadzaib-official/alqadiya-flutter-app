import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DenseTextField extends StatelessWidget {
  final String? label;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? hintText;
  final double? labelFontSize;
  final double? textFontSize;
  final double? hintFontSize;
  final double? width;

  const DenseTextField({
    super.key,
    this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.labelFontSize,
    this.textFontSize,
    this.hintFontSize,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.captionRegular10().copyWith(
fontSize: 8.sp,
              color: MyColors.white,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        Container(
          width: width,
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: MyColors.redButtonColor,
              width: 1.w,
            ),
            color: MyColors.redButtonColor.withValues(alpha: 0.1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: AppTextStyles.bodyTextRegular16().copyWith(
              color: MyColors.white,
              fontSize: 7.sp,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 6.h,
              ),
              hintText: hintText,
              hintStyle: AppTextStyles.labelRegular14().copyWith(
                fontSize: (hintFontSize ?? 9).sp,
                color: MyColors.white.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

