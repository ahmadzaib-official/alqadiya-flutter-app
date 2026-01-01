import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/game/model/game_model.dart';
import 'package:alqadiya_game/features/game/model/game_session_model.dart';
import 'package:alqadiya_game/features/casestore/model/member_model.dart';
import 'package:alqadiya_game/features/game/model/team_model.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  RxList<GameModel> gamesList = <GameModel>[].obs;
  Rx<GameModel> gameDetail = Rx<GameModel>(GameModel());
  Rx<GameSessionModel?> gameSession = Rx<GameSessionModel?>(null);
  RxList<MemberModel> sessionPlayers = <MemberModel>[].obs;
  RxList<TeamModel> teams = <TeamModel>[].obs;

  var isLoading = false.obs;
  var isMoreLoading = false.obs; // For load more indicator

  // Pagination variables
  int currentPage = 1;
  int limit = 10;
  var hasMore = true.obs;

  // Filter state
  final selectedDifficulty = ''.obs;
  final minPoints = 0.0.obs;
  final maxPoints = 100.0.obs;

  // Category state
  final selectedCategory = 'Recent Cases'.obs;

  void setCategory(String category) {
    selectedCategory.value = category;
    getGamesList();
  }

  // Available difficulties
  final difficulties = ['Difficult', 'Intermediate', 'Beginner'];

  void setDifficulty(String difficulty) {
    selectedDifficulty.value = difficulty;
  }

  void setPointsRange(double min, double max) {
    minPoints.value = min;
    maxPoints.value = max;
  }

  void resetFilters() {
    selectedDifficulty.value = '';
    minPoints.value = 0.0;
    maxPoints.value = 100.0;
  }

  void applyFilters() {
    getGamesList();
  }

  @override
  void onInit() {
    getGamesList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // getGamesList API
  Future<void> getGamesList({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        if (isMoreLoading.value || !hasMore.value) return;
        isMoreLoading(true);
      } else {
        isLoading(true);
        currentPage = 1;
        hasMore(true);
      }

      Map<String, dynamic> body = {"page": currentPage, "limit": limit};

      if (selectedCategory.value == 'Recent Cases') {
        body['filter'] = 'recentGames';
      } else if (selectedCategory.value == 'My Games') {
        body['filter'] = 'myGames';
      }

      if (selectedDifficulty.value.isNotEmpty) {
        body["difficulty"] = "[${selectedDifficulty.value.toLowerCase()}]";
      }

      if (minPoints.value > 0 || maxPoints.value < 100) {
        body["minPoints"] = minPoints.value.toInt();
        body["maxPoints"] = maxPoints.value.toInt();
      }

      final response = await GameRepository().getGamesList(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data['data'] ?? [];
        final tempGames = list.map((e) => GameModel.fromJson(e)).toList();

        if (isLoadMore) {
          gamesList.addAll(tempGames);
        } else {
          gamesList.assignAll(tempGames);
        }

        if (tempGames.length < limit) {
          hasMore(false);
        } else {
          currentPage++;
          hasMore(true);
        }
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      if (isLoadMore) {
        isMoreLoading(false);
      } else {
        isLoading(false);
      }
    }
  }

  // getGameDetail API
  Future<void> getGameDetail({required String gameId}) async {
    try {
      gameDetail(null);
      isLoading(true);

      final response = await GameRepository().getGameDetail(gameId: gameId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempGameDetail = GameModel.fromJson(response.data);
        gameDetail(tempGameDetail);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // purchase game API
  Future<bool> purchaseGame({required String gameId}) async {
    try {
      isLoading(true);

      final response = await GameRepository().purchaseGame(gameId: gameId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempGameDetail = GameModel.fromJson(response.data);
        gameDetail(tempGameDetail);
        return true;
      }
      return false;
    } on DioException {
      return false;
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
      return false;
    } finally {
      isLoading(false);
    }
  }

  // Create Game Session API
  Future<void> createGameSession({required String gameId}) async {
    try {
      isLoading(true);
      final response = await GameRepository().createGameSession(gameId: gameId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final session = GameSessionModel.fromJson(response.data);
        gameSession(session);
        // Use post frame callback to ensure navigation happens safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<GameController>()) {
            Get.toNamed(
              AppRoutes.startGameScreen,
              arguments: {'sessionCode': session.sessionCode},
            );
          }
        });
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Update Game Session Mode
  Future<void> updateSessionMode({required String mode}) async {
    final sessionId = gameSession.value?.id;
    if (sessionId == null) return;

    try {
      isLoading(true);
      final response = await GameRepository().updateGameSessionMode(
        sessionId: sessionId,
        mode: mode,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        gameSession.value = gameSession.value?.copyWith(mode: mode);

        // Use post frame callback to ensure navigation happens safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<GameController>()) {
            if (mode == 'solo') {
              Get.toNamed(AppRoutes.caseVideoScreen);
            } else if (mode == 'team') {
              Get.toNamed(AppRoutes.createTeamScreen);
            }
          }
        });
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Create Teams
  Future<void> createTeams({
    required String firstTeamName,
    required String secondTeamName,
  }) async {
    final sessionId = gameSession.value?.id;
    if (sessionId == null) return;

    try {
      isLoading(true);

      final List<Map<String, dynamic>> teams = [
        {"teamName": firstTeamName, "teamNumber": 1},
        {"teamName": secondTeamName, "teamNumber": 2},
      ];

      final response = await GameRepository().createTeams(
        sessionId: sessionId,
        teams: teams,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data;
        this.teams.assignAll(list.map((e) => TeamModel.fromJson(e)).toList());
        CustomSnackbar.showSuccess('Teams created successfully'.tr);
        await Future.delayed(const Duration(milliseconds: 500));
        // Use post frame callback to ensure navigation happens safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<GameController>()) {
            Get.toNamed(AppRoutes.playerSelectionScreen);
          }
        });
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Get Session Players
  Future<void> getSessionPlayers({bool silent = false}) async {
    final sessionId = gameSession.value?.id;
    if (sessionId == null) return;

    try {
      if (!silent) {
        isLoading(true);
      }
      final response = await GameRepository().getSessionPlayers(
        sessionId: sessionId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data;
        // Update session players directly - this will trigger the ever() listener
        // in PlayerSelectionController to sync the players automatically
        final newPlayers = list.map((e) => MemberModel.fromJson(e)).toList();
        sessionPlayers.assignAll(newPlayers);
        // Force refresh to ensure listeners are triggered
        sessionPlayers.refresh();
      }
    } on DioException {
      // Error already shown by interceptor (unless silent)
    } catch (e) {
      if (!silent) {
        final errorMessage = e.toString().toLowerCase();
        if (!errorMessage.contains('setstate') && !errorMessage.contains('markaas')) {
          CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
        }
      }
    } finally {
      if (!silent) {
        isLoading(false);
      }
    }
  }

  // Assign Members
  Future<void> assignMembers({
    required List<Map<String, dynamic>> assignments,
  }) async {
    final sessionId = gameSession.value?.id;
    if (sessionId == null) return;

    try {
      isLoading(true);
      final response = await GameRepository().assignMembers(
        sessionId: sessionId,
        assignments: assignments,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success message first
        CustomSnackbar.showSuccess('Members assigned successfully'.tr);
        
        // Refresh session details to get updated team assignments (silently, without showing errors)
        await getGameSessionDetails(sessionId: sessionId, silent: true);

        await Future.delayed(const Duration(milliseconds: 500));

        final firstTeamId = teams.isNotEmpty ? teams.first.id : null;
        final firstTeamName = teams.isNotEmpty ? teams.first.teamName : null;
        if (firstTeamId != null) {
          // Use post frame callback to ensure navigation happens safely
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.isRegistered<GameController>()) {
              Get.toNamed(
                AppRoutes.chooseTeamLeaderScreen,
                arguments: {'teamId': firstTeamId, 'teamName': firstTeamName},
              );
            }
          });
        }
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      // Only show error if it's not a setState related error
      final errorMessage = e.toString().toLowerCase();
      if (!errorMessage.contains('setstate') && !errorMessage.contains('markaas')) {
        CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
      }
    } finally {
      isLoading(false);
    }
  }

  // Assign Team Leader
  Future<void> assignTeamLeader({
    required String teamId,
    required String userId,
  }) async {
    try {
      isLoading(true);
      final response = await GameRepository().assignTeamLeader(
        teamId: teamId,
        userId: userId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackbar.showSuccess('Team leader assigned successfully'.tr);
        await Future.delayed(const Duration(milliseconds: 500));
        // Use post frame callback to ensure navigation happens safely
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<GameController>()) {
            Get.toNamed(AppRoutes.caseVideoScreen);
          }
        });
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Get Game Session Details
  Future<void> getGameSessionDetails({required String sessionId, bool silent = false}) async {
    try {
      if (!silent) {
        isLoading(true);
      }
      final response = await GameRepository().getGameSessionDetails(
        sessionId: sessionId,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Response contains session, players, and teams
        // Use post frame callback to safely update state
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<GameController>()) {
            try {
              if (response.data['session'] != null) {
                final session = GameSessionModel.fromJson(response.data['session']);
                gameSession(session);
              }
              if (response.data['players'] != null) {
                final List<dynamic> playersList = response.data['players'];
                sessionPlayers.assignAll(
                  playersList.map((e) => MemberModel.fromJson(e)).toList(),
                );
              }
              if (response.data['teams'] != null) {
                final List<dynamic> teamsList = response.data['teams'];
                teams.assignAll(teamsList.map((e) => TeamModel.fromJson(e)).toList());
              }
            } catch (e) {
              // Silently handle setState errors during updates
              // Don't show snackbar for setState related errors
            }
          }
        });
      }
    } on DioException {
      // Error already shown by interceptor (unless silent mode)
      if (!silent) {
        // Error already shown by interceptor
      }
    } catch (e) {
      // Only show error if not in silent mode and not a setState error
      if (!silent) {
        final errorMessage = e.toString().toLowerCase();
        if (!errorMessage.contains('setstate') && !errorMessage.contains('markaas')) {
          CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
        }
      }
    } finally {
      if (!silent) {
        isLoading(false);
      }
    }
  }

  // Join Game Session
  Future<bool> joinGameSession({required String sessionCode}) async {
    try {
      isLoading(true);
      final response = await GameRepository().joinGameSession(
        sessionCode: sessionCode,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Response should contain session info
        if (response.data != null) {
          return true;
        }
        return false;
      }
      return false;
    } on DioException {
      // Error already shown by interceptor
      return false;
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
