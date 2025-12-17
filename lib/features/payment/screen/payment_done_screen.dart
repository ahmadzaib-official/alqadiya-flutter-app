import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/pdf_viewer.dart';
import 'package:alqadiya_game/features/payment/controller/payment_done_provider.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PaymentDoneScreen extends StatelessWidget {
  const PaymentDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize payment done controller
    final paymentDoneController = Get.find<PaymentDoneController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile avatar
                  CircleAvatar(
                    backgroundColor: MyColors.redButtonColor,
                    backgroundImage: CachedNetworkImageProvider(
                      "https://picsum.photos/200?random=1",
                    ),
                    radius: 20.sp,
                  ),
                  // Back icon
                  GestureDetector(
                    onTap: () {
                      goToHomeScreen();
                    },
                    child: SvgPicture.asset(MyIcons.arrowbackrounded),
                  ),
                ],
              ),
              Spacer(flex: 1),

              // Success Icon (Credit Card with Checkmark)
              Stack(
                children: [
                  SvgPicture.asset(MyIcons.payment_success),
                  Positioned(
                    right: 0,
                    top: 12.h,
                    child: SvgPicture.asset(MyIcons.brown_check),
                  ),
                ],
              ),

              SizedBox(height: 30.h),
              // Success Message
              Text(
                'Successfully completed'.tr,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 24.sp,
                  color: MyColors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              // Sub Message
              Text(
                'Payment has been made successfully.'.tr,
                style: AppTextStyles.heading2().copyWith(
                  fontSize: 12.sp,
                  color: MyColors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50.h),
              // Back to the app button
              CustomButton(
                text: 'Back to the app'.tr,
                onPressed: () {
                  // Navigate back to main app
                  goToHomeScreen();
                },
              ),

              SizedBox(height: 15.h),
              // View receipt button
              CustomButton(
                backgroundColor: MyColors.white.withValues(alpha: 0.05),
                text: 'View receipt'.tr,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => PDFViewerScreen(
                            pdfUrl: paymentDoneController.receiptUrl.value,
                          ),
                    ),
                  );
                },
              ),

              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void goToHomeScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Future.delayed(Duration(milliseconds: 60), () {
      Get.offAllNamed(AppRoutes.homescreen);
    });
  }
}
