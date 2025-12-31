import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/auth_heading.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:alqadiya_game/widgets/social_button.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/auth/controller/signup_controller.dart';
import 'package:alqadiya_game/core/utils/validator.dart';
import 'package:alqadiya_game/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignupScreen extends StatelessWidget with Validators {
  SignupScreen({super.key});
  final controller = Get.find<SignupController>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics:
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: AnimatedEntryWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthHeading(
                            screenHeight: screenHeight,
                            actionButtonIcon: MyImages.lock,
                            actionButtonText: 'Log in'.tr,
                            onTap: () {
                              Get.offNamedUntil(
                                AppRoutes.sigin,
                                (route) => false,
                              );
                            },
                          ),
                          Spacer(flex: 2),

                          // Title and Description
                          Center(
                            child: Text(
                              'Create an account'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 28.sp,
                              ),
                            ),
                          ),
                          Spacer(flex: 1),

                          // Form Fields
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomTextfield(
                                  maxLines: 1,

                                  label: 'Full Name'.tr,
                                  hintText: 'Full Name'.tr,
                                  labelVisible: false,
                                  controller: controller.fullNameController,
                                  autoValidate: true,
                                  validator: validateName,
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Iconsax.user,
                                      color: MyColors.redButtonColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                // Obx(
                                //   () =>
                                CustomTextfield(
                                  maxLines: 1,
                                  label: 'Phone'.tr,
                                  hintText: 'Phone'.tr,
                                  //  label: 'Phone / Email'.tr,
                                  // hintText: 'Phone / Email'.tr,
                                  labelVisible: false,
                                  controller: controller.phoneNumberController,
                                  autoValidate: true,
                                  keyboardType:
                                      // controller.isEmailInput.value
                                      //     ? TextInputType.emailAddress
                                      //     :
                                      TextInputType.phone,
                                  // onChanged: (value) {
                                  //   controller.updatePhoneOrEmailInput(value);
                                  // },
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      // controller.isEmailInput.value
                                      //     ? Icons.mail_outline_rounded
                                      //     :
                                      Icons.phone_android_rounded,
                                      color: MyColors.redButtonColor,
                                    ),
                                  ),
                                  prefix:
                                  // controller.isEmailInput.value
                                  //     ? null
                                  //     :
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 14.0,
                                      right: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          MyIcons.flag,
                                          width: 17.w,
                                          height: 17.h,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          '+965',
                                          style: TextStyle(fontSize: 16.sp),
                                        ),
                                        SizedBox(
                                          height: 18.h,
                                          child: VerticalDivider(
                                            color: MyColors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  validator: validatePhoneNumber,
                                  // validator: validatePhoneOrEmail,
                                ),

                                // ),
                                SizedBox(height: 12.h),
                                Obx(
                                  () => CustomTextfield(
                                    maxLines: 1,
                                    label: 'Password'.tr,
                                    hintText: 'Password'.tr,
                                    labelVisible: false,
                                    controller: controller.passwordController,
                                    obscureText: controller.isEye.value,
                                    autoValidate: true,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        controller.toggleEye();
                                      },
                                      child: Icon(
                                        controller.isEye.value
                                            ? Iconsax.eye_slash
                                            : Iconsax.eye,
                                        color: MyColors.redButtonColor,
                                      ),
                                    ),
                                    validator: validatePassword,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Obx(
                                  () => CustomTextfield(
                                    maxLines: 1,

                                    label: 'Confirm Password'.tr,
                                    hintText: 'Confirm Password'.tr,
                                    labelVisible: false,
                                    controller:
                                        controller.confirmPasswordController,
                                    obscureText: controller.isEyeConfirm.value,
                                    autoValidate: true,
                                    suffix: GestureDetector(
                                      onTap: () {
                                        controller.toggleEyeConfirm();
                                      },
                                      child: Icon(
                                        controller.isEyeConfirm.value
                                            ? Iconsax.eye_slash
                                            : Iconsax.eye,
                                        color: MyColors.redButtonColor,
                                      ),
                                    ),
                                    validator:
                                        (p0) => validateConfirmPassword(
                                          controller.passwordController.text,
                                          controller
                                              .confirmPasswordController
                                              .text,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Terms and Conditions
                          Obx(
                            () => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.toggleTermsAccepted();
                                  },
                                  child: Container(
                                    width: 20.w,
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      color:
                                          controller.isTermsAccepted.value
                                              ? MyColors.redButtonColor
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: MyColors.redButtonColor,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:
                                        controller.isTermsAccepted.value
                                            ? Icon(
                                              Icons.check,
                                              size: 14.sp,
                                              color: MyColors.white,
                                            )
                                            : null,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.bodyTextRegular16()
                                          .copyWith(
                                            fontSize: 12.sp,
                                            color: MyColors.white.withValues(
                                              alpha: 0.7,
                                            ),
                                          ),
                                      children: [
                                        TextSpan(text: 'I agree to the '.tr),
                                        TextSpan(
                                          text: 'Terms and Conditions'.tr,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: MyColors.white,
                                            color: MyColors.white,
                                          ),
                                        ),
                                        TextSpan(text: ' and '.tr),
                                        TextSpan(
                                          text: 'Privacy Policy'.tr,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: MyColors.white,
                                            color: MyColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Register Button
                          GetBuilder<SignupController>(
                            builder: (controller) {
                              return CustomButton(
                                // isLoading: controller.isSignUp,
                                text: 'Register'.tr,
                                onPressed: () async {
                                  // Get.offAllNamed(
                                  //   AppRoutes.otpScreen,
                                  //   arguments: {
                                  //     'phoneNumber': '123456789',
                                  //     'userId': '1234-5678-9012',
                                  //     'isRegister': true,
                                  //   },
                                  // );
                                  if (formKey.currentState!.validate()) {
                                    if (controller.isTermsAccepted.value) {
                                      await controller.signUp();
                                    } else {
                                      Toaster.showToast(
                                        'Please accept the terms and conditions'.tr,
                                      );
                                    }
                                  }
                                },
                              );
                            },
                          ),

                          Spacer(flex: 1),

                          // Divider
                          Divider(
                            color: MyColors.white.withValues(alpha: 0.1),
                            thickness: 1,
                          ),
                          SizedBox(height: 12.h),

                          // Social Login
                          Center(
                            child: Text(
                              'Create an account by:'.tr,
                              style: AppTextStyles.labelMedium14().copyWith(
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialButton(
                                onTap: controller.signUpWithGoogle,
                                buttonText: 'Google'.tr,
                                buttonIcon: MyIcons.google,
                              ),
                              SizedBox(width: Responsive.width(5, context)),
                              SocialButton(
                                onTap: controller.signUpWithApple,
                                buttonText: 'Apple'.tr,
                                buttonIcon: MyIcons.apple,
                              ),
                            ],
                          ),

                          Spacer(flex: 1),

                          // Language Selection
                          Center(
                            child: LanguageSelectionButton(isShadow: false),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
