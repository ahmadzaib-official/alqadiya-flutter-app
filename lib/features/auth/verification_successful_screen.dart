import 'package:alqadiya_game/core/utils/spacing.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/animation_entry_wrapper.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/widgets/custom_header.dart';
import 'package:alqadiya_game/widgets/language_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VerificationSuccessfulScreen extends StatelessWidget {
  const VerificationSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = Get.arguments['title'] ?? 'Verification Successful'.tr;
    final String message =
        Get.arguments['message'] ??
        'Your phone number has been successfully verified. You can now proceed to the next step.'
            .tr;
    final bool isRegister = Get.arguments['isRegister'] ?? false;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  child: AnimatedEntryWrapper(
                    child: Column(
                      children: [
                        CustomHeader(
                          showLogoOnLeft: !isRegister,
                          onBack: () {
                            Get.offNamedUntil(
                              AppRoutes.sigin,
                              (route) => false,
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.1),
                        Stack(
                          children: [
                            SvgPicture.asset(
                              isRegister
                                  ? MyIcons.elipsisuser
                                  : MyIcons.rectangleellipsis,
                            ),
                            Positioned(
                              right: 0,
                              top: 12.h,
                              child: SvgPicture.asset(MyIcons.brown_check),
                            ),
                          ],
                        ),
                        AppSizedBoxes.largeSizedBox,
                        Text(
                          title,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 30.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSizedBoxes.smallSizedBox,
                        Text(
                          message,
                          style: AppTextStyles.bodyTextRegular16().copyWith(
                            color: MyColors.white.withValues(alpha: 0.7),
                            fontSize: 16.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSizedBoxes.largeSizedBox,
                        CustomButton(
                          text:
                              Get.arguments['isVerified'] == true
                                  ? 'Done'.tr
                                  : Get.arguments['isDeleteAccount'] == true
                                  ? 'Done'.tr
                                  : isRegister
                                  ? 'Log in to the app'.tr
                                  : 'Log in to the app'.tr,
                          onPressed: () async {
                            if (Get.arguments['isVerified'] == true) {
                              Get.offAllNamed(AppRoutes.userProfileScreen);
                            } else if (isRegister) {
                              // Navigate to Dashboard
                              Get.toNamed(AppRoutes.sigin);
                            } else {
                              if (Get.arguments['isDeleteAccount'] == true) {
                                // Logout on delete account
                                Get.find<Preferences>().logout();
                              } else {
                                // Navigate to Login screen
                                Get.offAllNamed(AppRoutes.sigin);
                              }
                            }
                          },
                        ),
                        AppSizedBoxes.normalSizedBox,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Language button pinned to bottom
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Center(child: LanguageSelectionButton(isShadow: false)),
            ),
          ],
        ),
      ),
    );
  }
}
