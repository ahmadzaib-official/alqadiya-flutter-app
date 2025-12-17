// language_controller.dart
import 'dart:convert';
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
    initializeLanguage();
    super.onInit();
  }

  void initializeLanguage() {
    languageList.addAll([
      LanguageModel(title: "English", slug: "en", image: MyIcons.ukFlag),
      LanguageModel(title: "عربي", slug: "ar", image: MyIcons.flag),
    ]);

    final storedLang = Get.find<Preferences>().getString(
      AppStrings.languageCodeKey,
    );
    if (storedLang != null && storedLang.isNotEmpty) {
      try {
        final json = jsonDecode(storedLang);
        final pref = LanguageModel.fromJson(json);
        selectedLanguage.value = languageList.firstWhere(
          (element) => element.slug == pref.slug,
          orElse: () => languageList.first,
        );
      } catch (e) {
        DebugPoint.log("Error parsing stored language: $e");
        selectedLanguage.value = languageList.first;
      }
    } else {
      selectedLanguage.value = languageList.first;
    }
  }

  Future<void> changeLanguage(LanguageModel newLanguage) async {
    selectedLanguage.value = newLanguage;
    await Get.find<Preferences>().setString(
      AppStrings.languageCodeKey,
      jsonEncode(newLanguage.toJson()),
    );
  }
}
