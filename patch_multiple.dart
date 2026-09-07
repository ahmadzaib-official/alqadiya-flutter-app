import 'dart:io';

void main() {
  // 1. Update UserAnswerModel
  var file = File('lib/features/game/model/user_answer_model.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'final String? selectedOptionId;',
    'final List<String>? selectedOptionIds;'
  );
  content = content.replaceAll(
    'this.selectedOptionId,',
    'this.selectedOptionIds,'
  );
  content = content.replaceAll(
    'selectedOptionId: json["selectedOptionId"],',
    'selectedOptionIds: json["selectedOptionIds"] != null ? List<String>.from(json["selectedOptionIds"]) : null,'
  );
  content = content.replaceAll(
    '"selectedOptionId": selectedOptionId,',
    '"selectedOptionIds": selectedOptionIds,'
  );
  file.writeAsStringSync(content);

  // 2. Update UserAnswerRepository
  file = File('lib/features/game/repository/user_answer_repository.dart');
  content = file.readAsStringSync();
  content = content.replaceAll(
    'required String selectedOptionId,',
    'required List<String> selectedOptionIds,'
  );
  content = content.replaceAll(
    '"selectedOptionId": selectedOptionId,',
    '"selectedOptionIds": selectedOptionIds,'
  );
  file.writeAsStringSync(content);

  // 3. Update UserAnswerController
  file = File('lib/features/game/controller/user_answer_controller.dart');
  content = file.readAsStringSync();
  content = content.replaceAll(
    'required String selectedOptionId,',
    'required List<String> selectedOptionIds,'
  );
  content = content.replaceAll(
    'selectedOptionId: selectedOptionId,',
    'selectedOptionIds: selectedOptionIds,'
  );
  file.writeAsStringSync(content);

  // 4. Update GameScreen
  file = File('lib/features/game/screen/game_screen.dart');
  content = file.readAsStringSync();
  
  // Update submit answer payload to pass selectedOptionIds
  content = content.replaceAll(
    'String optionToSend = \'\';\n    if (isLocalCorrect) {\n       optionToSend = question.correctAnswerId ?? question.answers[selectedAnswerIndices.first].id!;\n    } else {\n       // Find a wrong option ID to send to backend to guarantee a wrong result\n       try {\n          optionToSend = question.answers.firstWhere((a) => a.isCorrect != true).id!;\n       } catch(e) {\n          optionToSend = question.answers.first.id!; // Fallback\n       }\n    }',
    'List<String> optionsToSend = selectedAnswerIndices.map((i) => question.answers[i].id!).toList();'
  );
  content = content.replaceAll(
    'selectedOptionId: optionToSend,',
    'selectedOptionIds: optionsToSend,'
  );
  
  file.writeAsStringSync(content);
}
