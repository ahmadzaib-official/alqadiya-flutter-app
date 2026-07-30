// language_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/features/change_language/modal/language_modal.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:get/get.dart';

class ChangeLanguageController extends GetxController {
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Defer initialization to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeLanguage();
    });
  }

  void initializeLanguage() {
    languageList.addAll([
      LanguageModel(title: "English", slug: "en", image: MyIcons.ukFlag),
      LanguageModel(title: "عربي", slug: "ar", image: MyIcons.flag),
    ]);

    final lang = Get.find<Preferences>().getString(AppStrings.language);
    String currentLangCode = 'en';

    if (lang != null && lang.isNotEmpty) {
      currentLangCode = lang;
    } else {
      final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
      if (deviceLocale.languageCode == 'ar') {
        currentLangCode = 'ar';
      }
    }

    selectedLanguage.value = languageList.firstWhere(
      (element) => element.slug == currentLangCode,
      orElse: () => languageList.first,
    );
  }

  Future<void> changeLanguage(LanguageModel newLanguage) async {
    selectedLanguage.value = newLanguage;
    await Get.find<Preferences>().setString(
      AppStrings.languageCodeKey,
      jsonEncode(newLanguage.toJson()),
    );
  }
}
