import 'dart:io';

void main() {
  var file = File('lib/features/game/controller/game_footer_controller.dart');
  var content = file.readAsStringSync();

  final oldUpdate = '''
    // Calculate progress percentage
    final totalQuestions = _questionController.questions.length;
    if (totalQuestions > 0) {
      // Progress based on answered questions
      progressPercentage.value = answeredQuestions.value / totalQuestions;
    } else {
      progressPercentage.value = 0.0;
    }
  }

  // Manually update progress based on current question index
  void updateProgressByIndex(int currentIndex) {
    final totalQuestions = _questionController.questions.length;
    if (totalQuestions > 0) {
      progressPercentage.value = (currentIndex + 1) / totalQuestions;
    }
  }
''';

  final newUpdate = '''
    // Calculate progress percentage
    final totalQuestions = _questionController.questions.length;
    if (totalQuestions > 0) {
      // Progress based on answered questions + 1 (for the current question being viewed)
      int currentQ = answeredQuestions.value + 1;
      if (currentQ > totalQuestions) currentQ = totalQuestions;
      progressPercentage.value = currentQ / totalQuestions;
    } else {
      progressPercentage.value = 0.0;
    }
  }
''';

  if (content.contains(oldUpdate)) {
    content = content.replaceFirst(oldUpdate, newUpdate);
    file.writeAsStringSync(content);
    print("Patched GameFooterController reactively");
  } else {
    print("Failed to patch GameFooterController reactively");
  }
}
