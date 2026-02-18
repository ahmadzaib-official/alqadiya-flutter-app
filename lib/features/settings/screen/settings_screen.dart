import 'dart:io';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/change_language/controller/language_controller.dart';
import 'package:alqadiya_game/features/settings/controller/settings_provider.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/dense_text_field.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize settings controller
    final settingsController = Get.find<SettingsController>();
    final userController = Get.find<UserController>();
    final languageController = Get.find<ChangeLanguageController>();

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
                  onTap: () => Navigator.pop(context),
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
                        context: context,
                        controller: userController,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Middle Column - General Settings
                    Expanded(
                      child: _buildGeneralSettingsSection(
                        context: context,
                        settingsController: settingsController,
                        languageController: languageController,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Right Column - Support and Guidance
                    Expanded(child: _buildSupportSection(settingsController, userController)),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
              child: _buildFooter(context, settingsController, userController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileSection({
    required BuildContext context,
    required UserController controller,
  }) {
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
              backgroundColor: MyColors.redButtonColor.withValues(alpha: 0.2),
              backgroundImage:
                  (controller.user.value?.photoUrl != null &&
                          controller.user.value!.photoUrl!.isNotEmpty)
                      ? CachedNetworkImageProvider(
                        controller.user.value!.photoUrl!,
                      )
                      : null,
              child:
                  (controller.user.value?.photoUrl == null ||
                          controller.user.value!.photoUrl!.isEmpty)
                      ? Icon(Icons.person, size: 20.sp, color: MyColors.white)
                      : null,
            ),
            SizedBox(height: 15.h),
            // User Information
            _buildInfoRow('Name:'.tr, controller.user.value?.fullName ?? ""),
            SizedBox(height: 8.h),
            _buildInfoRow(
              'Phone:'.tr,
              controller.user.value?.phoneNumber != null
                  ? '${controller.user.value?.phoneNumber ?? ""}'
                  // ? '${controller.user.value?.callingCode ?? ""} ${controller.user.value?.phoneNumber ?? ""}'
                  : "N/A".tr,
            ),
            if (controller.user.value?.email != null &&
                controller.user.value!.email!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Email:'.tr, controller.user.value?.email ?? ""),
            ],
            SizedBox(height: 16.h),
            // Edit profile button
            Builder(
              builder:
                  (context) => GestureDetector(
                    onTap: () {
                      _showEditProfileDialog(context, controller);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
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
            child: SizedBox(
              width: 0.16.sw,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 6.sp,
                  color: MyColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsSection({
    required BuildContext context,
    required SettingsController settingsController,
    required ChangeLanguageController languageController,
  }) {
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
              LanguageSelectionButton(
                height: 50.h,
                width: 50.w,
                color: MyColors.black.withValues(alpha: 0.2),
                textFontSize: 6.sp,
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
            onTap: () async {
              final url = Uri.parse('http://51.112.131.120/privacy-policy');
              try {
                if (await canLaunchUrl(url)) {
                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                
                }
              } catch (e) {
                print('Could not launch URL: $e');
              }
            },
          ),
          SizedBox(height: 10.h),
          // Replay demonstration program button
          // _buildSettingsButton(
          //   'Replay demonstration program'.tr,
          //   onTap: () {
          //     // Navigate to tutorial/demo
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(SettingsController controller, UserController userController) {
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
              final phoneNumber = userController.user.value?.phoneNumber;
              if (phoneNumber == null || phoneNumber.isEmpty) return;
              
              // Clean the number - remove spaces, dashes, etc. Keep only digits and +
              final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
              
              // Try WhatsApp scheme first (works on both iOS and Android when WhatsApp is installed)
              final whatsappUrl = 'whatsapp://send?phone=$cleanNumber';
              final whatsappUri = Uri.parse(whatsappUrl);
              
              // Try to launch WhatsApp directly
              try {
                bool launched = await launchUrl(
                  whatsappUri,
                  mode: LaunchMode.externalApplication,
                );
                
                // If WhatsApp scheme fails, fallback to web URL
                if (!launched) {
                  final webUrl = 'https://wa.me/$cleanNumber';
                  await launchUrl(
                    Uri.parse(webUrl),
                    mode: LaunchMode.externalApplication,
                  );
                }
              } catch (e) {
                // If both fail, try web URL as last resort
                final webUrl = 'https://wa.me/$cleanNumber';
                await launchUrl(
                  Uri.parse(webUrl),
                  mode: LaunchMode.externalApplication,
                );
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
              final phoneNumber = userController.user.value?.phoneNumber;
              if (phoneNumber == null || phoneNumber.isEmpty) return;
              
              // Clean the number - remove spaces, dashes, etc. Keep only digits and +
              final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
              final url = 'tel:$cleanNumber';
              
              try {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                print('Could not launch phone call: $e');
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

  Widget _buildFooter(
    BuildContext context,
    SettingsController controller,
    UserController userController,
  ) {
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
                '${userController.user.value?.pointsBalance ?? 0}',
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
                    Get.locale?.languageCode == 'en'
                        ? SvgPicture.asset(MyIcons.arrow_right)
                        : Icon(Icons.arrow_forward_ios, size: 6.sp,color: const Color.fromARGB(255, 214, 213, 213),),
                    Spacer(flex: 1),
                  ],
                ),
              ),
            ),
            Spacer(),

            // Delete account
            GestureDetector(
              onTap: () => _showDeleteAccountDialog(context, userController),
              child: Container(
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
            ),
            SizedBox(width: 10.w),

            // Logout
            GestureDetector(
              onTap: () async {
                await Get.find<Preferences>().clear();
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                Get.offAllNamed(AppRoutes.sigin);
              },
              child: Container(
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
                    Icon(
                      Icons.logout,
                      color: MyColors.white.withValues(alpha: 0.5),
                      size: 10.w,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Logout'.tr,
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 7.sp,
                        color: MyColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, UserController controller) {
    final nameController = TextEditingController(
      text: controller.user.value?.fullName ?? '',
    );
    final emailController = TextEditingController(
      text: controller.user.value?.email ?? '',
    );
    final phoneController = TextEditingController(
      text: controller.user.value?.phoneNumber?.toString() ?? '',
    );
    File? selectedImage;
    String? photoId;

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Dialog(
                  backgroundColor: Colors.transparent,
                  // insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.sp,
                      vertical: 3,
                    ),
                    constraints: BoxConstraints(maxWidth: 220.w),

                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(MyImages.gamebackground),
                        fit: BoxFit.cover,
                      ),
                      // color: MyColors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   'Edit Profile'.tr,
                          //   style: AppTextStyles.captionBold10().copyWith(
                          //     color: MyColors.white,
                          //   ),
                          // ),
                          SizedBox(height: 20.h),
                          // Profile Picture
                          GestureDetector(
                            onTap: () async {
                              final picker = ImagePicker();
                              final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                              );
                              if (pickedFile != null) {
                                setState(() {
                                  selectedImage = File(pickedFile.path);
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 20.w,
                                  backgroundColor: MyColors.redButtonColor
                                      .withValues(alpha: 0.2),
                                  backgroundImage:
                                      selectedImage != null
                                          ? FileImage(selectedImage!)
                                          : (controller.user.value?.photoUrl !=
                                                      null
                                                  ? CachedNetworkImageProvider(
                                                    controller
                                                        .user
                                                        .value!
                                                        .photoUrl!,
                                                  )
                                                  : null)
                                              as ImageProvider?,
                                  child:
                                      controller.user.value?.photoUrl == null &&
                                              selectedImage == null
                                          ? Icon(
                                            Icons.person,
                                            size: 20.sp,
                                            color: MyColors.white,
                                          )
                                          : null,
                                ),
                                Positioned(
                                  bottom: 1.5.sp,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(2.5.sp),
                                    decoration: BoxDecoration(
                                      color: MyColors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      size: 5.sp,
                                      color: MyColors.redButtonColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Name Field
                          DenseTextField(
                            label: 'Full Name'.tr,
                            controller: nameController,
                            hintText: 'Enter full name'.tr,
                            labelFontSize: 8,
                            textFontSize: 10,
                            hintFontSize: 8,
                            width: 150.w,
                          ),
                          SizedBox(height: 12.h),
                          // Phone Number Field
                          DenseTextField(
                            label: 'Phone Number'.tr,
                            controller: phoneController,
                            hintText: 'Enter your number'.tr,
                            keyboardType: TextInputType.phone,
                            labelFontSize: 8,
                            textFontSize: 10,
                            hintFontSize: 8,
                            width: 150.w,
                          ),
                          // SizedBox(height: 12.h),
                          // // Email Field
                          // DenseTextField(
                          //   label: 'Email'.tr,
                          //   controller: emailController,
                          //   hintText: 'Enter email'.tr,
                          //   keyboardType: TextInputType.emailAddress,
                          //   textFontSize: 10,
                          //   hintFontSize: 9,
                          //   width: 150.w,
                          // ),
                          // SizedBox(height: 20.h),
                          // Points balance section
                          // Obx(
                          //   () => Text(
                          //     '${'My points balance'.tr} ${controller.user.value?.pointsBalance ?? 0}',
                          //     style: AppTextStyles.heading2().copyWith(
                          //       fontSize: 9.sp,
                          //       color: MyColors.white.withValues(alpha: 0.8),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 20.h),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Cancel Button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: MyColors.black.withValues(
                                        alpha: 0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Cancel'.tr,
                                        style: AppTextStyles.heading2()
                                            .copyWith(
                                              fontSize: 8.sp,
                                              color: MyColors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              // Save Button
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap:
                                        controller.isUpdatingProfile.value
                                            ? null
                                            : () async {
                                              print('Save button tapped');
                                              String? finalPhotoId = photoId;

                                              // Upload photo if selected
                                              if (selectedImage != null) {
                                                print('Uploading photo...');
                                                final uploadId =
                                                    await controller
                                                        .uploadPhotoToS3(
                                                          selectedImage!,
                                                        );
                                                if (uploadId != null) {
                                                  finalPhotoId = uploadId;
                                                  print(
                                                    'Photo uploaded, uploadId: $uploadId',
                                                  );
                                                } else {
                                                  print('Photo upload failed');
                                                  return; // Stop if upload failed
                                                }
                                              }

                                              print(
                                                'Calling updateProfile API...',
                                              );
                                              // Update profile
                                              final success = await controller
                                                  .updateProfile(
                                                    fullName:
                                                        nameController.text
                                                            .trim(),
                                                    email:
                                                        emailController.text
                                                                .trim()
                                                                .isEmpty
                                                            ? null
                                                            : emailController
                                                                .text
                                                                .trim(),
                                                    phoneNumber:
                                                        phoneController.text
                                                                .trim()
                                                                .isEmpty
                                                            ? null
                                                            : phoneController
                                                                .text
                                                                .trim(),
                                                    callingCode:
                                                        controller
                                                            .user
                                                            .value
                                                            ?.callingCode
                                                            ?.toString(),
                                                    countryCode:
                                                        controller
                                                            .user
                                                            .value
                                                            ?.countryCode
                                                            ?.toString(),
                                                    photoId: finalPhotoId,
                                                  );

                                              print(
                                                'Update profile result: $success',
                                              );
                                              if (success) {
                                                // Close dialog immediately
                                                if (Navigator.canPop(context)) {
                                                  Navigator.pop(context);
                                                } else {
                                                  // Fallback for GetX dialog
                                                  Get.back();
                                                }
                                              }
                                            },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.isUpdatingProfile.value
                                                ? MyColors.greenColor
                                                    .withValues(alpha: 0.5)
                                                : MyColors.greenColor,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Center(
                                        child:
                                            controller.isUpdatingProfile.value
                                                ? SizedBox(
                                                  width: 20.w,
                                                  height: 20.h,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                          Color
                                                        >(MyColors.white),
                                                  ),
                                                )
                                                : Text(
                                                  'Save'.tr,
                                                  style:
                                                      AppTextStyles.heading2()
                                                          .copyWith(
                                                            fontSize: 8.sp,
                                                            color:
                                                                MyColors.white,
                                                          ),
                                                ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    UserController controller,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 20.h),
              constraints: BoxConstraints(maxWidth: 200.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(MyImages.gamebackground),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Warning Icon
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 25.sp,
                    color: MyColors.redButtonColor,
                  ),
                  SizedBox(height: 15.h),

                  // Title
                  Text(
                    'Delete Account'.tr,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 10.sp,
                      color: MyColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Confirmation message
                  Text(
                    'Are you sure you want to delete your account? This action cannot be undone.'.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyTextMedium16().copyWith(
                      fontSize: 7.sp,
                      color: MyColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel Button
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color: MyColors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel'.tr,
                                style: AppTextStyles.heading2().copyWith(
                                  fontSize: 8.sp,
                                  color: MyColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Delete Button
                      Expanded(
                        child: Obx(
                          () => GestureDetector(
                            onTap:
                                controller.isDeletingAccount.value
                                    ? null
                                    : () async {
                                      final success =
                                          await controller.deleteAccount();
                                      if (success) {
                                        // Close dialog
                                        Navigator.of(context).pop();
                                        await SystemChrome.setPreferredOrientations(
                                          [
                                            DeviceOrientation.portraitUp,
                                            DeviceOrientation.portraitDown,
                                          ],
                                        );
                                        // Navigate to sign in screen
                                        Get.offAllNamed(AppRoutes.sigin);
                                      }
                                    },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color:
                                    controller.isDeletingAccount.value
                                        ? MyColors.redButtonColor.withValues(
                                          alpha: 0.5,
                                        )
                                        : MyColors.redButtonColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child:
                                    controller.isDeletingAccount.value
                                        ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  MyColors.white,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          'Delete'.tr,
                                          style: AppTextStyles.heading2()
                                              .copyWith(
                                                fontSize: 8.sp,
                                                color: MyColors.white,
                                              ),
                                        ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
