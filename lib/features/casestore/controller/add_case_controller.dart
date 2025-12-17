import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/model/game_model.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/services/local_auth_service.dart';

class AddCaseController extends GetxController {
  late LocalAuthService _localAuthService;

  // Observable states
  final RxBool isAuthenticating = false.obs;
  final RxBool isSuccessful = false.obs;
  final Rx<GameModel?> game = Rx<GameModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _localAuthService = LocalAuthService();
    if (Get.arguments != null && Get.arguments['game'] != null) {
      final arg = Get.arguments['game'];
      if (arg is Rx) {
        game.value = arg.value;
      } else {
        game.value = arg as GameModel?;
      }
    }
  }

  /// Handle add case with biometric authentication
  Future<void> handleAddCaseWithAuth({required String gameId}) async {
    if (isAuthenticating.value) return;

    isAuthenticating.value = true;

    try {
      final isAuthenticated = await _localAuthService.authenticate(
        reason: 'Authenticate to add this case'.tr,
        useErrorDialogs: true,
      );

      if (isAuthenticated) {
        // Simulate case addition (replace with actual API call if needed)
        final gameController = Get.find<GameController>();
        await gameController.purchaseGame(gameId: gameId).then((value) {
          if (value) {
            isSuccessful.value = true;
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Authentication Failed'.tr,
        'Failed to authenticate. Please try again.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isAuthenticating.value = false;
    }
  }

  /// Reset success state and return to initial state
  void resetSuccessState() {
    isSuccessful.value = false;
  }

  /// Enter game after successful case addition
  void enterGame() {
    resetSuccessState();
    // Add navigation logic here if needed
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
