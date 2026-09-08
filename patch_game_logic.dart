import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_screen.dart');
  var content = file.readAsStringSync();

  final oldLogic = '''
      if (answerController.lastAnswer.value?.isCorrect == true) {
        // Refresh evidence list from the backend since answering this question unlocks new evidence
        // Note: The new backend requirement specifies passing sessionId. The UI currently calls getEvidencesByGame with just gameId. We'll update the repository separately.
        if (Get.isRegistered<EvidenceController>()) {
          Get.find<EvidenceController>().getEvidencesByGame(
            gameId: gameController.gameDetail.value.id ?? '', 
            sessionId: sessionId,
          );
        }

        final isArabic = Get.locale?.languageCode == 'ar';
        final defaultSubtitle = isArabic ? 'لقد حصلت على أدلة إضافية' : 'New evidence added to your case file.';
        final dynamicSubtitle = isArabic 
            ? answerController.lastAnswer.value?.unlockMessageAr 
            : answerController.lastAnswer.value?.unlockMessageEn;

        // Show the 4-second evidence unlocked pop-up
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => EvidenceUnlockedDialog(
            title: 'Congratulations!'.tr,
            subtitle: dynamicSubtitle ?? defaultSubtitle,
            onDismiss: () {
              Navigator.pop(context);
              
              // Proceed to next question or result after dialog is closed
              if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
                _nextQuestion();
              } else {
                Get.offNamed(AppRoutes.gameResultSummaryScreen);
              }
            },
          ),
        );
        return;
      }
''';

  final newLogic = '''
      if (answerController.lastAnswer.value?.isCorrect == true) {
        final answer = answerController.lastAnswer.value!;
        final isArabic = Get.locale?.languageCode == 'ar';
        final dynamicSubtitle = isArabic ? answer.unlockMessageAr : answer.unlockMessageEn;
        final hasNewEvidence = (answer.unlockedEvidenceCount ?? 0) > 0;
        final hasUnlockMessage = dynamicSubtitle != null && dynamicSubtitle.isNotEmpty;

        if (hasNewEvidence || hasUnlockMessage) {
          // Refresh evidence list from the backend
          if (Get.isRegistered<EvidenceController>()) {
            Get.find<EvidenceController>().getEvidencesByGame(
              gameId: gameController.gameDetail.value.id ?? '', 
              sessionId: sessionId,
            );
          }

          final defaultSubtitle = isArabic ? 'لقد حصلت على أدلة إضافية' : 'New evidence added to your case file.';
          
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => EvidenceUnlockedDialog(
              title: 'Congratulations!'.tr,
              subtitle: dynamicSubtitle ?? defaultSubtitle,
              showIcon: hasNewEvidence, // if > 0 show folder, if just message show plain confirmation
              onDismiss: () {
                Navigator.pop(context);
                if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
                  _nextQuestion();
                } else {
                  Get.offNamed(AppRoutes.gameResultSummaryScreen);
                }
              },
            ),
          );
          return;
        } else {
          // just proceed directly
          if (currentQuestionIndex != null && currentQuestionIndex! < totalQuestions - 1) {
            _nextQuestion();
          } else {
            Get.offNamed(AppRoutes.gameResultSummaryScreen);
          }
          return;
        }
      }
''';

  if (content.contains(oldLogic)) {
    content = content.replaceAll(oldLogic, newLogic);
    file.writeAsStringSync(content);
    print('game_screen.dart logic patched.');
  } else {
    print('Failed to patch game_screen.dart: Content not found');
  }
}
