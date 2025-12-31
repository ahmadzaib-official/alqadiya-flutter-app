import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/services/localization_services.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/widgets/language_selection_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LanguageSelectionButton extends StatelessWidget {
  const LanguageSelectionButton({
    super.key,
    this.color,
    this.height,
    this.width,
    this.margin,
    this.textFontSize,
    this.onTap,
    this.isShadow = true,
  });
  final Color? color;
  final double? height;
  final double? width;
  final double? textFontSize;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isShadow;

  String _getCurrentLanguageName() {
    try {
      final lang = Get.find<Preferences>().getString(AppStrings.language);
      if (lang == 'ar') {
        return 'عربي';
      }
      return 'English';
    } catch (e) {
      return Get.locale?.languageCode == 'ar' ? 'عربي' : 'English';
    }
  }

  String _getCurrentLanguageFlag() {
    try {
      final lang = Get.find<Preferences>().getString(AppStrings.language);
      if (lang == 'ar') {
        return MyIcons.flag;
      }
      return MyIcons.ukFlag;
    } catch (e) {
      return Get.locale?.languageCode == 'ar' ? MyIcons.flag : MyIcons.ukFlag;
    }
  }

  void _handleLanguageSelection() {
    if (onTap != null) {
      onTap!();
      return;
    }

    final currentLang = Get.find<Preferences>().getString(AppStrings.language) ?? 'en';
    final currentLanguageName = currentLang == 'ar' ? 'Arabic' : 'English';

    LanguageSelectionBottomSheet.show(
      currentLanguage: currentLanguageName,
      onEnglishSelected: () async {
        Get.back();
        await LocalizationService().changeLocale('en');
      },
      onArabicSelected: () async {
        Get.back();
        await LocalizationService().changeLocale('ar');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleLanguageSelection,
      child: Container(
        height: height ?? 50.h,
        width: width ?? 80.w,
        margin: margin ?? null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.sp),
          color: color ?? Colors.transparent,
          boxShadow:
              isShadow
                  ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      spreadRadius: 0,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ]
                  : null,
        ),
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getCurrentLanguageName(),
              style: AppTextStyles.captionRegular12().copyWith(
                fontSize: textFontSize ?? 12.sp,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset(_getCurrentLanguageFlag(), height: 20.h),
          ],
        ),
      ),
    );
  }
}
