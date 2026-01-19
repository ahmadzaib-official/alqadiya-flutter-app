import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthRequiredDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onDismiss;

  const AuthRequiredDialog({
    super.key,
    required this.title,
    required this.message,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: MyColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: MyColors.backgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: MyColors.redButtonColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              title,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 13.sp,
                color: MyColors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            
            // Message
            Text(
              message,
              style: AppTextStyles.smallRegular8().copyWith(
fontSize: 8.sp,
                color: MyColors.white.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            
            // Buttons
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        onDismiss?.call();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: MyColors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: MyColors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: AppTextStyles.bodyTextRegular16().copyWith(
                            fontSize: 8.sp,
                            color: MyColors.white.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  
                  // Sign In Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        // Ensure portrait orientation before navigation
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                        Get.toNamed(AppRoutes.sigin);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: MyColors.redButtonColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'Sign In'.tr,
                          style: AppTextStyles.bodyTextRegular16().copyWith(
                            fontSize: 8.sp,
                            color: MyColors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            
            // Sign Up Link
            GestureDetector(
              onTap: () async {
                Navigator.of(context).pop();
                // Ensure portrait orientation before navigation
                await SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                Get.toNamed(AppRoutes.signUp);
              },
              child: Text(
                'Don\'t have an account? Sign Up'.tr,
                style: AppTextStyles.bodyTextRegular16().copyWith(
                  fontSize: 8.sp,
                  color: MyColors.redButtonColor,
                  // decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show auth dialog
void showAuthRequiredDialog({
  required String title,
  required String message,
  VoidCallback? onDismiss,
}) {
  Get.dialog(
    AuthRequiredDialog(
      title: title,
      message: message,
      onDismiss: onDismiss,
    ),
    barrierDismissible: false,
  );
}
