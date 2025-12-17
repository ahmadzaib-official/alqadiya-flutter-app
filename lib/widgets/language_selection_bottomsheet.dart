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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .35,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingOnly,
      ).copyWith(
        bottom: AppConstants.paddingOnly,
        top: AppConstants.paddingOnly + 5,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              // Spacing.y(3),
              Text(
                "Select Language",
                style: AppTextStyles.labelBold14().copyWith(fontSize: 28.sp),
              ),
              AppSizedBoxes.smallSizedBox,
              Text(
                "Please choose your preferred language",
                style: AppTextStyles.captionSemiBold12().copyWith(
                  color: MyColors.white.withValues(alpha: 0.5),
                ),
              ),
              // Spacing.y(4),
              SizedBox(height: 8.h),

              // English Option
              _buildLanguageOption(
                title: "English",
                flagEmoji: "🇬🇧",
                isSelected: currentLanguage == "English",
                onTap: onEnglishSelected,
              ),

              // Spacing.y(2),
              SizedBox(height: 8.h),

              // Arabic Option
              _buildLanguageOption(
                title: "العربية",
                flagEmoji: "🇰🇼",
                isSelected: currentLanguage == "Arabic",
                onTap: onArabicSelected,
              ),
            ],
          ),
          // const DragHandle(),
        ],
      ),
    );
  }

  Widget _buildLanguageOption({
    required String title,
    required String flagEmoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? MyColors.redButtonColor : MyColors.white,
            width: 1.2.w,
          ),
          color:
              isSelected
                  ? MyColors.redButtonColor.withValues(alpha: 0.1)
                  : Colors.white,
        ),
        child: Row(
          children: [
            Text(flagEmoji, style: TextStyle(fontSize: 22.sp)),
            // Spacing.x(2),
            SizedBox(width: 8.w),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.captionSemiBold12().copyWith(
                  color: MyColors.white,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: MyColors.redButtonColor,
                size: 22.sp,
              ),
          ],
        ),
      ),
    );
  }
}
