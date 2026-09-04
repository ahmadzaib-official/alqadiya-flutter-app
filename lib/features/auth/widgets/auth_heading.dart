import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AuthHeading extends StatelessWidget {
  const AuthHeading({
    super.key,
    required this.screenHeight,
    required this.actionButtonText,
    required this.actionButtonIcon,
    required this.onTap,
  });

  final double screenHeight;
  final String actionButtonText;
  final String actionButtonIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(image: AssetImage(MyImages.appicon), height: 60.h),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(actionButtonIcon, height: 20.h),
              SizedBox(width: screenHeight * 0.01),
              Text(
                actionButtonText,
                style: AppTextStyles.captionBold10().copyWith(
                  color: MyColors.white.withValues(alpha: 0.5),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
