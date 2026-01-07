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
        print('DEBUG: API Response: ${response.data}');
        final tempScoreboard = ScoreboardModel.fromJson(response.data);
        print(
          'DEBUG: Parsed scoreboard - sessionMode: ${tempScoreboard.sessionMode}',
        );
        print(
          'DEBUG: Parsed scoreboard - teams count: ${tempScoreboard.teams.length}',
        );
        print(
          'DEBUG: Parsed scoreboard - root players count: ${tempScoreboard.players?.length ?? 0}',
        );
        if (tempScoreboard.teams.isNotEmpty) {
          print(
            'DEBUG: First team players count: ${tempScoreboard.teams.first.players.length}',
          );
        }
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
  bool get isTeamMode {
    final sessionMode = scoreboard.value?.sessionMode;
    print('DEBUG: sessionMode from API = $sessionMode');
    final result = sessionMode == 'team';
    print('DEBUG: isTeamMode result = $result');
    return result;
  }

  // Get remaining time
  String get remainingTime => scoreboard.value?.remainingTime ?? '00:00:00';

  // Get case name
  String get caseName => scoreboard.value?.caseName ?? '';

  // Get current question info
  String get currentQuestionText {
    final question = scoreboard.value?.currentQuestion;
    if (question == null) return '';

    // Use English question for now, can be localized later
    return question.questionEn ?? '';
  }

  int get currentQuestionNumber =>
      scoreboard.value?.currentQuestion?.questionNumber ?? 1;
  int get totalQuestions => scoreboard.value?.totalQuestions ?? 0;

  // Get teams for team mode - using scoreboard model data directly
  List<Team> get teams => scoreboard.value?.teams ?? [];

  // Get solo player for solo mode - using scoreboard model data directly
  Player? get soloPlayer {
    print('DEBUG: Getting solo player...');
    print('DEBUG: isTeamMode = $isTeamMode');
    print('DEBUG: teams.length = ${teams.length}');

    if (isTeamMode) {
      print('DEBUG: Returning null because isTeamMode is true');
      return null;
    }

    // In solo mode, first check if we have players at the root level (new API structure)
    final rootPlayers = scoreboard.value?.players;
    if (rootPlayers != null && rootPlayers.isNotEmpty) {
      final player = rootPlayers.first;
      print('DEBUG: Found solo player in root players: ${player.userName}');
      return player;
    }

    // Fallback: try to get player from teams array (old structure)
    if (teams.isNotEmpty) {
      final firstTeam = teams.first;
      print('DEBUG: First team has ${firstTeam.players.length} players');
      if (firstTeam.players.isNotEmpty) {
        final player = firstTeam.players.first;
        print('DEBUG: Found solo player in team: ${player.userName}');
        return player;
      }
    }

    print('DEBUG: No solo player found, returning null');
    return null;
  }

  // Helper method to get team progress info
  Map<String, dynamic> getTeamProgressInfo(Team team) {
    final progress = team.questionProgress;
    final answered = progress.where((p) => p.status == 'answered').length;
    final total = team.totalQuestions ?? totalQuestions;

    return {'answered': answered, 'total': total, 'progress': progress};
  }

  // Helper method to get player avatar with fallback
  String getPlayerAvatar(String? photoURL) {
    return photoURL ?? '';
  }

  // Helper method to check if player has answered current question
  bool hasPlayerAnswered(String? userId) {
    if (userId == null) return false;

    for (final team in teams) {
      final member = team.members.firstWhere(
        (m) => m.userId == userId,
        orElse:
            () => Member(
              id: null,
              userId: null,
              name: null,
              photoUrl: null,
              isLeader: null,
              individualScore: null,
              hasAnswered: null,
              questionsAnswered: null,
              correctAnswers: null,
            ),
      );
      if (member.hasAnswered == true) return true;
    }

    return false;
  }

  // Helper method to get team leader info
  Map<String, String> getTeamLeaderInfo(Team team) {
    return {
      'name': team.leaderName ?? '',
      'photoURL': team.leaderPhotoUrl ?? '',
    };
  }
}
