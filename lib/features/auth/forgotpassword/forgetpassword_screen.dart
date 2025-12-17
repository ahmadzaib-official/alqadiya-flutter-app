import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/utils/validator.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/auth_heading.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/features/auth/controller/signin_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ForgetpasswordScreen extends StatelessWidget with Validators {
  ForgetpasswordScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: GetBuilder(
          init: SignInController(),
          builder: (controller) {
            return Column(
              children: [
                Expanded(
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
                            actionButtonText: 'Log in',
                            onTap: () {
                              Get.toNamed(AppRoutes.sigin);
                            },
                          ),
                          Spacer(flex: 1),
                          Center(
                            child: Text(
                              'Forget Password'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Center(
                            child: Text(
                              'Enter your phone number to reset your password.'
                                  .tr,
                              style: AppTextStyles.bodyTextRegular16().copyWith(
                                color: MyColors.white.withValues(alpha: 0.7),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          Form(
                            key: formKey,
                            child: CustomTextfield(
                              label: 'Phone'.tr,
                              hintText: 'Phone'.tr,
                              labelVisible: false,
                              controller:
                                  controller.phorgetPhoneNumberController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.phone,
                              autoValidate: true,
                              prefix: Padding(
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
                                  ],
                                ),
                              ),
                              validator: validatePhoneNumber,
                            ),
                          ),
                          SizedBox(height: 24.h),

                          Obx(
                            () => CustomButton(
                              text: 'Send OTP'.tr,
                              isLoading: controller.isVerify.value,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  controller.forgetPassword();
                                }
                              },
                            ),
                          ),
                          Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ),
                // Language button pinned to bottom
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Center(
                    child: LanguageSelectionButton(isShadow: false),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
