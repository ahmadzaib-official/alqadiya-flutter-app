import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  // 1. var selectedAnswerIndex = Rx<int?>(null);
  content = content.replaceAll(
    'var selectedAnswerIndex = Rx<int?>(null);',
    'var selectedAnswerIndices = <int>{}.obs;'
  );

  // 2. selectedAnswerIndex.value = null;
  content = content.replaceAll(
    'selectedAnswerIndex.value = null;',
    'selectedAnswerIndices.clear();'
  );

  // 3. UI for Correct Answers Count (Top Right)
  // Ensure we don't duplicate replace
  content = content.replaceAll(
    "Text(\n                                          '\${footerController.correctAnswers}',",
    "Text(\n                                          '\${selectedAnswerIndices.where((idx) => currentQuestion?.answers[idx].isCorrect == true).length}',"
  );
  content = content.replaceAll(
    "Text(\n                                        '/\$totalQuestions'.tr,",
    "Text(\n                                        '/\${currentQuestion?.answers.where((a) => a.isCorrect == true).length ?? 1}'.tr,"
  );

  // 4. _buildAnswerOptions params and usage
  content = content.replaceAll(
    '''
  Widget _buildAnswerOptions(
    RxList<QuestionModel> questions,
    UserAnswerModel? lastAnswer,
    int? selectedIndex,
  ) {''',
    '''
  Widget _buildAnswerOptions(
    RxList<QuestionModel> questions,
    UserAnswerModel? lastAnswer,
  ) {'''
  );

  // Remove selectedIndex from the method call arguments
  final callMatch1 = '''
                                  final selectedIndex =
                                      selectedAnswerIndex.value;
                                  return _buildAnswerOptions(
                                    questions,
                                    lastAnswer,
                                    selectedIndex,
                                  );''';
  final callReplacement1 = '''
                                  return _buildAnswerOptions(
                                    questions,
                                    lastAnswer,
                                  );''';
  content = content.replaceAll(callMatch1, callReplacement1);

  // Inside _buildAnswerOptions
  content = content.replaceAll(
    'final isSelected = selectedIndex == index;',
    'final isSelected = selectedAnswerIndices.contains(index);'
  );

  // Replace onTap logic in _buildAnswerOptions
  content = content.replaceAll('''
            onTap: () {
              if (!isAnswerSubmitted || lastAnswer?.isCorrect == false) {
                selectedAnswerIndex.value = index;
                if (isAnswerSubmitted && lastAnswer?.isCorrect == false) {
                  // Clear the wrong answer state so they can try again
                  answerController.lastAnswer.value = null;
                }
              }
            },''', '''
            onTap: () {
              if (!isAnswerSubmitted || lastAnswer?.isCorrect == false) {
                if (selectedAnswerIndices.contains(index)) {
                  selectedAnswerIndices.remove(index);
                } else {
                  selectedAnswerIndices.add(index);
                }
                if (isAnswerSubmitted && lastAnswer?.isCorrect == false) {
                  // Clear the wrong answer state so they can try again
                  answerController.lastAnswer.value = null;
                }
              }
            },''');

  // 5. _submitAnswer Logic Update
  // Since the user reverted it, the old submit looks like:
  final oldSubmit = '''
    if (question == null ||
        sessionId == null ||
        selectedAnswerIndex.value == null) {
      CustomSnackbar.showError('Please select an answer'.tr);
      return;
    }

    final selectedAnswer = question.answers[selectedAnswerIndex.value!];
    if (selectedAnswer.id == null) {
      CustomSnackbar.showError('Invalid answer selected'.tr);
      return;
    }

    final timeSpent =
        questionStartTime != null
            ? DateTime.now().difference(questionStartTime!).inSeconds
            : 0;

    final success = await answerController.submitAnswer(
      sessionId: sessionId,
      questionId: question.id ?? '',
      selectedOptionId: selectedAnswer.id!,
      timeSpentSeconds: timeSpent,
      hintUsed: hintUsed,
    );

    if (success) {
      // Update local state - the Obx will rebuild automatically via answerController.lastAnswer
      setState(() {
        lastSubmittedAnswer = answerController.lastAnswer.value;
      });

      // Check if all questions are answered and navigate to result screen
      _checkAndNavigateToResult();
    }''';

  final newSubmit = '''
    if (question == null ||
        sessionId == null ||
        selectedAnswerIndices.isEmpty) {
      CustomSnackbar.showError('Please select at least one answer'.tr);
      return;
    }

    List<String> optionsToSend = selectedAnswerIndices.map((i) => question.answers[i].id!).toList();

    final timeSpent =
        questionStartTime != null
            ? DateTime.now().difference(questionStartTime!).inSeconds
            : 0;

    final success = await answerController.submitAnswer(
      sessionId: sessionId,
      questionId: question.id ?? '',
      selectedOptionIds: optionsToSend,
      timeSpentSeconds: timeSpent,
      hintUsed: hintUsed,
    );

    if (success) {
      // Update local state - the Obx will rebuild automatically via answerController.lastAnswer
      setState(() {
        lastSubmittedAnswer = answerController.lastAnswer.value;
      });

      if (answerController.lastAnswer.value?.isCorrect == true) {
        // Auto-advance on correct
        if (currentQuestionIndex != null &&
            currentQuestionIndex! < totalQuestions - 1) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            _nextQuestion();
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1000), () {
            Get.offNamed(AppRoutes.gameResultSummaryScreen);
          });
        }
      }

      // Check if all questions are answered and navigate to result screen
      _checkAndNavigateToResult();
    }''';

  content = content.replaceAll(oldSubmit, newSubmit);

  // If there's any remaining `selectedOptionId:` (from my previous run if it partially applied)
  content = content.replaceAll(
    'selectedOptionId: selectedAnswer.id!,',
    'selectedOptionIds: optionsToSend,' // If it was partially replaced
  );

  file.writeAsStringSync(content);
}
