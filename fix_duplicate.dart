import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  // The replace_file_content might have added _nextQuestion twice because of bad diffing.
  // Let's remove the first _nextQuestion definition from line 312.
  final regex = RegExp(r'  void _nextQuestion\(\) \{(.*?)\}(?=\s*void _nextQuestion\(\))', dotAll: true);
  if (regex.hasMatch(content)) {
    content = content.replaceFirst(regex, '');
    file.writeAsStringSync(content);
    print("Fixed duplicate _nextQuestion");
  } else {
    // try to find the duplicate another way
    final split = content.split('  void _nextQuestion() {');
    if (split.length > 2) {
      // It exists at least twice
      content = content.replaceFirst('''
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

''', '');
      file.writeAsStringSync(content);
      print("Fixed duplicate by string matching");
    } else {
       print("Not duplicate found");
    }
  }
}
