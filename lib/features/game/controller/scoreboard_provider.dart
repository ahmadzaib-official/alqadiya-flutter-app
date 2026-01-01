import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/scoreboard_model.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Controller for managing scoreboard screen state
class ScoreboardController extends GetxController {
  final _repository = GameRepository();

  Rx<ScoreboardModel?> scoreboard = Rx<ScoreboardModel?>(null);
  var isLoading = false.obs;

  // Get Scoreboard
  Future<void> getScoreboard({required String sessionId}) async {
    try {
      isLoading(true);
      scoreboard(null);

      final response = await _repository.getScoreboard(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempScoreboard = ScoreboardModel.fromJson(response.data);
        scoreboard(tempScoreboard);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError(
        "${'Something went wrong!!!:'.tr} ${e.toString()}",
      );
    } finally {
      isLoading(false);
    }
  }

  // Refresh scoreboard (for polling)
  Future<void> refreshScoreboard({required String sessionId}) async {
    try {
      final response = await _repository.getScoreboard(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempScoreboard = ScoreboardModel.fromJson(response.data);
        scoreboard(tempScoreboard);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      // Silent fail for polling
    }
  }

  // Check if team mode
  bool get isTeamMode =>
      scoreboard.value?.teams != null && scoreboard.value!.teams!.isNotEmpty;

  // Helper method for backward compatibility with existing screens
  List<Map<String, dynamic>> get teams {
    if (scoreboard.value?.teams == null) return [];
    return scoreboard.value!.teams!.map((team) {
      return {
        'name': team.teamName ?? '',
        'score': team.teamScore ?? 0,
        'players':
            (team.players ?? []).map((player) {
              return {
                'name': player.userName ?? '',
                'avatar': '', // Avatar not in API response
              };
            }).toList(),
        'progressStart': 24, // Default values for progress
        'progressEnd': (team.teamScore ?? 0),
      };
    }).toList();
  }

  // Helper method for solo mode
  Map<String, dynamic>? get soloPlayer {
    if (scoreboard.value?.players == null ||
        scoreboard.value!.players!.isEmpty) {
      return null;
    }
    final player = scoreboard.value!.players!.first;
    return {
      'name': player.userName ?? '',
      'score': player.individualScore ?? 0,
      'avatar': '', // Avatar not in API response
      'progressStart': 24, // Default values for progress
      'progressEnd': (player.individualScore ?? 0),
    };
  }
}
