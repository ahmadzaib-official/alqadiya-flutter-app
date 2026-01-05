import 'dart:async';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/model/game_session_model.dart';
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
        // Ensure GameController is initialized
        GameController gameController;
        if (!Get.isRegistered<GameController>()) {
          gameController = Get.put(GameController(), permanent: true);
        } else {
          gameController = Get.find<GameController>();
        }

        // Extract sessionId from response
        if (response.data != null && 
            response.data['player'] != null && 
            response.data['player']['sessionId'] != null) {
          _sessionId = response.data['player']['sessionId'] as String;
          
          // Update game session if response contains session data
          if (response.data['session'] != null) {
            try {
              // Parse and set the session from response
              final sessionData = response.data['session'];
              final session = GameSessionModel.fromJson(sessionData);
              gameController.gameSession.value = session;
              
              // Fetch full session details to get complete info (players, teams, etc.)
              if (session.id != null) {
                await gameController.getGameSessionDetails(
                  sessionId: session.id!,
                  silent: true, // Silent to avoid showing errors during join flow
                );
              }
            } catch (e) {
              // If parsing fails, try to fetch session details using sessionId
              if (_sessionId != null) {
                await gameController.getGameSessionDetails(
                  sessionId: _sessionId!,
                  silent: true,
                );
              }
            }
          } else if (_sessionId != null) {
            // If session data not in response but we have sessionId, fetch it
            await gameController.getGameSessionDetails(
              sessionId: _sessionId!,
              silent: true,
            );
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
    
    // Ensure GameController is initialized
    GameController gameController;
    if (!Get.isRegistered<GameController>()) {
      gameController = Get.put(GameController(), permanent: true);
    } else {
      gameController = Get.find<GameController>();
    }
    
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
            
            // Update GameController with session data from status response
            try {
              if (response.data['session'] != null) {
                final sessionData = response.data['session'];
                final session = GameSessionModel.fromJson(sessionData);
                gameController.gameSession.value = session;
              } else if (response.data['gameId'] != null) {
                // If session data not available but gameId is, update session with gameId
                final currentSession = gameController.gameSession.value;
                if (currentSession != null && currentSession.id == sessionId) {
                  gameController.gameSession.value = currentSession.copyWith(
                    gameId: response.data['gameId'] as String?,
                  );
                }
              }
            } catch (e) {
              // Silently handle parsing errors, continue with existing session data
            }
            
            if (status == 'in_progress') {
              // Stop polling
              _stopPolling();
              
              // Ensure session data is up to date before navigation
              if (gameController.gameSession.value?.id == null) {
                // Fetch full session details if not already set
                await gameController.getGameSessionDetails(
                  sessionId: sessionId,
                  silent: true,
                );
              }
              
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
