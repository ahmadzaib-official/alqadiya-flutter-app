import 'package:alqadiya_game/core/style/decoration.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppWidget extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final bool showBackgroundImage; // <-- new parameter

  const CustomAppWidget({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    this.showBackgroundImage = false, // <-- default false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyDecorations.decorationBlue.copyWith(
        borderRadius: BorderRadius.circular(16.r),
        image:
            showBackgroundImage
                ? const DecorationImage(
                  image: AssetImage('assets/images/backgroundshade.png'),
                  fit: BoxFit.cover,
                )
                : null, // <-- condition added here
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          SvgPicture.asset(iconPath, width: 60.w),
          SizedBox(width: 10.w),
          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  title,
                  style: AppTextStyles.bodyTextMedium16().copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                // Subtitle
                Text(
                  subtitle,
                  style: AppTextStyles.captionRegular10().copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                    height: 1.0,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
