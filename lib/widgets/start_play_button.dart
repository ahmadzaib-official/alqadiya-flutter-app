import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartPlayButton extends StatelessWidget {
  const StartPlayButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.buttonHeight,
    this.buttonWidth,
  });
  final VoidCallback onTap;
  final String buttonText;
  final double? buttonHeight;
  final double? buttonWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight ?? 45.h,
        width: buttonWidth ,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.greenColor,
        ),
        alignment: Alignment.center,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: 6),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 6.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Spacer(flex: 2),
            Icon(
              Icons.arrow_forward_ios,
              size: 8.sp,
              color: MyColors.darkGreenColor,
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
