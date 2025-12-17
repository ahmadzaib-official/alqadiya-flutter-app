import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/lang/app_ar.dart';
import 'package:alqadiya_game/core/lang/app_en.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  static const fallbackLocale = Locale('en', 'US');

  static final langs = ['en', 'ar'];
  static final locales = [const Locale('en', 'US'), const Locale('ar', 'SA')];

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_SA': lnAr};

  Future<void> changeLocale(String langCode) async {
    final locale = _getLocaleFromLanguage(langCode);
    await Get.find<Preferences>().setString(AppStrings.language, langCode);
    Get.updateLocale(locale);
  }

  Locale _getLocaleFromLanguage(String langCode) {
    for (int i = 0; i < langs.length; i++) {
      if (langCode == langs[i]) return locales[i];
    }
    return Get.locale ?? fallbackLocale;
  }

  static Future<Locale> getCurrentLocale() async {
    final lang = Get.find<Preferences>().getString(AppStrings.language);
    if (lang == null || lang.isEmpty) return fallbackLocale;
    return LocalizationService()._getLocaleFromLanguage(lang);
  }
}
