import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/game/model/question_model.dart';
import 'package:alqadiya_game/features/game/model/user_answer_model.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/question_controller.dart';
import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_footer_controller.dart';
import 'package:alqadiya_game/features/game/controller/evidence_controller.dart';
import 'package:alqadiya_game/features/game/widget/evidence_unlocked_dialog.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';

class GameScreenController extends GetxController {
  late final GameTimerController timerController;
  final QuestionController questionController = Get.find<QuestionController>();
  final UserAnswerController answerController = Get.find<UserAnswerController>();
  late final GameFooterController footerController;

  final _currentQuestionIndex = Rx<int?>(null);
  int? get currentQuestionIndex => _currentQuestionIndex.value;
  set currentQuestionIndex(int? value) => _currentQuestionIndex.value = value;

  var selectedAnswerIndices = <int>{}.obs;

  final _hintUsed = false.obs;
  bool get hintUsed => _hintUsed.value;
  set hintUsed(bool value) => _hintUsed.value = value;

  final _questionStartTime = Rx<DateTime?>(null);
  DateTime? get questionStartTime => _questionStartTime.value;
  set questionStartTime(DateTime? value) => _questionStartTime.value = value;

  final _lastSubmittedAnswer = Rx<UserAnswerModel?>(null);
  UserAnswerModel? get lastSubmittedAnswer => _lastSubmittedAnswer.value;
  set lastSubmittedAnswer(UserAnswerModel? value) => _lastSubmittedAnswer.value = value;

  bool _isNavigatingToResult = false;
  Timer? _hostStatusTimer;

  @override
  void onInit() {
    super.onInit();
    _initializeGameScreen();
  }

