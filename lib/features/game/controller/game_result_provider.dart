import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/game_result_model.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/scoreboard_provider.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Controller for managing game result summary screen state
class GameResultController extends GetxController {
  final _repository = GameRepository();

  Rx<GameResultModel?> gameResult = Rx<GameResultModel?>(null);
  var isLoading = false.obs;
  RxMap<String, List<Map<String, dynamic>>> _playersByTeamId =
      <String, List<Map<String, dynamic>>>{}.obs;

  // Get Game Result
  Future<void> getGameResult({
    required String sessionId,
    bool silent = false,
  }) async {
    try {
      // Only show loading and clear result on initial load, not on polling
      if (!silent) {
        isLoading(true);
        gameResult(null);
      }

      final response = await _repository.getGameResult(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempResult = GameResultModel.fromJson(response.data);
        gameResult(tempResult);

        // Fetch scoreboard data to get player information
        _fetchPlayersForTeams(sessionId: sessionId, silent: silent);
      }
    } on DioException {
      // Error already shown by interceptor
      // Only show loading state change on initial load
      if (!silent) {
        isLoading(false);
      }
    } catch (e) {
      if (!silent) {
        CustomSnackbar.showError(
          "${'Something went wrong!!!:'.tr} ${e.toString()}",
        );
      }
    } finally {
      if (!silent) {
        isLoading(false);
      }
    }
  }

  // Fetch players for teams from scoreboard
  Future<void> _fetchPlayersForTeams({
    required String sessionId,
    bool silent = false,
  }) async {
    try {
      final response = await _repository.getScoreboard(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final scoreboardData = response.data;

        if (scoreboardData['teams'] != null) {
          final teams = scoreboardData['teams'] as List<dynamic>;
          final playersMap = <String, List<Map<String, dynamic>>>{};

          for (var team in teams) {
            final teamId = team['teamId'] as String?;
            final teamName = team['teamName'] as String?;
            final players = team['players'] as List<dynamic>? ?? [];

            // Use teamId as key, fallback to teamName
            final key = teamId ?? teamName ?? '';

            if (key.isNotEmpty) {
              playersMap[key] =
                  players.map((player) {
                    return {
                      'name': player['userName'] ?? '',
                      'avatar':
                          '', // Avatar not in API response, will show placeholder
                    };
                  }).toList();
            }
          }

          _playersByTeamId.value = playersMap;
        }
      }
    } catch (e) {
      // Silently handle errors, will use empty players
    }
  }

  // Get winner team name
  String? get winnerTeamName => gameResult.value?.winnerTeamName;

  // Check if team mode (multiple teams)
  bool get isTeamMode {
    final teams = gameResult.value?.teams;
    return teams != null && teams.length > 1;
  }

  // Check if solo mode based on data structure
  bool get isSoloModeFromData {
    final result = gameResult.value;
    if (result == null) return false;

    // Solo mode if: players array exists, OR single team exists
    if (result.players != null && result.players!.isNotEmpty) {
      return true;
    }
    if (result.teams != null && result.teams!.length == 1) {
      return true;
    }
    return false;
  }

  // Helper method for backward compatibility with existing screens
  List<Map<String, dynamic>> get teamResults {
    if (gameResult.value?.teams == null) return [];

    return gameResult.value!.teams!.map((team) {
      // Get players for this team from cached scoreboard data
      final teamId = team.teamId ?? '';
      final teamName = team.teamName ?? '';

      // Try to find players by teamId first, then by teamName
      List<Map<String, dynamic>> players = [];
      if (_playersByTeamId.containsKey(teamId)) {
        players = List<Map<String, dynamic>>.from(
          _playersByTeamId[teamId] ?? [],
        );
      } else if (_playersByTeamId.containsKey(teamName)) {
        players = List<Map<String, dynamic>>.from(
          _playersByTeamId[teamName] ?? [],
        );
      }

      // Fallback: Try to get from scoreboard controller if available
      if (players.isEmpty && Get.isRegistered<ScoreboardController>()) {
        try {
          final scoreboardController = Get.find<ScoreboardController>();
          final scoreboardTeams = scoreboardController.teams;

          for (var scoreboardTeam in scoreboardTeams) {
            final stName = scoreboardTeam['name'] as String?;
            if (stName == teamName || stName == teamId) {
              final teamPlayers =
                  scoreboardTeam['players'] as List<dynamic>? ?? [];
              players =
                  teamPlayers.map((player) {
                    return {
                      'name': player['name'] ?? '',
                      'avatar': player['avatar'] ?? '',
                    };
                  }).toList();
              break;
            }
          }
        } catch (e) {
          // Silently handle errors
        }
      }

      // Final fallback: Get from game session
      if (players.isEmpty && Get.isRegistered<GameController>()) {
        try {
          final gameController = Get.find<GameController>();
          final sessionPlayers = gameController.sessionPlayers;

          // Add all session players as a fallback
          players =
              sessionPlayers.map((player) {
                return {'name': player.userName ?? '', 'avatar': ''};
              }).toList();
        } catch (e) {
          // Silently handle errors
        }
      }

      return {
        'name': teamName,
        'players': players,
        'suspectName': team.suspectChosenName ?? '',
        'suspectImage': '', // Image not in API response
        'isCorrect': false, // Would need to check against correct suspect
        'totalScore': team.totalScore ?? 0,
        'timeTaken': team.timeTaken ?? '',
        'accuracy': team.accuracy ?? 0,
        'hintsUsed': team.hintsUsed ?? 0,
      };
    }).toList();
  }

  // Helper method for solo mode
  // Solo mode can return data in either 'players' array or 'teams' array (with single team)
  Map<String, dynamic>? get soloPlayerResult {
    final result = gameResult.value;
    if (result == null) return null;

    // First check if players array exists and has data
    if (result.players != null && result.players!.isNotEmpty) {
      final player = result.players!.first;
      return {
        'name': player.userName ?? '',
        'suspectName': player.suspectChosenName ?? '',
        'suspectImage': '', // Image not in API response
        'isCorrect': false, // Would need to check against correct suspect
        'totalScore': player.totalScore ?? 0,
        'timeTaken': player.timeTaken ?? '',
        'accuracy': player.accuracy ?? 0,
        'hintsUsed': player.hintsUsed ?? 0,
      };
    }

    // If no players, check if teams array exists with a single team (solo mode)
    if (result.teams != null && result.teams!.isNotEmpty) {
      final team = result.teams!.first;
      return {
        'name': team.leaderName ?? team.teamName ?? '',
        'suspectName': team.suspectChosenName ?? '',
        'suspectImage': '', // Image not in API response
        'isCorrect': false, // Would need to check against correct suspect
        'totalScore': team.totalScore ?? 0,
        'timeTaken': team.timeTaken ?? '',
        'accuracy': team.accuracy ?? 0,
        'hintsUsed': team.hintsUsed ?? 0,
      };
    }

    return null;
  }

  // Get winner team (for backward compatibility)
  String get winnerTeam => winnerTeamName ?? '';
}
