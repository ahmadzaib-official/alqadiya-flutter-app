import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:get/get.dart' hide Response;

/// Support contact model
class SupportContact {
  final String id;
  final String contactType;
  final String contactValue;
  final String labelEn;
  final String labelAr;
  final bool isActive;

  SupportContact({
    required this.id,
    required this.contactType,
    required this.contactValue,
    required this.labelEn,
    required this.labelAr,
    required this.isActive,
  });

  factory SupportContact.fromJson(Map<String, dynamic> json) {
    return SupportContact(
      id: json['id'] ?? '',
      contactType: json['contactType'] ?? '',
      contactValue: json['contactValue'] ?? '',
      labelEn: json['labelEn'] ?? '',
      labelAr: json['labelAr'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}

/// Controller for managing settings screen state
class SettingsController extends GetxController {
  final userName = 'Fahd Abdoula'.obs;
  final userAge = '32 years old'.obs;
  final userEmail = 'Fadi@gmail.com'.obs;
  final userAvatarUrl = 'https://picsum.photos/200?random=1'.obs;
  final selectedLanguage = 'English'.obs;
  final pointsBalance = 237.obs;

  // Support contacts
  final supportContacts = <SupportContact>[].obs;
  final isLoadingSupportContacts = false.obs;

  static final DioHelper _dioHelper = DioHelper();

  @override
  void onInit() {
    super.onInit();
    fetchSupportContacts();
  }

  /// Fetch support contacts from API
  Future<void> fetchSupportContacts() async {
    try {
      isLoadingSupportContacts.value = true;
      final response = await _dioHelper.get(
        url: ServerConfig.supportContacts,
        isAuthRequired: true,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data;
        supportContacts.value = data
            .map((json) => SupportContact.fromJson(json))
            .where((contact) => contact.isActive)
            .toList();
      }
    } catch (e) {
      print('Error fetching support contacts: $e');
    } finally {
      isLoadingSupportContacts.value = false;
    }
  }

  /// Get WhatsApp contact (first active one)
  SupportContact? get whatsappContact {
    try {
      return supportContacts.firstWhere(
        (contact) => contact.contactType.toLowerCase() == 'whatsapp',
      );
    } catch (e) {
      return null;
    }
  }

  /// Get Direct Call contact
  SupportContact? get directCallContact {
    try {
      return supportContacts.firstWhere(
        (contact) => contact.contactType.toLowerCase() == 'direct_call',
      );
    } catch (e) {
      return null;
    }
  }

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
