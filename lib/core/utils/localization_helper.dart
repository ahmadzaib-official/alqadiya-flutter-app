import 'package:get/get.dart';

extension LocalizedStringFallback on String? {
  /// Returns the localized string based on the current locale.
  /// If the current locale is 'ar', it prioritizes the Arabic string.
  /// Otherwise, it prioritizes the English string.
  /// If the preferred string is null or empty, it falls back to the other one.
  static String getLocalizedValue(String? enString, String? arString) {
    final isAr = Get.locale?.languageCode == 'ar';
    
    if (isAr) {
      if (arString != null && arString.trim().isNotEmpty) return arString;
      if (enString != null && enString.trim().isNotEmpty) return enString;
    } else {
      if (enString != null && enString.trim().isNotEmpty) return enString;
      if (arString != null && arString.trim().isNotEmpty) return arString;
    }
    
    return '';
  }
}
