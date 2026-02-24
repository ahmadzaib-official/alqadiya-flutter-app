import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/my_colors.dart';

class ScreenMirrorGuideDialog extends StatelessWidget {
  const ScreenMirrorGuideDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Row(
        children: [
          Icon(Icons.tv, color: MyColors.white, size: 24.sp),
          SizedBox(width: 8.w),
          Text(
            'Mirror to TV'.tr,
            style: TextStyle(
              color: MyColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To see the game on your TV, enable screen mirroring:'.tr,
              style: TextStyle(
                color: MyColors.white.withOpacity(0.9),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 16.h),

            if (Platform.isAndroid) ...[
              _buildStep('1', 'Swipe down from the top of your screen'.tr),
              _buildStep('2', 'Tap "Cast" or "Screen Cast"'.tr),
              _buildStep('3', 'Select your Chromecast device'.tr),
              _buildStep('4', 'The game will appear on your TV!'.tr),
            ] else ...[
              _buildStep('1', 'Swipe down from top-right corner'.tr),
              _buildStep('2', 'Tap "Screen Mirroring"'.tr),
              _buildStep('3', 'Select your Apple TV'.tr),
              _buildStep('4', 'The game will appear on your TV!'.tr),
            ],

            SizedBox(height: 16.h),

            // Tip box
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: MyColors.redButtonColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: MyColors.redButtonColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: MyColors.redButtonColor,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tip: Make sure your phone and TV are on the same WiFi network'
                          .tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: MyColors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Game tip
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: Colors.green.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.people_outline, color: Colors.green, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Perfect for team play! Everyone can see the suspects, evidence, and questions on the big screen.'
                          .tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: MyColors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            backgroundColor: MyColors.redButtonColor,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Got it!'.tr,
            style: TextStyle(
              color: MyColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: MyColors.redButtonColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: MyColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: MyColors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
