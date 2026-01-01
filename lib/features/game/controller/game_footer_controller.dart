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
  final UserAnswerController _answerController = Get.find<UserAnswerController>();

  // Observable values
  var totalScore = 0.obs;
  var answeredQuestions = 0.obs;
  var progressPercentage = 0.0.obs;

  // Store all submitted answers to calculate total score
  final RxList<UserAnswerModel> _submittedAnswers = <UserAnswerModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeListeners();
    _updateValues();
    // Try to refresh score from scoreboard on initialization
    _refreshScoreFromScoreboardIfAvailable();
  }

  void _initializeListeners() {
    // Listen to answer submissions
    ever(_answerController.lastAnswer, (UserAnswerModel? answer) {
      if (answer != null) {
        _addAnswer(answer);
        _updateValues();
        // Try to refresh score from scoreboard after answer submission
        _refreshScoreFromScoreboardIfAvailable();
      }
    });

    // Listen to questions changes
    ever(_questionController.questions, (_) {
      _updateValues();
    });
  }

  void _refreshScoreFromScoreboardIfAvailable() {
    // Try to get score from scoreboard if available (non-blocking)
    try {
      final scoreboardScore = getScoreFromScoreboard();
      if (scoreboardScore != null) {
        // Use scoreboard score as it's the source of truth
        totalScore.value = scoreboardScore;
      }
    } catch (e) {
      // Scoreboard not available, continue with local calculation
    }
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
    // Calculate total score from all submitted answers
    totalScore.value = _submittedAnswers.fold<int>(
      0,
      (sum, answer) => sum + (answer.pointsEarned ?? 0),
    );

    // Count answered questions
    answeredQuestions.value = _submittedAnswers.length;

    // Calculate progress percentage
    final totalQuestions = _questionController.questions.length;
    if (totalQuestions > 0) {
      progressPercentage.value = answeredQuestions.value / totalQuestions;
    } else {
      progressPercentage.value = 0.0;
    }
  }

  // Get total questions count
  int get totalQuestions => _questionController.questions.length;

  // Get current progress as a fraction (0.0 to 1.0)
  double get progress => progressPercentage.value;

  // Get score from scoreboard if available (for team mode)
  int? getScoreFromScoreboard() {
    try {
      final scoreboardController = Get.find<ScoreboardController>();
      final scoreboard = scoreboardController.scoreboard.value;

      if (scoreboard == null) return null;

      final sessionMode = _gameController.gameSession.value?.mode;

      if (sessionMode == 'solo') {
        // Solo mode - get individual score
        final player = scoreboard.players?.firstOrNull;
        return player?.individualScore;
      } else {
        // Team mode - get team score (first team for now)
        // In team mode, we might want to show the current user's team score
        final team = scoreboard.teams?.firstOrNull;
        return team?.teamScore;
      }
    } catch (e) {
      // ScoreboardController not found or not initialized
      return null;
    }
  }

  // Refresh score from scoreboard API
  Future<void> refreshScoreFromScoreboard() async {
    final sessionId = _gameController.gameSession.value?.id;
    if (sessionId == null) return;

    try {
      final scoreboardController = Get.find<ScoreboardController>();
      await scoreboardController.refreshScoreboard(sessionId: sessionId);

      // Update score from scoreboard if available
      final scoreboardScore = getScoreFromScoreboard();
      if (scoreboardScore != null) {
        totalScore.value = scoreboardScore;
      }
    } catch (e) {
      // ScoreboardController not found, continue with local calculation
    }
  }

  // Reset all values (useful when starting a new game)
  void reset() {
    _submittedAnswers.clear();
    totalScore.value = 0;
    answeredQuestions.value = 0;
    progressPercentage.value = 0.0;
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

