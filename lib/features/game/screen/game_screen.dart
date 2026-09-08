import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/game/controller/game_footer_controller.dart';
import 'package:alqadiya_game/features/game/controller/question_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_screen_controller.dart';
import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';
import 'package:alqadiya_game/features/game/model/question_model.dart';
import 'package:alqadiya_game/features/game/model/user_answer_model.dart';
import 'package:alqadiya_game/features/game/widget/question_stepper.dart';
import 'package:alqadiya_game/features/game/widget/video_hint_dialog.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/leave_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/casestore/controller/add_case_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AddCaseController controller = Get.put(AddCaseController());
  final GameScreenController screenController = Get.put(GameScreenController());

  // Helper getters to keep UI code unchanged as much as possible
  GameTimerController get timerController => screenController.timerController;
  QuestionController get questionController =>
      screenController.questionController;
  UserAnswerController get answerController =>
      screenController.answerController;
  GameFooterController get footerController =>
      screenController.footerController;

  int? get currentQuestionIndex => screenController.currentQuestionIndex;
  set currentQuestionIndex(int? value) =>
      screenController.currentQuestionIndex = value;

  RxSet<int> get selectedAnswerIndices =>
      screenController.selectedAnswerIndices;

  bool get hintUsed => screenController.hintUsed;
  set hintUsed(bool value) => screenController.hintUsed = value;

  DateTime? get questionStartTime => screenController.questionStartTime;
  set questionStartTime(DateTime? value) =>
      screenController.questionStartTime = value;

  UserAnswerModel? get lastSubmittedAnswer =>
      screenController.lastSubmittedAnswer;
  set lastSubmittedAnswer(UserAnswerModel? value) =>
      screenController.lastSubmittedAnswer = value;

  int get totalQuestions => screenController.totalQuestions;
  int get correctAnswers => screenController.correctAnswers;
  QuestionModel? get currentQuestion => screenController.currentQuestion;

  void _loadQuestion(int index) => screenController.loadQuestion(index);
  void _submitAnswer() => screenController.submitAnswer();
  void _nextQuestion() => screenController.nextQuestion();

  Future<void> _showExitConfirmationDialog() async {
    await LeaveDialog.showAndNavigateHome(context);
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Get.find<GameController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitConfirmationDialog();
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Obx(
          () => Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  Color(0xFF273F5D),
                  Color(0xFF020D21),
                  Color(0xFF031229),
                ],
              ),
            ),
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    top: 5.sp,
                  ),
                  child: HomeHeader(
                    title: Row(
                      children: [
                        Text(
                          'Game : '.tr,
                          style: AppTextStyles.heading2().copyWith(
                            fontSize: 10.sp,
                            color: MyColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Text(
                          gameController.gameDetail.value.title ??
                              'Who did it?'.tr,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'Timer '.tr,
                          style: AppTextStyles.heading1().copyWith(
                            fontSize: 10.sp,
                            color: MyColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                        Obx(
                          () => Text(
                            timerController.timerText.value,
                            style: AppTextStyles.heading1().copyWith(
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    actionButtons: GestureDetector(
                      onTap: () => _showExitConfirmationDialog(),
                      child: SvgPicture.asset(MyIcons.arrowbackrounded),
                    ),
                  ),
                ),

                // 10px spacing after header
                SizedBox(height: 5.h),
                // Body - Centered
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Left Buttons
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'List of suspects'.tr,
                                  style: AppTextStyles.heading1().copyWith(
                                    fontSize: 6.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Image(
                              image: AssetImage(MyImages.suspects),
                              height: 80.h,
                            ),
                            CustomButton(
                              width: 50.w,
                              height: 40.h,
                              borderRadius: 100.r,
                              text: 'View List'.tr,
                              fontSize: 5.sp,
                              backgroundColor: MyColors.redButtonColor,
                              onPressed: () {
                                Get.toNamed(AppRoutes.suspectsListScreen);
                              },
                              preffix: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: MyColors.brightRedColor,
                                size: 7.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 6.h),
                              child: Container(
                                width: 60.w,
                                height: 1.h,
                                color: MyColors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Evidence'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 6.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8.h),
                            CustomButton(
                              width: 60.w,
                              height: 40.h,
                              borderRadius: 100.r,
                              backgroundColor: MyColors.greenColor,
                              text: 'Show Evidence'.tr,
                              fontSize: 5.sp,
                              onPressed: () {
                                Get.toNamed(AppRoutes.evidenceListScreen);
                              },
                              preffix: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: MyColors.darkGreenColor,
                                size: 7.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 5.w),

                        /// Question Card
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: MyColors.redButtonColor,
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50.h,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.redButtonColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18.r),
                                      topRight: Radius.circular(18.r),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Left: Question of the case
                                      Text(
                                        'Question of the case'.tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(
                                              fontSize: 6.sp,
                                              color: MyColors.white,
                                            ),
                                      ),
                                      Spacer(flex: 1),
                                      // Center: Stepper
                                      QuestionStepper(
                                        currentQuestion:
                                            currentQuestionIndex != null
                                                ? currentQuestionIndex! + 1
                                                : 1,
                                        totalQuestions:
                                            totalQuestions > 0
                                                ? totalQuestions
                                                : 1,
                                        onQuestionTapped: (index) {
                                          _loadQuestion(index);
                                        },
                                      ),
                                      Spacer(flex: 5),

                                      // Right: Correct answers
                                      Text(
                                        'Correct answers '.tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(
                                              fontSize: 6.sp,
                                              color: MyColors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                      ),
                                      Obx(
                                        () => Text(
                                          '${selectedAnswerIndices.where((idx) => currentQuestion?.answers[idx].isCorrect == true).length}',
                                          style: AppTextStyles.heading1()
                                              .copyWith(
                                                fontSize: 7.sp,
                                                color: MyColors.white,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '/${currentQuestion?.answers.where((a) => a.isCorrect == true).length ?? 1}'
                                            .tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(
                                              fontSize: 6.sp,
                                              color: MyColors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                // Hint Button
                                Obx(() {
                                  // Access observable to trigger rebuild
                                  final questions =
                                      questionController.questions;
                                  final isLoading =
                                      questionController.isLoading.value;
                                  final question = currentQuestion;
                                  if (question == null) {
                                    if (isLoading && questions.isEmpty) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: MyColors.redButtonColor,
                                        ),
                                      );
                                    }
                                    // If questions are loaded but current question not found, show error
                                    return Center(
                                      child: Text(
                                        'Question not found'.tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(
                                              fontSize: 6.sp,
                                              color: MyColors.white,
                                            ),
                                      ),
                                    );
                                  }

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (question.hints.isNotEmpty)
                                        _buildHintButton(question),
                                      SizedBox(width: 8.h),
                                      // Question Text
                                      Expanded(
                                        child: Text(
                                          question.question ?? '',
                                          style:
                                              AppTextStyles.captionRegular10medium()
                                                  .copyWith(
                                                    fontSize: 6.sp,
                                                    color: MyColors.white,
                                                  ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                SizedBox(height: 16.h),
                                // Answer Options
                                Obx(() {
                                  // Access observables to trigger rebuild
                                  final questions =
                                      questionController.questions;
                                  final lastAnswer =
                                      answerController.lastAnswer.value;
                                  return _buildAnswerOptions(
                                    questions,
                                    lastAnswer,
                                  );
                                }),
                                const Spacer(),
                                // Footer Buttons
                                _buildFooterButtons(),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Padding(
                  padding: EdgeInsets.only(
                    left: 10.sp,
                    right: 10.sp,
                    bottom: 5.sp,
                  ),
                  child: GameFooter(
                    onGameResultTap: () {
                      Get.toNamed(AppRoutes.scoreboardScreen);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton(QuestionModel question) {
    final hints = question.hints;
    if (hints.isEmpty) return SizedBox.shrink();

    final totalPointsCost =
        hints.isNotEmpty ? (hints.first.pointsCost ?? 0) : 0;

    return GestureDetector(
      onTap: () {
        setState(() {
          hintUsed = true;
        });

        // Show dialog with all hints
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (_) => VideoEvidenceDialog(
                hints: hints,
                onContinue: () {},
                onAllHintsViewed: () {
                  // All hints have been viewed
                },
              ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: MyColors.BlueColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hints.length > 1 ? 'Hint '.tr : 'Hint '.tr,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 6.sp,
                color: MyColors.white,
              ),
            ),

            if (totalPointsCost > 0)
              Text(
                '(-$totalPointsCost ${'Points'.tr})',
                style: AppTextStyles.captionSemiBold10().copyWith(
                  fontSize: 6.sp,
                  color: MyColors.white.withValues(alpha: 0.5),
                ),
              ),
            SizedBox(width: 2.w),
            SvgPicture.asset(MyIcons.bulb, height: 25.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(
    RxList<QuestionModel> questions,
    UserAnswerModel? lastAnswer,
  ) {
    final question = currentQuestion;
    if (question == null || question.answers.isEmpty) {
      return Center(
        child: Text(
          'No answers available'.tr,
          style: AppTextStyles.heading1().copyWith(
            fontSize: 6.sp,
            color: MyColors.white,
          ),
        ),
      );
    }

    final answers = question.answers;
    // Check if the answer belongs to the current question
    final isAnswerSubmitted =
        lastAnswer != null && lastAnswer.questionId == question.id;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(answers.length, (index) {
          final answer = answers[index];
          final isSelected = selectedAnswerIndices.contains(index);
          final answerIsCorrect = answer.isCorrect ?? false;
          final showAsCorrect =
              isAnswerSubmitted && isSelected && answerIsCorrect;
          final showAsWrong =
              isAnswerSubmitted && isSelected && !answerIsCorrect;

          return GestureDetector(
            onTap: () {
              if (!isAnswerSubmitted || lastAnswer.isCorrect == false) {
                if (isSelected) {
                  selectedAnswerIndices.remove(index);
                } else {
                  selectedAnswerIndices.add(index);
                }
                if (isAnswerSubmitted && lastAnswer.isCorrect == false) {
                  // Clear the wrong answer state so they can try again
                  answerController.lastAnswer.value = null;
                }
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              constraints: BoxConstraints(minWidth: 58.w),
              decoration: BoxDecoration(
                color:
                    showAsCorrect
                        ? MyColors.greenColor.withValues(alpha: 0.1)
                        : showAsWrong
                        ? MyColors.redButtonColor.withValues(alpha: 0.1)
                        : isSelected
                        ? MyColors.redButtonColor.withValues(alpha: 0.2)
                        : MyColors.redButtonColor.withValues(alpha: 0.1),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    begin: AlignmentGeometry.topCenter,
                    end: Alignment.bottomCenter,
                    colors:
                        showAsCorrect
                            ? [
                              MyColors.greenColor.withValues(alpha: 0.1),
                              MyColors.greenColor,
                            ]
                            : [
                              MyColors.redButtonColor.withValues(
                                alpha: isSelected ? 0.3 : 0.1,
                              ),
                              MyColors.redButtonColor,
                            ],
                  ),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    answer.answerText ?? '',
                    style: AppTextStyles.heading4().copyWith(
                      fontSize: 6.sp,
                      color:
                          isSelected
                              ? MyColors.white
                              : MyColors.white.withValues(alpha: 0.5),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (showAsCorrect) ...[
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      MyIcons.circle_check_outline,
                      height: 20.h,
                    ),
                  ],
                  if (showAsWrong) ...[
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      MyIcons.close,
                      height: 20.h,
                      colorFilter: ColorFilter.mode(
                        MyColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // GestureDetector(
        //   onTap: () {
        //     // Handle view additional evidence
        //   },
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
        //     decoration: BoxDecoration(
        //       color: MyColors.BlueColor,
        //       borderRadius: BorderRadius.circular(4.r),
        //       boxShadow: [
        //         BoxShadow(
        //           color: Colors.black.withValues(alpha: 0.15),
        //           offset: Offset(0, 1),
        //           blurRadius: 1,
        //         ),
        //       ],
        //     ),
        //     child: Center(
        //       child: Text(
        //         'View additional evidence'.tr,
        //         style: AppTextStyles.heading1().copyWith(
        //           fontSize: 6.sp,
        //           color: MyColors.white.withValues(alpha: 0.5),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        SizedBox(width: 12.w),

        Obx(() {
          // Access observable to trigger rebuild
          final lastAnswer = answerController.lastAnswer.value;
          final isLoading = answerController.isLoading.value;
          final currentQuestion = this.currentQuestion;
          // Check if the answer belongs to the current question
          final isSubmitted =
              lastAnswer != null &&
              currentQuestion != null &&
              lastAnswer.questionId == currentQuestion.id;

          return GestureDetector(
            onTap:
                isLoading
                    ? null
                    : () {
                      if (!isSubmitted) {
                        _submitAnswer();
                      } else if (lastAnswer.isCorrect == true) {
                        // Answer already submitted and correct - move to next question or result
                        if (currentQuestionIndex != null &&
                            currentQuestionIndex! < totalQuestions - 1) {
                          _nextQuestion();
                        } else {
                          // Last question already answered - navigate to result
                          Get.offNamed(AppRoutes.gameResultSummaryScreen);
                        }
                      }
                      // If isSubmitted but WRONG (isCorrect == false), it does nothing when tapping "Wrong answer".
                      // The player must tap a different answer option to clear the wrong state and try again.
                    },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: Offset(0, 1),
                    blurRadius: 1,
                  ),
                ],
                color:
                    isLoading
                        ? MyColors.redButtonColor.withValues(alpha: 0.5)
                        : isSubmitted
                        ? (lastAnswer.isCorrect == true
                            ? MyColors.greenColor
                            : MyColors.redButtonColor)
                        : MyColors.redButtonColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLoading)
                      SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            MyColors.white,
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        !isSubmitted
                            ? 'Send answer'.tr
                            : (lastAnswer.isCorrect == true
                                ? 'Correct'.tr
                                : 'Wrong answer'.tr),
                        style: AppTextStyles.heading1().copyWith(
                          fontSize: 6.sp,
                          color: MyColors.white,
                        ),
                      ),
                      if (isSubmitted) ...[
                        SizedBox(width: 3.w),
                        // Show correct/wrong icon based on answer
                        if (lastAnswer.isCorrect == true)
                          SvgPicture.asset(
                            MyIcons.circle_check_outline,
                            height: 18.h,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          )
                        else
                          SvgPicture.asset(
                            MyIcons.close,
                            height: 18.h,
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
