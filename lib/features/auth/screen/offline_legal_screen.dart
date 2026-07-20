import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';

class OfflineLegalScreen extends StatelessWidget {
  const OfflineLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final String type = arguments?['type'] ?? 'privacy';

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => Get.back(),
        ),
        title: Text(
          type == 'privacy' ? 'Privacy Policy'.tr : 'Terms of Service'.tr,
          style: AppTextStyles.heading3().copyWith(
            color: Colors.white,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: MyColors.redButtonColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  // ignore: deprecated_member_use
                  color: MyColors.redButtonColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: MyColors.redButtonColor,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'This is a simplified version. For the complete document, please visit our website or try again when you have internet connection.'
                          .tr,
                      style: AppTextStyles.captionRegular12().copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            if (type == 'privacy') ..._buildPrivacyContent(),
            if (type == 'terms') ..._buildTermsContent(),

            SizedBox(height: 24.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Try to open webview again
                      Get.back();
                      Get.toNamed('/auth/privacy-terms');
                    },
                    icon: Icon(Icons.refresh, size: 18.sp),
                    label: Text('Try Again'.tr),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.redButtonColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.arrow_back, size: 18.sp),
                    label: Text('Go Back'.tr),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      // ignore: deprecated_member_use
                      side: BorderSide(color: Colors.white.withOpacity(0.3)),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrivacyContent() {
    return [
      Text(
        'Privacy Policy Summary'.tr,
        style: AppTextStyles.heading2().copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
      SizedBox(height: 16.h),

      _buildSection(
        'Information We Collect'.tr,
        'We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support.'
            .tr,
      ),

      _buildSection(
        'How We Use Your Information'.tr,
        'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.'
            .tr,
      ),

      _buildSection(
        'Information Sharing'.tr,
        'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy.'
            .tr,
      ),

      _buildSection(
        'Data Security'.tr,
        'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.'
            .tr,
      ),

      _buildSection(
        'Contact Us'.tr,
        'If you have any questions about this Privacy Policy, please contact us through our support channels.'
            .tr,
      ),
    ];
  }

  List<Widget> _buildTermsContent() {
    return [
      Text(
        'Terms of Service Summary'.tr,
        style: AppTextStyles.heading2().copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
      SizedBox(height: 16.h),

      _buildSection(
        'Acceptance of Terms'.tr,
        'By using our service, you agree to be bound by these Terms of Service and all applicable laws and regulations.'
            .tr,
      ),

      _buildSection(
        'User Accounts'.tr,
        'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.'
            .tr,
      ),

      _buildSection(
        'Prohibited Uses'.tr,
        'You may not use our service for any unlawful purpose or to solicit others to perform unlawful acts.'
            .tr,
      ),

      _buildSection(
        'Service Availability'.tr,
        'We strive to keep our service available at all times, but we do not guarantee uninterrupted access.'
            .tr,
      ),

      _buildSection(
        'Limitation of Liability'.tr,
        'Our liability to you for any damages arising from your use of the service is limited to the amount you paid us in the past 12 months.'
            .tr,
      ),
    ];
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3().copyWith(
            color: MyColors.redButtonColor,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          content,
          style: AppTextStyles.bodyTextRegular16().copyWith(
            // ignore: deprecated_member_use
            color: Colors.white.withOpacity(0.8),
            fontSize: 14.sp,
            height: 1.5,
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
