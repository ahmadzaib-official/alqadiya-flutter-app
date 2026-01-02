import 'dart:async';
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
  
  Timer? _statusPollingTimer;
  String? _sessionId;

  @override
  void onClose() {
    _stopPolling();
    teamCodeController.dispose();
    super.onClose();
  }

  void _stopPolling() {
    _statusPollingTimer?.cancel();
    _statusPollingTimer = null;
  }

  Future<void> joinGame() async {
    if (teamCodeController.text.trim().isEmpty) {
      CustomSnackbar.showError('Please enter a game code'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final response = await GameRepository().joinGameSession(
        sessionCode: teamCodeController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract sessionId from response
        if (response.data != null && 
            response.data['player'] != null && 
            response.data['player']['sessionId'] != null) {
          _sessionId = response.data['player']['sessionId'] as String;
          
          // Update game session if response contains session data
          if (response.data['session'] != null) {
            final gameController = Get.find<GameController>();
            final session = gameController.gameSession.value;
            if (session != null) {
              // Session is already updated by the API response
              // Fetch session details to get full session info
              if (session.id != null) {
                await gameController.getGameSessionDetails(
                  sessionId: session.id!,
                );
              }
            }
          }

          isWaiting.value = true;
          // CustomSnackbar.showSuccess('Joined game successfully'.tr);

          // Start polling for session status
          if (_sessionId != null) {
            _startStatusPolling(_sessionId!);
          }
        } else {
          // Fallback: if sessionId not found, use old behavior
          isWaiting.value = true;
          // CustomSnackbar.showSuccess('Joined game successfully'.tr);

          Future.delayed(const Duration(seconds: 3), () {
            // Use post frame callback to ensure navigation happens safely
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Get.isRegistered<JoinGameController>()) {
                Get.toNamed(AppRoutes.caseVideoScreen);
              }
            });
          });
        }
      }
    } on DioException {
      // Error already shown by interceptor
      isWaiting.value = false;
      _stopPolling();
    } catch (e) {
      CustomSnackbar.showError('${'Failed to join game:'.tr} $e');
      isWaiting.value = false;
      _stopPolling();
    } finally {
      isLoading.value = false;
    }
  }

  void _startStatusPolling(String sessionId) {
    // Stop any existing polling
    _stopPolling();
    
    // Start polling every 2 seconds
    _statusPollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!Get.isRegistered<JoinGameController>()) {
        timer.cancel();
        return;
      }

      try {
        final response = await GameRepository().getGameSessionStatus(
          sessionId: sessionId,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (response.data != null) {
            final status = response.data['status'] as String?;
            
            if (status == 'in_progress') {
              // Stop polling
              _stopPolling();
              
              // Navigate to video screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Get.isRegistered<JoinGameController>()) {
                  Get.toNamed(AppRoutes.caseVideoScreen);
                }
              });
            }
          }
        }
      } catch (e) {
        // Silently handle errors during polling
        // Don't show error messages for polling failures
        // The polling will continue on next interval
      }
    });
  }
}
