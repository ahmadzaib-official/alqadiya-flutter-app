import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/settings/controller/settings_provider.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize settings controller
    final settingsController = Get.find<SettingsController>();
    final userController = Get.find<UserController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
              child: HomeHeader(
                onChromTap: () {},
                title: Text(
                  'Settings'.tr,
                  style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                ),
                actionButtons: GestureDetector(
                  onTap: () => Get.back(),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),

            SizedBox(height: 5.h),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - User Profile
                    Expanded(
                      child: _buildUserProfileSection(
                        controller: userController,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Middle Column - General Settings
                    Expanded(
                      child: _buildGeneralSettingsSection(settingsController),
                    ),
                    SizedBox(width: 10.w),
                    // Right Column - Support and Guidance
                    Expanded(child: _buildSupportSection(settingsController)),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
              child: _buildFooter(context, settingsController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection({required UserController controller}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: MyColors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 15.w,
              backgroundImage: CachedNetworkImageProvider(
                controller.user.value?.photoUrl ?? "https://i.pravatar.cc/300",
              ),
              child: SvgPicture.asset(MyIcons.camera),
            ),
            SizedBox(height: 15.h),
            // User Information
            _buildInfoRow('Name:', controller.user.value?.fullName ?? ""),
            SizedBox(height: 8.h),
            _buildInfoRow('Age:', controller.user.value?.email ?? "18"),
            SizedBox(height: 8.h),
            _buildInfoRow(
              'Email:',
              controller.user.value?.email ?? "abc@gmail.com",
            ),
            SizedBox(height: 16.h),
            // Edit profile button
            GestureDetector(
              onTap: () {
                // Navigate to edit profile screen
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: MyColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Edit profile'.tr,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyTextMedium16().copyWith(
                fontSize: 6.sp,
                color: MyColors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,

            child: Text(
              value,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 6.sp,
                color: MyColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsSection(SettingsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'General Settings'.tr,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 8.sp,
              color: MyColors.white,
            ),
          ),
          SizedBox(height: 20.h),
          // Language Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: MyColors.black.withValues(alpha: 0.2),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(MyIcons.ukFlag),
                    SizedBox(width: 3.w),
                    Obx(
                      () => Text(
                        controller.selectedLanguage.value,
                        style: AppTextStyles.heading2().copyWith(
                          fontSize: 7.sp,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 10.w),

              Text(
                'Language'.tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 7.sp,
                  color: MyColors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Terms and Privacy Policy button
          _buildSettingsButton(
            'Terms and Privacy Policy'.tr,
            onTap: () {
              // Navigate to terms and privacy policy
            },
          ),
          SizedBox(height: 10.h),
          // Replay demonstration program button
          _buildSettingsButton(
            'Replay demonstration program'.tr,
            onTap: () {
              // Navigate to tutorial/demo
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(SettingsController controller) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Support and guidance'.tr,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 8.sp,
              color: MyColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15.h),
          // Via WhatsApp button
          GestureDetector(
            onTap: () async {
              final url =
                  'https://wa.me/1234567890'; // Replace with actual WhatsApp number
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: MyColors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Via WhatsApp'.tr,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  SvgPicture.asset(MyIcons.whatsapp),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Direct Call button
          _buildSettingsButton(
            'Direct Call'.tr,
            onTap: () async {
              final url = 'tel:+1234567890'; // Replace with actual phone number
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsButton(String text, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: MyColors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 6.sp,
              color: MyColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SettingsController controller) {
    return Column(
      children: [
        SizedBox(height: 5.h),
        Divider(color: MyColors.white.withValues(alpha: 0.1)),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Points balance and Buy Points button
            Text(
              'My points balance'.tr,
              style: AppTextStyles.heading2().copyWith(
                fontSize: 7.sp,
                color: MyColors.white.withValues(alpha: 0.7),
              ),
            ),
            SizedBox(width: 5.w),
            Obx(
              () => Text(
                '${controller.pointsBalance.value}',
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.white,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.buyPointsScreen);
              },
              child: Container(
                width: 60.w,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: MyColors.greenColor,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Spacer(flex: 6),
                    Text(
                      'Buy Points'.tr,
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 6.sp,
                        color: MyColors.white,
                      ),
                    ),
                    Spacer(flex: 1),

                    SvgPicture.asset(MyIcons.arrow_right),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
            Spacer(),
            // Delete account
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: MyColors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(100.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(MyIcons.deleteUser, width: 10.w),
                  SizedBox(width: 3.w),
                  Text(
                    'Delete account'.tr,
                    style: AppTextStyles.heading2().copyWith(
                      fontSize: 7.sp,
                      color: MyColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
