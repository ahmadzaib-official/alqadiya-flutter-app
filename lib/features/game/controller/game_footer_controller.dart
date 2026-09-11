import 'dart:async';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/question_controller.dart';
import 'package:alqadiya_game/features/game/controller/scoreboard_provider.dart';
import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';
import 'package:alqadiya_game/features/game/model/user_answer_model.dart';
import 'package:get/get.dart';

/// Controller for managing game footer state (score and progress)
class GameFooterController extends GetxController {
  final GameController _gameController = Get.find<GameController>();
  final QuestionController _questionController = Get.find<QuestionController>();
  final UserAnswerController _answerController =
      Get.find<UserAnswerController>();

  // Observable values
  var totalScore = 0.obs;
  var answeredQuestions = 0.obs;
  var progressPercentage = 0.0.obs;

  // Store all submitted answers to calculate total score
  final RxList<UserAnswerModel> _submittedAnswers = <UserAnswerModel>[].obs;

  // Polling timer for scoreboard refresh
  Timer? _scoreboardPollTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
    _updateValues();
    // Start polling scoreboard every 3 seconds for team score
    _startScoreboardPolling();
    // Also listen to scoreboard changes reactively
    _listenToScoreboard();
  }

  @override
  void onClose() {
    _scoreboardPollTimer?.cancel();
    super.onClose();
  }

  void _startScoreboardPolling() {
    _scoreboardPollTimer?.cancel();
    _scoreboardPollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchAndUpdateScore();
    });
  }

  void _listenToScoreboard() {
    try {
      final scoreboardController = Get.find<ScoreboardController>();
      // React whenever scoreboard data changes (from any source)
      ever(scoreboardController.scoreboard, (_) {
        final score = _getTeamScoreFromScoreboard();
        if (score != null) {
          totalScore.value = score;
        }
        
        // Also update progress
        final teamProgress = _getTeamProgressFromScoreboard();
        if (teamProgress != null) {
           _updateProgressValue(teamProgress);
        }
      });
    } catch (_) {
      // ScoreboardController not yet available
    }
  }

  Future<void> _fetchAndUpdateScore() async {
    final sessionId = _gameController.gameSession.value?.id;
    if (sessionId == null) return;

    try {
      final scoreboardController = Get.find<ScoreboardController>();
      await scoreboardController.refreshScoreboard(sessionId: sessionId);
      final score = _getTeamScoreFromScoreboard();
      if (score != null) {
        totalScore.value = score;
      }
      
      final teamProgress = _getTeamProgressFromScoreboard();
      if (teamProgress != null) {
         _updateProgressValue(teamProgress);
      }
    } catch (_) {
      // ScoreboardController not registered yet — skip silently
    }
  }

  void _initializeListeners() {
    // Listen to answer submissions
    ever(_answerController.lastAnswer, (UserAnswerModel? answer) {
      if (answer != null) {
        _addAnswer(answer);
        _updateValues();
        // Immediately refresh score after submitting answer
        _fetchAndUpdateScore();
      }
    });

    // Listen to questions changes
    ever(_questionController.questions, (_) {
      _updateValues();
    });
  }

  void _addAnswer(UserAnswerModel answer) {
    // Check if this answer already exists (avoid duplicates)
    final existingIndex = _submittedAnswers.indexWhere(
      (a) => a.questionId == answer.questionId,
    );

    if (existingIndex != -1) {
      // Update existing answer
      _submittedAnswers[existingIndex] = answer;
    } else {
      // Add new answer
      _submittedAnswers.add(answer);
    }
  }

  void _updateValues() {
    // Determine answered questions: prefer scoreboard if team mode, otherwise local
    final teamProgress = _getTeamProgressFromScoreboard();
    final int answered = teamProgress ?? _submittedAnswers.length;
    
    answeredQuestions.value = answered;
    _updateProgressValue(answered);

    // For score: use scoreboard score if available, else local
    final scoreboardScore = _getTeamScoreFromScoreboard();
    if (scoreboardScore != null) {
      totalScore.value = scoreboardScore;
    } else {
      totalScore.value = _submittedAnswers.fold<int>(
        0,
        (sum, answer) => sum + (answer.pointsEarned ?? 0),
      );
    }
  }

  void _updateProgressValue(int answeredCount) {
    final totalQuestions = _questionController.questions.length;
    if (totalQuestions > 0) {
      // Progress based on answered questions + 1 (for the current question being viewed)
      int currentQ = answeredCount + 1;
      if (currentQ > totalQuestions) currentQ = totalQuestions;
      progressPercentage.value = currentQ / totalQuestions;
    } else {
      progressPercentage.value = 0.0;
    }
  }

  // Get total questions count
  int get totalQuestions => _questionController.questions.length;

  // Get current progress as a fraction (0.0 to 1.0)
  double get progress => progressPercentage.value;

  // Get count of correct answers
  int get correctAnswers =>
      _submittedAnswers.where((answer) => answer.isCorrect == true).length;

  /// Get the current user's team score from scoreboard.
  /// Returns null if scoreboard not available.
  int? _getTeamScoreFromScoreboard() {
    try {
      final scoreboardController = Get.find<ScoreboardController>();
      final scoreboard = scoreboardController.scoreboard.value;
      if (scoreboard == null) return null;

      final sessionMode = _gameController.gameSession.value?.mode;

      if (sessionMode == 'solo') {
        // Solo mode — individual score
        final rootPlayers = scoreboard.players;
        if (rootPlayers != null && rootPlayers.isNotEmpty) {
          return rootPlayers.first.individualScore;
        }
        return scoreboard.teams.firstOrNull?.players.firstOrNull?.individualScore;
      } else {
        // Team mode — find the team that contains the logged-in user
        final userId = Get.find<Preferences>().getString(AppStrings.userId);
        final teams = scoreboard.teams;

        if (teams.isEmpty) return null;

        // Try to find user's team
        if (userId != null && userId.isNotEmpty) {
          final myTeam = teams.firstWhereOrNull(
            (t) =>
                t.members.any((m) => m.userId == userId) ||
                t.players.any((p) => p.userId == userId),
          );
          if (myTeam != null) {
            return scoreboardController.getTeamScore(myTeam);
          }
        }

        // Fallback: return first team's score
        return scoreboardController.getTeamScore(teams.first);
      }
    } catch (_) {
      return null;
    }
  }
  
  /// Get the current user's team progress (number of answered questions) from scoreboard.
  /// Returns null if scoreboard not available or not in team mode.
  int? _getTeamProgressFromScoreboard() {
    try {
      final scoreboardController = Get.find<ScoreboardController>();
      final scoreboard = scoreboardController.scoreboard.value;
      if (scoreboard == null) return null;

      final sessionMode = _gameController.gameSession.value?.mode;

      if (sessionMode == 'team') {
        final userId = Get.find<Preferences>().getString(AppStrings.userId);
        final teams = scoreboard.teams;

        if (teams.isEmpty) return null;

        if (userId != null && userId.isNotEmpty) {
          final myTeam = teams.firstWhereOrNull(
            (t) =>
                t.members.any((m) => m.userId == userId) ||
                t.players.any((p) => p.userId == userId),
          );
          if (myTeam != null) {
            final info = scoreboardController.getTeamProgressInfo(myTeam);
            return info['answered'] as int?;
          }
        }

        final info = scoreboardController.getTeamProgressInfo(teams.first);
        return info['answered'] as int?;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // Public method kept for backward compatibility
  int? getScoreFromScoreboard() => _getTeamScoreFromScoreboard();

  // Public refresh method
  Future<void> refreshScoreFromScoreboard() => _fetchAndUpdateScore();

  // Reset all values (useful when starting a new game)
  void reset() {
    _scoreboardPollTimer?.cancel();
    _submittedAnswers.clear();
    totalScore.value = 0;
    answeredQuestions.value = 0;
    progressPercentage.value = 0.0;
    // Restart polling
    _startScoreboardPolling();
    _listenToScoreboard();
  }

  // Manually add an answer (useful for initialization or syncing)
  void addAnswer(UserAnswerModel answer) {
    _addAnswer(answer);
    _updateValues();
  }

  // Initialize with existing answers (useful when loading game state)
  void initializeWithAnswers(List<UserAnswerModel> answers) {
    _submittedAnswers.assignAll(answers);
    _updateValues();
  }
}
