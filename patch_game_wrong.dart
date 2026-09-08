import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  final oldLogic = '''
      if (answerController.lastAnswer.value?.isCorrect == true) {
        final answer = answerController.lastAnswer.value!;
        final isArabic = Get.locale?.languageCode == 'ar';
        final dynamicSubtitle = isArabic ? answer.unlockMessageAr : answer.unlockMessageEn;
        final hasNewEvidence = (answer.unlockedEvidenceCount ?? 0) > 0;
        final hasUnlockMessage = dynamicSubtitle != null && dynamicSubtitle.isNotEmpty;

        if (hasNewEvidence || hasUnlockMessage) {
''';

  final newLogic = '''
      if (answerController.lastAnswer.value != null) {
        final answer = answerController.lastAnswer.value!;
        final isArabic = Get.locale?.languageCode == 'ar';
        final dynamicSubtitle = isArabic ? answer.unlockMessageAr : answer.unlockMessageEn;
        final hasNewEvidence = (answer.unlockedEvidenceCount ?? 0) > 0;
        final hasUnlockMessage = dynamicSubtitle != null && dynamicSubtitle.isNotEmpty;

        if (hasNewEvidence || hasUnlockMessage) {
''';
  
  if (content.contains(oldLogic)) {
    content = content.replaceFirst(oldLogic, newLogic);
    file.writeAsStringSync(content);
    print("Patched game_screen.dart for wrong answers");
  } else {
    print("Could not find logic to patch");
  }
}
