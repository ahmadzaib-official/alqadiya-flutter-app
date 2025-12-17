import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AppTextStyles {
  // Helper method to determine font family based on current locale
  static String _getFontFamily() {
    final currentLocale = Get.locale?.languageCode;
    return currentLocale == 'ar' ? 'Cairo' : 'Cairo';
  }

  // Helper method to get appropriate font for specific cases (like Poppins)
  static String _getSpecificFontFamily({String? defaultFont, String? arabicFont}) {
    final currentLocale = Get.locale?.languageCode;
    return currentLocale == 'ar' 
      ? arabicFont ?? 'Tajawal' 
      : defaultFont ?? 'Inter';
  }

  /// Heading1 - Size 40.5 (scalable)
  static TextStyle heading1() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 39.6.sp,
        fontWeight: FontWeight.bold,
      );

  /// Heading2 - Size 26 (scalable)
  static TextStyle heading2() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 27.sp,// change size
        fontWeight: FontWeight.w600,
      );
static TextStyle heading3() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 26.5.sp,
        fontWeight: FontWeight.w600,
      );
 
static TextStyle heading4() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      );
 

  /// Body Text - Size 16 (scalable)
  static TextStyle bodyTextRegular16() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle bodyTextMedium16() => GoogleFonts.getFont(
        _getSpecificFontFamily(defaultFont: 'Inter'),
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle bodyTextMedium16bold() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
      );
  static TextStyle bodyTextMedium16boldmax() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
      );

  static TextStyle bodyTextPoppinsRegular16() => GoogleFonts.getFont(
        _getSpecificFontFamily(defaultFont: 'Poppins'),
        fontSize: 16.5.sp,
        fontWeight: FontWeight.w400,
      );

  /// Labels - Size 14 (scalable)
  static TextStyle labelBold14() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      );

  static TextStyle labelRegular14() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle labelMedium14() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  /// Captions - Size 10 (scalable)
  static TextStyle captionRegular10() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );
  static TextStyle captionRegular10medium() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle smallRegular8() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle captionSemiBold10() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
      );

  /// Title - Size 18 (scalable)
  static TextStyle titleDMSansMedium18() => GoogleFonts.getFont(
        _getSpecificFontFamily(defaultFont: 'DM Sans'),
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle titleInterMedium18() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
      );

  /// Captions - Size 12 (scalable)
  static TextStyle captionRegular12() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle captionRegularmedium12() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  static TextStyle captionSemiBold12() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle captionBold10() => GoogleFonts.getFont(
        _getFontFamily(),
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
      );
}