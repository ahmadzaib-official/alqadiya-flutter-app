import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/auth/controller/verify_otp_controller.dart';
import 'package:alqadiya_game/widgets/custom_header.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:alqadiya_game/widgets/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final focusNode = FocusNode();

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: AppTextStyles.labelMedium14(),
      decoration: BoxDecoration(
        border: GradientBoxBorder(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColors.redButtonColor.withValues(alpha: 0.1),
              MyColors.redButtonColor,
            ],
          ),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
        color: MyColors.redButtonColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
      ),
    );

    final focusedPinTheme = defaultPinTheme;
    final errorPinTheme = defaultPinTheme;
    final disablePinTheme = defaultPinTheme;
    final followingPinTheme = defaultPinTheme;

    final submittedPinTheme = defaultPinTheme;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: GetBuilder(
          init: VerificationController(),
          builder: (controller) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
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
                            CustomHeader(
                              onBack: () {
                                Get.offAndToNamed(AppRoutes.sigin);
                              },
                              showLogoOnLeft: !controller.isRegister,
                            ),
                            Spacer(flex: 1),
                            Center(
                              child: Text(
                                controller.isRegister
                                    ? 'OTP'.tr
                                    : 'Reset Password'.tr,
                                style: AppTextStyles.heading1().copyWith(
                                  fontSize: 28.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Center(
                              child: Text(
                                'Please enter the code sent via SMS to your phone number'
                                    .tr,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyTextRegular16()
                                    .copyWith(
                                      color: MyColors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12.sp,
                                    ),
                              ),
                            ),
                            SizedBox(height: 4.h),

                            Center(
                              child: Text(
                                controller.phoneNumber,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyTextRegular16()
                                    .copyWith(
                                      color: MyColors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            Form(
                              key: formKey,
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(focusNode);
                                },
                                child: Pinput(
                                  length: 6,
                                  controller: controller.pinputController,
                                  focusNode: focusNode,
                                  defaultPinTheme: defaultPinTheme,
                                  followingPinTheme: followingPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  errorPinTheme: errorPinTheme,
                                  disabledPinTheme: disablePinTheme,
                                  showCursor: true,
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  onChanged: (value) {
                                    controller.otp.value = value;
                                  },
                                  onCompleted: (pin) {
                                    controller.otp.value = pin;
                                  },
                                  validator:
                                      (value) =>
                                          value == null || value.length < 6
                                              ? 'Please enter a valid OTP'.tr
                                              : null,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Obx(
                              () => Center(
                                child: Text(
                                  formatTime(controller.countdown.value),
                                  style: AppTextStyles.labelMedium14().copyWith(
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Obx(
                              () => CustomButton(
                                isLoading: controller.isVeifyOtp.value,
                                backgroundColor:
                                    controller.isButtonEnabled.value
                                        ? MyColors.redButtonColor
                                        : MyColors.redButtonColor,
                                text:
                                    controller.isRegister
                                        ? 'Verify Code'.tr
                                        : 'Verify'.tr,
                                textColor:
                                    controller.isButtonEnabled.value
                                        ? MyColors.white
                                        : MyColors.white,
                                onPressed: () async {
                                  // if (controller.isRegister) {
                                  //   Get.offAllNamed(
                                  //     AppRoutes.verifcationSussesfulscreen,
                                  //     arguments: {
                                  //       'title': 'Create an account',
                                  //       'message':
                                  //           'Account created successfully',
                                  //       'isRegister': true,
                                  //     },
                                  //   );
                                  // } else {
                                  //   Get.offAllNamed(
                                  //     AppRoutes.newPasswordScreen,
                                  //   );
                                  // }

                                  if (controller.isButtonEnabled.value) {
                                    if (formKey.currentState!.validate()) {
                                      if (controller.isRegister) {
                                        final surccess =
                                            await controller.verifyOtp();
                                        if (surccess) {
                                          Get.offAllNamed(
                                            AppRoutes
                                                .verifcationSussesfulscreen,
                                            arguments: {
                                              'title': 'Create an account'.tr,
                                              'message':
                                                  'Account created successfully'.tr,
                                              'isRegister': true,
                                            },
                                          );
                                        }
                                      } else if (controller.isForgotPassword) {
                                        final surccess =
                                            await controller.verifyOtp();
                                        if (surccess) {
                                          Get.offAllNamed(
                                            AppRoutes.newPasswordScreen,
                                          );
                                        }
                                      } else if (controller.isRegister) {
                                        final surccess =
                                            await controller.verifyPhoneOtp();
                                        if (surccess) {
                                          Get.offAllNamed(
                                            AppRoutes
                                                .verifcationSussesfulscreen,
                                            arguments: {
                                              'title': 'Create an account'.tr,
                                              'message':
                                                  'Account created successfully'.tr,
                                              'isVerified': true,
                                            },
                                          );
                                        }
                                      }
                                    }
                                  } else {
                                    Toaster.showToast("Please enter the OTP".tr);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Obx(
                              () => CustomOutlineButton(
                                isLoading: controller.isResendingOtp.value,
                                textColor: MyColors.white.withValues(
                                  alpha: 0.5,
                                ),
                                outlineColor: MyColors.white.withValues(
                                  alpha: 0.1,
                                ),
                                text:
                                    controller.isRegister
                                        ? 'Resend OTP'.tr
                                        : 'Resend Password'.tr,
                                onPressed:
                                    controller.countdown.value > 0 ||
                                            controller.isResendingOtp.value
                                        ? () {}
                                        : () {
                                          controller.resendCode();
                                        },
                              ),
                            ),
                            // if (!controller.isRegister) ...[
                            //   SizedBox(height: 24.h),
                            //   Divider(
                            //     color: MyColors.white.withValues(alpha: 0.1),
                            //     thickness: 1,
                            //   ),
                            //   SizedBox(height: 12.h),
                            //   Center(
                            //     child: Text(
                            //       'The phone is currently unavailable.'.tr,
                            //       style: AppTextStyles.labelMedium14().copyWith(
                            //         color: MyColors.white.withValues(
                            //           alpha: 0.5,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            //   SizedBox(height: 12.h),
                            //   Obx(
                            //     () => CustomOutlineButton(
                            //       isLoading: controller.isVeifyOtp.value,
                            //       textColor: MyColors.white.withValues(
                            //         alpha: 0.5,
                            //       ),
                            //       outlineColor: MyColors.white.withValues(
                            //         alpha: 0.1,
                            //       ),
                            //       text:
                            //           controller.isEmailVerfication == false
                            //               ? 'Send the code via email'.tr
                            //               : 'Send the code via phone'.tr,
                            //       onPressed: () {},
                            //     ),
                            //   ),
                            //   Spacer(flex: 1),
                            // ] else
                            Spacer(flex: 1),
                            Center(
                              child: LanguageSelectionButton(isShadow: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
