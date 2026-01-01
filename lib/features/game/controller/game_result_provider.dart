import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/game_result_model.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Controller for managing game result summary screen state
class GameResultController extends GetxController {
  final _repository = GameRepository();

  Rx<GameResultModel?> gameResult = Rx<GameResultModel?>(null);
  var isLoading = false.obs;

  // Get Game Result
  Future<void> getGameResult({required String sessionId}) async {
    try {
      isLoading(true);
      gameResult(null);

      final response = await _repository.getGameResult(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempResult = GameResultModel.fromJson(response.data);
        gameResult(tempResult);
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

  // Get winner team name
  String? get winnerTeamName => gameResult.value?.winnerTeamName;

  // Check if team mode
  bool get isTeamMode =>
      gameResult.value?.teams != null && gameResult.value!.teams!.isNotEmpty;

  // Helper method for backward compatibility with existing screens
  List<Map<String, dynamic>> get teamResults {
    if (gameResult.value?.teams == null) return [];
    return gameResult.value!.teams!.map((team) {
      return {
        'name': team.teamName ?? '',
        'players':
            [], // Players not in team result, would need separate API call
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
  Map<String, dynamic>? get soloPlayerResult {
    if (gameResult.value?.players == null ||
        gameResult.value!.players!.isEmpty) {
      return null;
    }
    final player = gameResult.value!.players!.first;
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

  // Get winner team (for backward compatibility)
  String get winnerTeam => winnerTeamName ?? '';
}
