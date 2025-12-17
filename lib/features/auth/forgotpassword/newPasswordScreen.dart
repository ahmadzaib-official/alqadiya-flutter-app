import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/custom_header.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:alqadiya_game/features/auth/controller/signin_controller.dart';
import 'package:alqadiya_game/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NewPasswordScreen extends StatelessWidget with Validators {
  NewPasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: GetBuilder(
          init: SignInController(),
          builder: (controller) {
            return SingleChildScrollView(
              physics:
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          child: AnimatedEntryWrapper(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomHeader(
                                    showLogoOnLeft: true,
                                    onBack: () {
                                      Get.offAndToNamed(
                                        AppRoutes.forgotPassword,
                                      );
                                    },
                                  ),
                                  Spacer(flex: 1),
                                  Center(
                                    child: Text(
                                      'New Password'.tr,
                                      style: AppTextStyles.heading1().copyWith(
                                        fontSize: 30.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),

                                  Obx(
                                    () => CustomTextfield(
                                      hintText: 'Password'.tr,
                                      label: 'Password'.tr,
                                      labelVisible: false,
                                      controller: controller.newPassword,
                                      obscureText:
                                          controller.newPasswordEye.value,
                                      suffix: GestureDetector(
                                        onTap: () {
                                          controller.toggleEye();
                                        },
                                        child: Icon(
                                          controller.newPasswordEye.value
                                              ? Iconsax.eye_slash
                                              : Iconsax.eye,
                                          color: MyColors.redButtonColor,
                                        ),
                                      ),
                                      autoValidate: true,
                                      validator: validatePassword,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  Obx(
                                    () => CustomTextfield(
                                      hintText: 'Reset Password'.tr,
                                      label: 'Reset Password'.tr,
                                      labelVisible: false,
                                      controller: controller.confirmPassword,
                                      obscureText:
                                          controller.confirmPasswordEye.value,
                                      suffix: GestureDetector(
                                        onTap: () {
                                          controller.toggleEye();
                                        },
                                        child: Icon(
                                          controller.confirmPasswordEye.value
                                              ? Iconsax.eye_slash
                                              : Iconsax.eye,
                                          color: MyColors.redButtonColor,
                                        ),
                                      ),
                                      autoValidate: true,
                                      validator:
                                          (p0) => validateConfirmPassword(
                                            controller.newPassword.text,
                                            controller.confirmPassword.text,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),

                                  Obx(
                                    () => CustomButton(
                                      isLoading: controller.isReset.value,
                                      text: 'Confirm New Password'.tr,
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          controller.resetPassword();
                                        }
                                      },
                                    ),
                                  ),
                                  Spacer(flex: 3),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Language button pinned to bottom
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Center(
                          child: LanguageSelectionButton(isShadow: false),
                        ),
                      ),
                    ],
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