  void _initializeGameScreen() {
    questionController.reset();
    answerController.reset();

    currentQuestionIndex = null;
    selectedAnswerIndices.clear();
    hintUsed = false;
    questionStartTime = null;
    lastSubmittedAnswer = null;
    _isNavigatingToResult = false;

    timerController = Get.put(GameTimerController(), permanent: true);

    _hostStatusTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkHostStatus();
    });

    if (!Get.isRegistered<GameFooterController>()) {
      Get.put(GameFooterController(), permanent: true);
    }
    footerController = Get.find<GameFooterController>();
    footerController.reset();

    ever(questionController.questions, (questions) {
      if (questions.isNotEmpty && currentQuestion == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (currentQuestion == null) {
            currentQuestionIndex = 0;
          }
        });
      }
    });

    final gameController = Get.isRegistered<GameController>() 
        ? Get.find<GameController>() 
        : Get.put(GameController(), permanent: true);

    var gameId = gameController.gameDetail.value.id ?? gameController.gameSession.value?.gameId;

    if (gameId == null && gameController.gameSession.value?.id != null) {
      _getGameIdFromSessionStatus(gameController);
    } else if (gameId != null) {
      if (gameController.gameDetail.value.id == null) {
        gameController.getGameDetail(gameId: gameId).then((_) {
          _startTimerFromGameDetails(gameController);
        });
      } else {
        _startTimerFromGameDetails(gameController);
      }

      questionController.getQuestionsByGame(
        gameId: gameId,
        language: Get.locale?.languageCode ?? 'en',
      );
    } else {
      timerController.startTimer(gameId: null);
    }

    questionStartTime = DateTime.now();
  }

  Future<void> checkHostStatus() async {
    final gameController = Get.isRegistered<GameController>() ? Get.find<GameController>() : null;
    final sessionId = gameController?.gameSession.value?.id;

    if (sessionId == null) return;

    try {
      final response = await GameRepository().getHostStatus(sessionId: sessionId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null && response.data['hasHostLeft'] == true) {
          _hostStatusTimer?.cancel();
          CustomSnackbar.showError('Host has left the game session'.tr);
          Get.offAllNamed(AppRoutes.homescreen);
        }
      }
    } catch (e) {
      // Silently handle errors for polling
    }
  }

  Future<void> _getGameIdFromSessionStatus(GameController gameController) async {
    final sessionId = gameController.gameSession.value?.id;
    if (sessionId == null) {
      timerController.startTimer(gameId: null);
      return;
    }

    try {
      final response = await GameRepository().getGameSessionStatus(sessionId: sessionId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          String? gameId;
          if (response.data['gameId'] != null) {
            gameId = response.data['gameId'] as String?;
          } else if (response.data['session'] != null && response.data['session']['gameId'] != null) {
            gameId = response.data['session']['gameId'] as String?;
          } else {
            gameId = gameController.gameSession.value?.gameId;
          }

          if (gameId != null && gameId.isNotEmpty) {
            await gameController.getGameDetail(gameId: gameId);
            _startTimerFromGameDetails(gameController);
            questionController.getQuestionsByGame(
              gameId: gameId,
              language: Get.locale?.languageCode ?? 'en',
            );
          } else {
            await _getGameIdFromSessionDetails(gameController, sessionId);
          }
        } else {
          await _getGameIdFromSessionDetails(gameController, sessionId);
        }
      } else {
        await _getGameIdFromSessionDetails(gameController, sessionId);
      }
    } catch (e) {
      await _getGameIdFromSessionDetails(gameController, sessionId);
    }
  }

  Future<void> _getGameIdFromSessionDetails(GameController gameController, String sessionId) async {
    try {
      await gameController.getGameSessionDetails(sessionId: sessionId);
      final gameId = gameController.gameSession.value?.gameId;
      if (gameId != null && gameId.isNotEmpty) {
        await gameController.getGameDetail(gameId: gameId);
        _startTimerFromGameDetails(gameController);
        questionController.getQuestionsByGame(
          gameId: gameId,
          language: Get.locale?.languageCode ?? 'en',
        );
      } else {
        timerController.startTimer(gameId: null);
      }
    } catch (e) {
      timerController.startTimer(gameId: null);
    }
  }

  void _startTimerFromGameDetails(GameController gameController) {
    final estimatedDuration = gameController.gameDetail.value.estimatedDuration;
    final gameId = gameController.gameDetail.value.id ?? gameController.gameSession.value?.gameId;

    if (estimatedDuration != null && estimatedDuration > 0) {
      timerController.startTimer(
        initialMinutes: estimatedDuration,
        initialSeconds: 0,
        gameId: gameId,
      );
    } else {
      timerController.startTimer(gameId: gameId);
    }
  }

  int get totalQuestions => questionController.questions.length;
  int get correctAnswers => footerController.correctAnswers;

  QuestionModel? get currentQuestion {
    if (currentQuestionIndex == null) return null;

    if (!questionController.useOrderBasedNavigation.value) {
      return questionController.getQuestionByIndex(currentQuestionIndex!);
    } else {
      return questionController.questions.firstWhereOrNull(
        (q) => q.order == currentQuestionIndex,
      );
    }
  }

  void loadQuestion(int index) {
    currentQuestionIndex = index;
    selectedAnswerIndices.clear();
    hintUsed = false;
    questionStartTime = DateTime.now();
    lastSubmittedAnswer = null;
    answerController.lastAnswer.value = null;
  }

  void submitAnswer() async {
    final question = currentQuestion;
    final gameController = Get.find<GameController>();
    final sessionId = gameController.gameSession.value?.id;

    if (question == null || sessionId == null || selectedAnswerIndices.isEmpty) {
      CustomSnackbar.showError('Please select at least one answer'.tr);
      return;
    }

    List<String> optionsToSend = selectedAnswerIndices.map((i) => question.answers[i].id!).toList();
    final timeSpent = questionStartTime != null ? DateTime.now().difference(questionStartTime!).inSeconds : 0;

    final success = await answerController.submitAnswer(
      sessionId: sessionId,
      questionId: question.id ?? '',
      selectedOptionIds: optionsToSend,
      timeSpentSeconds: timeSpent,
      hintUsed: hintUsed,
    );

    if (success) {
      lastSubmittedAnswer = answerController.lastAnswer.value;

      if (answerController.lastAnswer.value != null) {
        final answer = answerController.lastAnswer.value!;
        final isArabic = Get.locale?.languageCode == 'ar';
        final dynamicSubtitle = isArabic ? answer.unlockMessageAr : answer.unlockMessageEn;
        final hasNewEvidence = (answer.unlockedEvidenceCount ?? 0) > 0;
        final hasUnlockMessage = dynamicSubtitle != null && dynamicSubtitle.isNotEmpty;

        if (answer.isCorrect == true && (hasNewEvidence || hasUnlockMessage)) {
          if (Get.isRegistered<EvidenceController>()) {
            Get.find<EvidenceController>().getEvidencesByGame(
              gameId: gameController.gameDetail.value.id ?? '',
              sessionId: sessionId,
            );
          }

          final defaultSubtitle = isArabic ? 'لقد حصلت على أدلة إضافية' : 'New evidence added to your case file.';

          Get.dialog(
            EvidenceUnlockedDialog(
              title: 'Congratulations!'.tr,
              subtitle: dynamicSubtitle ?? defaultSubtitle,
              showIcon: hasNewEvidence,
              onDismiss: () {
                Get.back(); // Close dialog
                if (answer.isCorrect == true) {
                  if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
                    nextQuestion();
                  } else {
                    Get.offNamed(AppRoutes.gameResultSummaryScreen);
                  }
                }
              },
            ),
            barrierDismissible: false,
          );
          return;
        } else {
          if (answer.isCorrect == true) {
            if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
              nextQuestion();
            } else {
              Get.offNamed(AppRoutes.gameResultSummaryScreen);
            }
          }
          return;
        }
      }

      checkAndNavigateToResult();
    } else {
      CustomSnackbar.showError('Failed to submit answer. Please try again.'.tr);
    }
  }

  void checkAndNavigateToResult() {
    if (_isNavigatingToResult) return;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isNavigatingToResult) return;

      final totalQuestions = questionController.questions.length;
      final answeredQuestions = footerController.answeredQuestions.value;

      if (totalQuestions > 0 && answeredQuestions >= totalQuestions) {
        _isNavigatingToResult = true;
        Get.offNamed(AppRoutes.gameResultSummaryScreen);
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
      loadQuestion(currentQuestionIndex! + 1);
    }
  }

  @override
  void onClose() {
    _hostStatusTimer?.cancel();
    if (Get.isRegistered<GameTimerController>()) {
      timerController.pauseTimer();
    }
    super.onClose();
  }
}
