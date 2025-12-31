import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JoinGameController extends GetxController {
  final TextEditingController teamCodeController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isWaiting = false.obs;

  @override
  void onClose() {
    teamCodeController.dispose();
    super.onClose();
  }

  Future<void> joinGame() async {
    if (teamCodeController.text.trim().isEmpty) {
      CustomSnackbar.showError('Please enter a game code');
      return;
    }

    isLoading.value = true;
    try {
      final response = await GameRepository().joinGameSession(
        sessionCode: teamCodeController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update game session if response contains session data
        if (response.data != null && response.data['session'] != null) {
          final gameController = Get.find<GameController>();
          final session = gameController.gameSession.value;
          if (session != null) {
            // Session is already updated by the API response
            // Fetch session details to get full session info
            if (session.id != null) {
              await gameController.getGameSessionDetails(sessionId: session.id!);
            }
          }
        }
        
        isWaiting.value = true;
        CustomSnackbar.showSuccess('Joined game successfully');

        Future.delayed(const Duration(seconds: 3), () {
          Get.toNamed(AppRoutes.caseVideoScreen);
        });
      }
    } on DioException {
      // Error already shown by interceptor
      isWaiting.value = false;
    } catch (e) {
      CustomSnackbar.showError('Failed to join game: $e');
      isWaiting.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
