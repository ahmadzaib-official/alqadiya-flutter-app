import 'package:get/get.dart';

/// Controller for managing settings screen state
class SettingsController extends GetxController {
  final userName = 'Fahd Abdoula'.obs;
  final userAge = '32 years old'.obs;
  final userEmail = 'Fadi@gmail.com'.obs;
  final userAvatarUrl = 'https://picsum.photos/200?random=1'.obs;
  final selectedLanguage = 'English'.obs;
  final pointsBalance = 237.obs;

  /// Update user profile
  void updateProfile({
    String? name,
    String? age,
    String? email,
    String? avatarUrl,
  }) {
    if (name != null) userName.value = name;
    if (age != null) userAge.value = age;
    if (email != null) userEmail.value = email;
    if (avatarUrl != null) userAvatarUrl.value = avatarUrl;
  }

  /// Update selected language
  void updateLanguage(String language) {
    if (selectedLanguage.value != language) {
      selectedLanguage.value = language;
    }
  }

  /// Update points balance
  void updatePointsBalance(int points) {
    if (pointsBalance.value != points) {
      pointsBalance.value = points;
    }
  }
}
