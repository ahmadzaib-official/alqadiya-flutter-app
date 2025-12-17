import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/features/auth/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  Future<void> getUserData() async {
    try {
      final prefs = Get.find<Preferences>();
      final isGuest = prefs.getBool(AppStrings.isGuest) ?? false;

      if (isGuest) {
        isLoading(false);
        return;
      }
      isLoading(true);
      final response = await ApiFetch().getUserData();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = UserModel.fromJson(response.data);
        user.value = userData;
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("Failed to load user data: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}
