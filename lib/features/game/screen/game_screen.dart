import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/question_controller.dart';
import 'package:alqadiya_game/features/game/controller/user_answer_controller.dart';
import 'package:alqadiya_game/features/game/model/question_model.dart';
import 'package:alqadiya_game/features/game/model/user_answer_model.dart';
import 'package:alqadiya_game/features/game/widget/question_stepper.dart';
import 'package:alqadiya_game/features/game/widget/video_hint_dialog.dart';
import 'package:alqadiya_game/widgets/custom_button.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/gradient_box_border.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/casestore/controller/add_case_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AddCaseController controller = Get.put(AddCaseController());
  late final GameTimerController timerController;
  final QuestionController questionController = Get.find<QuestionController>();
  final UserAnswerController answerController =
      Get.find<UserAnswerController>();

  int currentQuestionOrder = 1;
  var selectedAnswerIndex = Rx<int?>(null);
  bool hintUsed = false;
  DateTime? questionStartTime;
  UserAnswerModel? lastSubmittedAnswer;

  @override
  void initState() {
    super.initState();
    // Initialize timer controller (permanent to persist across navigation)
    timerController = Get.put(GameTimerController(), permanent: true);

    // Fetch questions for the game
    final gameController = Get.find<GameController>();
    final gameId =
        gameController.gameDetail.value?.id ??
        gameController.gameSession.value?.gameId;

    if (gameId != null) {
      // Fetch game details if not already loaded
      if (gameController.gameDetail.value?.id == null) {
        gameController.getGameDetail(gameId: gameId).then((_) {
          // Start timer with duration from game details after loading
          _startTimerFromGameDetails(gameController);
        });
      } else {
        // Game details already loaded, start timer immediately
        _startTimerFromGameDetails(gameController);
      }

      // Fetch questions
      questionController.getQuestionsByGame(gameId: gameId, language: 'en');
    } else {
      // Fallback: start timer with default values if game details not available
      timerController.startTimer();
    }

    // Initialize question start time
    questionStartTime = DateTime.now();
  }

  void _startTimerFromGameDetails(GameController gameController) {
    // Get timer duration from game details
    final estimatedDuration = gameController.gameDetail.value.estimatedDuration;
    
    if (estimatedDuration != null && estimatedDuration > 0) {
      // estimatedDuration is in minutes, convert to minutes:seconds
      final minutes = estimatedDuration;
      final seconds = 0; // Start with 0 seconds
      timerController.startTimer(
        initialMinutes: minutes,
        initialSeconds: seconds,
      );
    } else {
      // Fallback to default if duration not available
      timerController.startTimer();
    }
  }

  int get totalQuestions => questionController.questions.length;
  int get correctAnswers =>
      questionController.questions
          .where((q) => answerController.lastAnswer.value?.isCorrect == true)
          .length;

  QuestionModel? get currentQuestion {
    return questionController.questions.firstWhereOrNull(
      (q) => q.order == currentQuestionOrder,
    );
  }

  void _loadQuestion(int order) {
    setState(() {
      currentQuestionOrder = order;
      selectedAnswerIndex.value = null;
      hintUsed = false;
      questionStartTime = DateTime.now();
      lastSubmittedAnswer = null;
    });
  }

  void _submitAnswer() async {
    final question = currentQuestion;
    final gameController = Get.find<GameController>();
    final sessionId = gameController.gameSession.value?.id;

    if (question == null ||
        sessionId == null ||
        selectedAnswerIndex.value == null) {
      CustomSnackbar.showError('Please select an answer'.tr);
      return;
    }

    final selectedAnswer = question.answers?[selectedAnswerIndex.value!];
    if (selectedAnswer == null || selectedAnswer.id == null) {
      CustomSnackbar.showError('Invalid answer selected'.tr);
      return;
    }

    final timeSpent =
        questionStartTime != null
            ? DateTime.now().difference(questionStartTime!).inSeconds
            : 0;

    final success = await answerController.submitAnswer(
      sessionId: sessionId,
      questionId: question.id ?? '',
      selectedOptionId: selectedAnswer.id!,
      timeSpentSeconds: timeSpent,
      hintUsed: hintUsed,
    );

    if (success) {
      // Update local state - the Obx will rebuild automatically via answerController.lastAnswer
      lastSubmittedAnswer = answerController.lastAnswer.value;
    } else {
      CustomSnackbar.showError('Failed to submit answer. Please try again.'.tr);
    }
  }

  void _nextQuestion() {
    if (currentQuestionOrder < totalQuestions) {
      _loadQuestion(currentQuestionOrder + 1);
    }
  }

  @override
  void dispose() {
    // Don't dispose the controller here as it needs to persist across screens
    // It will be disposed when the game ends or user navigates away from game flow
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameController = Get.find<GameController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(
        () => GameBackground(
          isPurchased: true,
          imageUrl:
              gameController.gameDetail.value?.coverImageUrl ??
              gameController.gameDetail.value?.coverImage ??
              "https://picsum.photos/200",
          body: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
                child: HomeHeader(
                  onChromTap: () {},
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
                        gameController.gameDetail.value?.title ??
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
                    onTap: () => Get.back(),
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
                            border: Border.all(color: MyColors.redButtonColor),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Left: Question of the case
                                    Text(
                                      'Question of the case'.tr,
                                      style: AppTextStyles.heading1().copyWith(
                                        fontSize: 6.sp,
                                        color: MyColors.white,
                                      ),
                                    ),
                                    Spacer(flex: 1),
                                    // Center: Stepper
                                    QuestionStepper(
                                      currentQuestion: currentQuestionOrder,
                                      totalQuestions:
                                          totalQuestions > 0
                                              ? totalQuestions
                                              : 1,
                                    ),
                                    Spacer(flex: 5),

                                    // Right: Correct answers
                                    Text(
                                      'Correct answers '.tr,
                                      style: AppTextStyles.heading1().copyWith(
                                        fontSize: 6.sp,
                                        color: MyColors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        '${answerController.lastAnswer.value?.isCorrect == true ? correctAnswers : correctAnswers}'
                                            .tr,
                                        style: AppTextStyles.heading1()
                                            .copyWith(
                                              fontSize: 7.sp,
                                              color: MyColors.white,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '/$totalQuestions'.tr,
                                      style: AppTextStyles.heading1().copyWith(
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
                                final questions = questionController.questions;
                                final question = questions.firstWhereOrNull(
                                  (q) => q.order == currentQuestionOrder,
                                );
                                if (question == null) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: MyColors.redButtonColor,
                                    ),
                                  );
                                }

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (question.hints != null &&
                                        question.hints!.isNotEmpty)
                                      _buildHintButton(question),
                                    SizedBox(width: 8.h),
                                    // Question Text
                                    Expanded(
                                      child: Text(
                                        question.questionEn ??
                                            question.questionAr ??
                                            '',
                                        style:
                                            AppTextStyles.captionRegular10medium()
                                                .copyWith(
                                                  fontSize: 6.sp,
                                                  color: MyColors.white,
                                                ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              SizedBox(height: 16.h),
                              // Answer Options
                              Obx(() {
                                // Access observables to trigger rebuild
                                final questions = questionController.questions;
                                final lastAnswer =
                                    answerController.lastAnswer.value;
                                final selectedIndex = selectedAnswerIndex.value;
                                return _buildAnswerOptions(
                                  questions,
                                  lastAnswer,
                                  selectedIndex,
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
                child: GameFooter(onGameResultTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton(QuestionModel question) {
    final hint = question.hints?.firstOrNull;
    final pointsCost = hint?.pointsCost ?? 0;

    return GestureDetector(
      onTap: () {
        if (hint == null) return;

        setState(() {
          hintUsed = true;
        });

        // Handle hint button tap
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (_) => VideoEvidenceDialog(
                videoUrl: hint.mediaUrl ?? '',
                title: hint.hintName ?? 'Hint'.tr,
                onContinue: () {},
                showHintText: hint.hintDescription != null,
              ),
        );
      },
      child: Container(
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
              'Hint '.tr,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 6.sp,
                color: MyColors.white,
              ),
            ),
            if (pointsCost > 0)
              Text(
                '(-$pointsCost ${'Points'.tr})',
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
    int? selectedIndex,
  ) {
    final question = questions.firstWhereOrNull(
      (q) => q.order == currentQuestionOrder,
    );
    if (question == null ||
        question.answers == null ||
        question.answers!.isEmpty) {
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

    final answers = question.answers!;
    final isAnswerSubmitted = lastAnswer != null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(answers.length, (index) {
          final answer = answers[index];
          final isSelected = selectedIndex == index;
          final answerIsCorrect = answer.isCorrect ?? false;
          final showAsCorrect =
              isAnswerSubmitted && isSelected && answerIsCorrect;
          final showAsWrong =
              isAnswerSubmitted && isSelected && !answerIsCorrect;

          return GestureDetector(
            onTap: () {
              if (!isAnswerSubmitted) {
                selectedAnswerIndex.value = index;
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
                    answer.answerText ?? answer.answerTextAr ?? '',
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
        GestureDetector(
          onTap: () {
            // Handle view additional evidence
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: MyColors.BlueColor,
              borderRadius: BorderRadius.circular(4.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: Offset(0, 1),
                  blurRadius: 1,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'View additional evidence'.tr,
                style: AppTextStyles.heading1().copyWith(
                  fontSize: 6.sp,
                  color: MyColors.white.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Obx(() {
          // Access observable to trigger rebuild
          final lastAnswer = answerController.lastAnswer.value;
          final isSubmitted = lastAnswer != null;

          return GestureDetector(
            onTap: () {
              if (!isSubmitted) {
                _submitAnswer();
              } else {
                if (currentQuestionOrder < totalQuestions) {
                  _nextQuestion();
                } else {
                  // Game completed, navigate to result
                  Get.toNamed(AppRoutes.scoreboardScreen);
                }
              }
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
                    isSubmitted
                        ? ((lastAnswer?.isCorrect ?? false)
                            ? MyColors.greenColor
                            : MyColors.redButtonColor)
                        : MyColors.redButtonColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      !isSubmitted
                          ? 'Send answer'.tr
                          : (lastAnswer?.isCorrect ?? false)
                          ? 'Correct'.tr
                          : 'Wrong answer'.tr,
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 6.sp,
                        color: MyColors.white,
                      ),
                    ),
                    if (isSubmitted) ...[
                      SizedBox(width: 3.w),
                      SvgPicture.asset(
                        (lastAnswer?.isCorrect ?? false)
                            ? MyIcons.circle_check_outline
                            : MyIcons.close,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
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
