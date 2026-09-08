import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/evidence_list_screen.dart');
  var content = file.readAsStringSync();

  // Add import for userAnswerController
  if (!content.contains('package:alqadiya_game/features/game/controller/user_answer_controller.dart')) {
    content = "import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';\n" + content;
  }

  // Get userAnswerController instance in the state
  if (!content.contains('final userAnswerController = Get.find<UserAnswerController>();')) {
    final oldState = '''
class _EvidenceListScreenState extends State<EvidenceListScreen> {
  late final GameTimerController timerController;
  final evidenceController = Get.find<EvidenceController>();
  final gameController = Get.find<GameController>();
''';
    final newState = '''
class _EvidenceListScreenState extends State<EvidenceListScreen> {
  late final GameTimerController timerController;
  final evidenceController = Get.find<EvidenceController>();
  final gameController = Get.find<GameController>();
  final userAnswerController = Get.isRegistered<UserAnswerController>() ? Get.find<UserAnswerController>() : Get.put(UserAnswerController());
''';
    content = content.replaceFirst(oldState, newState);
  }

  // Modify the itemBuilder to add "New!" badge
  final oldItemBuilder = '''
                            itemCount: evidences.length,
                            itemBuilder: (context, index) {
                              final evidence = evidences[index];
                              return GestureDetector(
''';
  final newItemBuilder = '''
                            itemCount: evidences.length,
                            itemBuilder: (context, index) {
                              final evidence = evidences[index];
                              final newlyUnlocked = userAnswerController.lastAnswer.value?.unlockedEvidenceIds?.contains(evidence.id) ?? false;
                              return GestureDetector(
''';
  content = content.replaceFirst(oldItemBuilder, newItemBuilder);

  final oldImageContainer = '''
                                    // Evidence Image
                                    Container(
                                      width: 50.w,
                                      height: 60.w,
''';
  final newImageContainer = '''
                                    // Evidence Image
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 50.w,
                                          height: 60.w,
''';
  content = content.replaceFirst(oldImageContainer, newImageContainer);

  final oldClipRRect = '''
                                      ),
                                      child: ClipRRect(
''';
  final newClipRRect = '''
                                        ),
                                        child: ClipRRect(
''';
  content = content.replaceFirst(oldClipRRect, newClipRRect);

  final oldClosing = '''
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
''';
  final newClosing = '''
                                          ),
                                        ),
                                        if (newlyUnlocked)
                                          Positioned(
                                            top: -5.h,
                                            right: -5.w,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                                              decoration: BoxDecoration(
                                                color: MyColors.redButtonColor,
                                                borderRadius: BorderRadius.circular(4.r),
                                              ),
                                              child: Text(
                                                'New!'.tr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 4.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
''';
  
  if (!content.contains('if (newlyUnlocked)')) {
    content = content.replaceFirst(oldClosing, newClosing);
    file.writeAsStringSync(content);
    print('Patched evidence_list_screen.dart');
  } else {
    print('Already patched');
  }
}
