import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  final oldState = '''
            setState(() {
              // Use index-based navigation by default (index 0)
              currentQuestionIndex = 0;
            });
''';

  final newState = '''
            setState(() {
              // Use index-based navigation by default (index 0)
              currentQuestionIndex = 0;
            });
            footerController.updateProgressByIndex(0);
''';

  content = content.replaceFirst(oldState, newState);

  final oldNext = '''
  void _nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex ?? 0) + 1;
      selectedAnswerIndices.clear();
      hintUsed = false;
      questionStartTime = DateTime.now();
      lastSubmittedAnswer = null;
      // Clear the last answer when moving to next question
      answerController.lastAnswer.value = null;
    });
  }
''';

  final newNext = '''
  void _nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex ?? 0) + 1;
      selectedAnswerIndices.clear();
      hintUsed = false;
      questionStartTime = DateTime.now();
      lastSubmittedAnswer = null;
      // Clear the last answer when moving to next question
      answerController.lastAnswer.value = null;
    });
    if (currentQuestionIndex != null) {
      footerController.updateProgressByIndex(currentQuestionIndex!);
    }
  }
''';

  if (content.contains(oldNext)) {
    content = content.replaceFirst(oldNext, newNext);
    file.writeAsStringSync(content);
    print("Patched GameScreen for progress");
  } else {
    print("Failed to patch GameScreen");
  }
}
