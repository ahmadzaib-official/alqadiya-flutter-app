import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/utils/responsive.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/auth_heading.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
// import 'package:alqadiya_game/widgets/language_selection_bottomsheet.dart'
//     show LanguageSelectionBottomSheet;
import 'package:alqadiya_game/widgets/social_button.dart';
import 'package:alqadiya_game/widgets/custom_textfield.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/auth/controller/signin_controller.dart';
import 'package:alqadiya_game/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SigninScreen extends StatelessWidget with Validators {
  SigninScreen({super.key});
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
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics:
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? NeverScrollableScrollPhysics()
                          : AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
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
                                AuthHeading(
                                  screenHeight: screenHeight,
                                  actionButtonIcon: MyIcons.register,
                                  actionButtonText: 'Register'.tr,
                                  onTap: () {
                                    Get.offNamedUntil(
                                      AppRoutes.signUp,
                                      (route) => false,
                                    );
                                  },
                                ),
                                Spacer(flex: 2),

                                Center(
                                  child: Text(
                                    'Log in'.tr,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                ),
                                Spacer(flex: 1),
                                CustomTextfield(
                                  maxLines: 1,
                                  // label: 'Phone / Email'.tr,
                                  // hintText: 'Phone / Email'.tr,
                                  label: 'Phone'.tr,
                                  hintText: 'Phone'.tr,
                                  controller: controller.phoneNumberController,
                                  autoValidate: true,
                                  labelVisible: false,
                                  keyboardType:
                                      // controller.isEmailInput
                                      //     ? TextInputType.emailAddress
                                      //     :
                                      TextInputType.phone,
                                  // onChanged: (value) {
                                  //   controller.updatePhoneOrEmailInput(value);
                                  // },
                                  suffix: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(MyIcons.user),
                                  ),
                                  validator: validatePhoneNumber,
                                  // validator: validatePhoneOrEmail,
                                ),

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
                                    onChanged: (value) {
                                      controller.passwordController.text =
                                          value;
                                    },
                                    validator: validatePassword,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoutes.forgotPassword);
                                  },
                                  child: Text(
                                    'I forgot my password'.tr,
                                    style: AppTextStyles.labelMedium14()
                                        .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationThickness: 1,
                                          decorationColor: MyColors.white
                                              .withValues(alpha: 0.7),
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          color: MyColors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                  ),
                                ),

                                SizedBox(height: 16.h),
                                Obx(
                                  () => CustomButton(
                                    isLoading: controller.isSignIn.value,
                                    text: 'Log In'.tr,
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        await controller.signIn();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                CustomOutlineButton(
                                  textColor: MyColors.white.withValues(
                                    alpha: 0.5,
                                  ),
                                  outlineColor: MyColors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  isLoading: false,
                                  text: 'Continue as a guest'.tr,
                                  onPressed: () async {
                                    goToHomeScreen();

                                    // if (formKey.currentState!.validate()) {
                                    //   controller.signIn();
                                    // }
                                  },
                                ),
                                Spacer(flex: 1),

                                Divider(
                                  color: MyColors.white.withValues(alpha: 0.1),
                                  thickness: 1,
                                ),
                                SizedBox(height: 12.h),
                                Center(
                                  child: Text(
                                    'Login by:'.tr,
                                    style: AppTextStyles.labelMedium14()
                                        .copyWith(
                                          color: MyColors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SocialButton(
                                      onTap: controller.signInWithGoogle,
                                      buttonText: 'Google'.tr,
                                      buttonIcon: MyIcons.google,
                                    ),
                                    SizedBox(
                                      width: Responsive.width(5, context),
                                    ),
                                    SocialButton(
                                      onTap: controller.signInWithApple,
                                      buttonText: 'Apple'.tr,
                                      buttonIcon: MyIcons.apple,
                                    ),
                                  ],
                                ),
                                Spacer(flex: 1),

                                Center(
                                  child: LanguageSelectionButton(
                                    isShadow: false,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void goToHomeScreen() async {
    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final prefs = Get.find<Preferences>();
    await prefs.setBool(AppStrings.isGuest, true);

    Future.delayed(Duration(milliseconds: 60), () {
      Get.offAllNamed(AppRoutes.homescreen);
    });
  }
}
