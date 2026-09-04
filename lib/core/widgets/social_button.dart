import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    required this.buttonIcon,
  });
  final VoidCallback onTap;
  final String buttonText;
  final String buttonIcon;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.sp),
            border: Border.all(color: MyColors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                buttonIcon,
                width: Responsive.width(7, context),
                height: 20.sp,
                // colorFilter: ColorFilter.mode(
                //   MyColors.white.withValues(alpha: 0.5),
                //   BlendMode.srcATop,
                // ),
              ),
              SizedBox(width: Responsive.width(3, context)),
              Text(
                buttonText,
                style: AppTextStyles.labelMedium14().copyWith(
                  color: MyColors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
