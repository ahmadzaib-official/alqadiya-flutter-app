import 'package:alqadiya_game/core/constants/app_constants.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LanguageSelectionBottomSheet extends StatelessWidget {
  final String currentLanguage;
  final VoidCallback onEnglishSelected;
  final VoidCallback onArabicSelected;

  const LanguageSelectionBottomSheet({
    super.key,
    required this.currentLanguage,
    required this.onEnglishSelected,
    required this.onArabicSelected,
  });

  static void show({
    required String currentLanguage,
    required VoidCallback onEnglishSelected,
    required VoidCallback onArabicSelected,
  }) {
    Get.bottomSheet(
      LanguageSelectionBottomSheet(
        currentLanguage: currentLanguage,
        onEnglishSelected: onEnglishSelected,
        onArabicSelected: onArabicSelected,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenHeight = Get.height;
    
    // Calculate responsive height based on orientation
    final height = isLandscape 
        ? screenHeight * 0.5  // Taller in landscape
        : screenHeight * 0.35; // Original height in portrait
    
    return Container(
      height: height,
      constraints: BoxConstraints(
        maxHeight: isLandscape ? screenHeight * 0.7 : screenHeight * 0.5,
        minHeight: 200.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingOnly,
      ).copyWith(
        bottom: AppConstants.paddingOnly,
        top: AppConstants.paddingOnly + 5,
      ),
      decoration: BoxDecoration(
        color: MyColors.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(
          color: MyColors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(
                color: MyColors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Text(
            'Select Language'.tr,
            style: AppTextStyles.labelBold14().copyWith(
              fontSize: isLandscape ? 20.sp : 28.sp,
              color: MyColors.white,
            ),
          ),
          AppSizedBoxes.smallSizedBox,
          Text(
            'Please choose your preferred language'.tr,
            style: AppTextStyles.captionSemiBold12().copyWith(
              color: MyColors.white.withValues(alpha: 0.7),
              fontSize: isLandscape ? 10.sp : 12.sp,
            ),
          ),
          SizedBox(height: 16.h),

          // Language Options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // English Option
                  _buildLanguageOption(
                    context: context,
                    title: "English".tr,
                    flagEmoji: "🇬🇧",
                    isSelected: currentLanguage == "English",
                    onTap: onEnglishSelected,
                  ),

                  SizedBox(height: 12.h),

                  // Arabic Option
                  _buildLanguageOption(
                    context: context,
                    title: "Arabic".tr,
                    flagEmoji: "🇰🇼",
                    isSelected: currentLanguage == "Arabic",
                    onTap: onArabicSelected,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String flagEmoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isLandscape ? 10.h : 12.h,
          horizontal: 14.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected 
                ? MyColors.redButtonColor 
                : MyColors.white.withValues(alpha: 0.2),
            width: 1.2.w,
          ),
          color: isSelected
              ? MyColors.redButtonColor.withValues(alpha: 0.2)
              : MyColors.black.withValues(alpha: 0.2),
        ),
        child: Row(
          children: [
            Text(
              flagEmoji,
              style: TextStyle(fontSize: isLandscape ? 18.sp : 22.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.captionSemiBold12().copyWith(
                  color: MyColors.white,
                  fontSize: isLandscape ? 11.sp : 12.sp,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: MyColors.redButtonColor,
                size: isLandscape ? 20.sp : 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
