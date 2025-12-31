import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CopyCodeButton extends StatelessWidget {
  const CopyCodeButton({
    super.key,
    required this.code,
    this.horizontalPadding = 8,
  });
  final String code;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Code copied to clipboard".tr,
              style: TextStyle(color: MyColors.white),
            ),
            backgroundColor: MyColors.black.withValues(alpha: 0.6),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: MyColors.backgroundColor,

          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(MyIcons.copy),
            SizedBox(width: 4.w),
            Text(
              'Copy the code'.tr,
              style: AppTextStyles.labelMedium14().copyWith(
                fontSize: 7.sp,
                color: MyColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
