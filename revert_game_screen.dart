import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  // Revert initState
  content = content.replaceFirst('''
            setState(() {
              // Use index-based navigation by default (index 0)
              currentQuestionIndex = 0;
            });
            footerController.updateProgressByIndex(0);
''', '''
            setState(() {
              // Use index-based navigation by default (index 0)
              currentQuestionIndex = 0;
            });
''');

  // Revert _loadQuestion
  content = content.replaceFirst('''
      // Clear the last answer when loading a new question
      answerController.lastAnswer.value = null;
    });
    footerController.updateProgressByIndex(index);
  }
''', '''
      // Clear the last answer when loading a new question
      answerController.lastAnswer.value = null;
    });
  }
''');

  // Revert _nextQuestion
  content = content.replaceFirst('''
      // Clear the last answer when moving to next question
      answerController.lastAnswer.value = null;
    });
    if (currentQuestionIndex != null) {
      footerController.updateProgressByIndex(currentQuestionIndex!);
    }
  }
''', '''
      // Clear the last answer when moving to next question
      answerController.lastAnswer.value = null;
    });
  }
''');

  file.writeAsStringSync(content);
  print("Reverted GameScreen changes");
}
