import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/auth_heading.dart' show AuthHeading;
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/onboard/controller/onbording_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final controller = Get.find<OnboardingController>();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(MyImages.onboard1),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.11, 0.46, 0.88],
              colors: [
                Color(0xff141B25),
                Color(0xff141B25).withValues(alpha: 0.45),
                Color(0xff141B25),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AuthHeading(
                  screenHeight: screenHeight,
                  actionButtonIcon: MyImages.lock,
                  actionButtonText: 'Log in',
                  onTap: () {
                    Get.toNamed(AppRoutes.sigin);
                  },
                ),
                Spacer(),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.updateIndex,
                    itemCount: controller.onboardingPages.length,
                    itemBuilder: (context, index) {
                      final page = controller.onboardingPages[index];
                      return Column(
                        children: [
                          Text(
                            page.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.heading1().copyWith(
                              color: MyColors.white,
                              fontSize: 36.sp,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Text(
                            page.description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyTextMedium16bold()
                                .copyWith(
                                  color: MyColors.white,
                                  fontSize: 14.sp,
                                ),
                            maxLines: 2,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                SizedBox(height: 0.05.sh),

                // Indicators with animation
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      controller.onboardingPages.length,
                      (index) => AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.01,
                        ),
                        width:
                            controller.currentIndex.value == index
                                ? screenWidth * 0.04
                                : screenWidth * 0.02,
                        height: screenWidth * 0.02,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              controller.currentIndex.value == index
                                  ? MyColors.redButtonColor
                                  : MyColors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                // Buttons
                CustomButton(
                  text: 'start_now'.tr,
                  onPressed: () {
                    Get.offNamedUntil(AppRoutes.tutorial, (route) => false);
                  },
                  isLoading: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
