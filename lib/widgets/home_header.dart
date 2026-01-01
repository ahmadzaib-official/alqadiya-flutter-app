import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.onChromTap,
    this.onProfileTap,
    required this.actionButtons,
    this.title,
    this.showDivider = true,
  });
  final VoidCallback? onProfileTap;
  final VoidCallback onChromTap;
  final Widget actionButtons;
  final Widget? title;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Obx(
      () => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap:
                        onProfileTap ??
                        () {
                          Get.toNamed(AppRoutes.settingsScreen);
                        },
                    child: CircleAvatar(
                      backgroundColor: MyColors.redButtonColor,
                      backgroundImage: CachedNetworkImageProvider(
                        userController.user.value?.photoUrl ??
                            "https://www.pngfind.com/pngs/m/610-6104451_image-placeholder-png-user-profile-placeholder-image-png.png",
                      ),
                      radius: 9.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: onChromTap,
                    child: SvgPicture.asset(MyIcons.chromecast),
                  ),
                ],
              ),
              title ?? SizedBox.shrink(),
              actionButtons,
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: 5.h),
            Divider(color: MyColors.white.withValues(alpha: 0.1)),
          ],
        ],
      ),
    );
  }
}
