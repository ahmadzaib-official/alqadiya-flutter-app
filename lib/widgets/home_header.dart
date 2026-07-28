import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/services/auth_guard.dart';
import 'package:alqadiya_game/core/services/screen_cast_service.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'dart:io';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.onProfileTap,
    required this.actionButtons,
    this.title,
    this.showDivider = true,
  });
  final VoidCallback? onProfileTap;
  final Widget actionButtons;
  final Widget? title;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final castService = Get.find<ScreenCastService>();

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
                          AuthGuard.executeIfAuthenticated(
                            title: 'Profile Access'.tr,
                            message: 'Please sign in to view your profile'.tr,
                            action: () => Get.toNamed(AppRoutes.settingsScreen),
                          );
                        },
                    child: CircleAvatar(
                      backgroundColor: MyColors.darkBlueColor,
                      backgroundImage:
                          userController.user.value?.photoUrl != null
                              ? CachedNetworkImageProvider(
                                userController.user.value!.photoUrl!,
                              )
                              : AssetImage(MyIcons.userImage),
                      radius: 9.sp,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  GestureDetector(
                    onTap: () {
                      castService.showCastPicker();
                    },
                    child: Stack(
                      children: [
                        SvgPicture.asset(MyIcons.chromecast),
                        // Show indicator when connected
                        if (castService.isConnected.value)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 6.sp,
                              height: 6.sp,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: MyColors.backgroundColor,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
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
