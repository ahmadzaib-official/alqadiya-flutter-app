import 'dart:io';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:alqadiya_game/features/auth/controller/user_controller.dart';
import 'package:alqadiya_game/features/change_language/controller/language_controller.dart';
import 'package:alqadiya_game/features/settings/controller/settings_provider.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/dense_text_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                    Expanded(child: _buildSupportSection(settingsController)),
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
              backgroundImage: CachedNetworkImageProvider(
                controller.user.value?.photoUrl ?? "https://i.pravatar.cc/300",
              ),
              child: SvgPicture.asset(MyIcons.camera),
            ),
            SizedBox(height: 15.h),
            // User Information
            _buildInfoRow('Name:', controller.user.value?.fullName ?? ""),
            SizedBox(height: 8.h),
            _buildInfoRow(
              'Phone:',
              controller.user.value?.phoneNumber != null
                  ? '${controller.user.value?.callingCode ?? ""} ${controller.user.value?.phoneNumber ?? ""}'
                  : "N/A",
            ),
            if (controller.user.value?.email != null &&
                controller.user.value!.email!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildInfoRow('Email:', controller.user.value?.email ?? ""),
            ],
            SizedBox(height: 16.h),
            // Edit profile button
            Builder(
              builder: (context) => GestureDetector(
                onTap: () {
                  _showEditProfileDialog(context, controller);
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
          GestureDetector(
            onTap: () => _showLanguageSelector(context, languageController),
            child: Row(
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
                      Obx(
                        () => SvgPicture.asset(
                          languageController.selectedLanguage.value.image ??
                              MyIcons.ukFlag,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Obx(
                        () => Text(
                          languageController.selectedLanguage.value.title ?? 'English',
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

  void _showLanguageSelector(
    BuildContext context,
    ChangeLanguageController languageController,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: MyColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.sp),

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MyImages.gamebackground),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Language'.tr,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 10.sp,
                  color: MyColors.white,
                ),
              ),
              SizedBox(height: 20.h),
              ...languageController.languageList.map((language) {
                return Obx(
                  () => GestureDetector(
                    onTap: () async {
                      await languageController.changeLanguage(language);
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      // Restart app to apply language change
                      Future.delayed(const Duration(milliseconds: 100), () {
                        Get.offAllNamed(AppRoutes.homescreen);
                      });
                    },
                    child: Container(
                      width: Responsive.width(40, context),
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        
                        color: languageController.selectedLanguage.value.slug ==
                                language.slug
                            ? MyColors.greenColor.withValues(alpha: 0.3)
                            : MyColors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: languageController.selectedLanguage.value.slug ==
                                  language.slug
                              ? MyColors.greenColor
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(language.image ?? MyIcons.ukFlag,width: 23,),
                          SizedBox(width: 10.w),
                          Text(
                            language.title ?? '',
                            style: AppTextStyles.heading2().copyWith(
                              fontSize: 8.sp,
                              color: MyColors.white,
                            ),
                          ),
                       
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserController controller,
  ) {
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
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          // insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 3),
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
                  Text(
                    'Edit Profile'.tr,
                    style: AppTextStyles.captionBold10().copyWith(
                      color: MyColors.white,
                    ),
                  ),
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
                          backgroundColor: MyColors.redButtonColor.withValues(alpha: 0.2),
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : (controller.user.value?.photoUrl != null
                                      ? CachedNetworkImageProvider(
                                          controller.user.value!.photoUrl!,
                                        )
                                      : null) as ImageProvider?,
                          child: controller.user.value?.photoUrl == null &&
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
                  SizedBox(height: 20.h),
                  // Name Field
                  DenseTextField(
                    label: 'Full Name'.tr,
                    controller: nameController,
                    hintText: 'Enter full name'.tr,
                    labelFontSize: 9,
                    textFontSize: 10,
                    hintFontSize: 9,
                    width: 150.w,
                  ),
                  SizedBox(height: 12.h),
                  // Phone Number Field
                  DenseTextField(
                    label: 'Phone Number'.tr,
                    controller: phoneController,
                    hintText: 'Enter your number'.tr,
                    keyboardType: TextInputType.phone,
                    labelFontSize: 9,
                    textFontSize: 10,
                    hintFontSize: 9,
                    width: 150.w,
                  ),
                  SizedBox(height: 12.h),
                  // Email Field
                  DenseTextField(
                    label: 'Email'.tr,
                    controller: emailController,
                    hintText: 'Enter email'.tr,
                    keyboardType: TextInputType.emailAddress,
                    textFontSize: 10,
                    hintFontSize: 9,
                    width: 150.w,
                  ),
                  SizedBox(height: 20.h),
                  // Points balance section
                  Obx(
                    () => Text(
                      'My points balance ${controller.user.value?.pointsBalance ?? 0}',
                      style: AppTextStyles.heading2().copyWith(
                        fontSize: 9.sp,
                        color: MyColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),
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
                      // Save Button
                      Expanded(
                        child: Obx(
                          () => GestureDetector(
                            onTap: controller.isUpdatingProfile.value
                                ? null
                                : () async {
                                    print('Save button tapped');
                                    String? finalPhotoId = photoId;
                                    
                                    // Upload photo if selected
                                    if (selectedImage != null) {
                                      print('Uploading photo...');
                                      final uploadId =
                                          await controller.uploadPhotoToS3(
                                        selectedImage!,
                                      );
                                      if (uploadId != null) {
                                        finalPhotoId = uploadId;
                                        print('Photo uploaded, uploadId: $uploadId');
                                      } else {
                                        print('Photo upload failed');
                                        return; // Stop if upload failed
                                      }
                                    }

                                    print('Calling updateProfile API...');
                                    // Update profile
                                    final success =
                                        await controller.updateProfile(
                                      fullName: nameController.text.trim(),
                                      email: emailController.text.trim().isEmpty
                                          ? null
                                          : emailController.text.trim(),
                                      phoneNumber: phoneController.text.trim().isEmpty
                                          ? null
                                          : phoneController.text.trim(),
                                      callingCode: controller.user.value?.callingCode?.toString(),
                                      countryCode: controller.user.value?.countryCode?.toString(),
                                      photoId: finalPhotoId,
                                    );

                                    print('Update profile result: $success');
                                    if (success) {
                                      // Close dialog after a small delay to avoid navigation conflicts
                                      await Future.delayed(const Duration(milliseconds: 300));
                                      if (context.mounted && Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              decoration: BoxDecoration(
                                color: controller.isUpdatingProfile.value
                                    ? MyColors.greenColor.withValues(alpha: 0.5)
                                    : MyColors.greenColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: controller.isUpdatingProfile.value
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
                                        'Save'.tr,
                                        style: AppTextStyles.heading2().copyWith(
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
          ),
        ),
      
    );
  }



}
