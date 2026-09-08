import 'dart:io';

void main() {
  var file = File('lib/features/casestore/screen/case_video_screen.dart');
  var content = file.readAsStringSync();

  final oldLoad = '''
      // Play the first cutscene (intro)
      if (cutsceneController.cutscenes.isNotEmpty) {
        _playCutscene(cutsceneController.cutscenes.first);
      }
    } else {
''';

  final newLoad = '''
      // Play the first cutscene (intro)
      if (cutsceneController.cutscenes.isNotEmpty) {
        _playCutscene(cutsceneController.cutscenes.first);
      } else {
        // No cutscenes available, skip video screen and enter game directly
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offNamed(AppRoutes.gameScreen);
        });
      }
    } else {
''';

  if (content.contains(oldLoad)) {
    content = content.replaceFirst(oldLoad, newLoad);
    file.writeAsStringSync(content);
    print("Patched CaseVideoScreen successfully.");
  } else {
    print("Could not find logic to patch");
  }
}
