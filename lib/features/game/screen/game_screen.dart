import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/constants/my_images.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
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
  int currentQuestion = 2;
  int totalQuestions = 24;
  int correctAnswers = 01;
  int totalCorrectAnswers = 2;
  int? selectedAnswerIndex = 2; // "At the party" is initially selected

  @override
  void initState() {
    super.initState();
    // Initialize timer controller (permanent to persist across navigation)
    timerController = Get.put(GameTimerController(), permanent: true);
    // Start timer when entering game screen
    timerController.startTimer();
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
          imageUrl: gameController.gameDetail.value?.coverImageUrl ?? 
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
                        gameController.gameDetail.value?.title ?? 'Who did it?'.tr,
                        style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
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
                          text: 'View List',
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
                                    currentQuestion: 2,
                                    totalQuestions: 24,
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
                                  Text(
                                    '$correctAnswers'.tr,
                                    style: AppTextStyles.heading1().copyWith(
                                      fontSize: 7.sp,
                                      color: MyColors.white,
                                    ),
                                  ),
                                  Text(
                                    '/$totalCorrectAnswers'.tr,
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
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildHintButton(),
                                SizedBox(width: 8.h),
                                // Question Text
                                Text(
                                  'Where were the suspects when the crime occurred?'
                                      .tr,
                                  style: AppTextStyles.captionRegular10medium()
                                      .copyWith(
                                        fontSize: 6.sp,
                                        color: MyColors.white,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Answer Options
                            _buildAnswerOptions(),
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
                padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
                child: GameFooter(onGameResultTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton() {
    return GestureDetector(
      onTap: () {
        // Handle hint button tap
        showDialog(
          context: context,
          barrierDismissible: true,
          builder:
              (_) => VideoEvidenceDialog(
                videoUrl:
                    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                title: "Watch the confession",
                onContinue: () {},
                showHintText: true, // or false
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
            Text(
              '(-02 Points)'.tr,
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

  Widget _buildAnswerOptions() {
    final answers = [
      'خارج',
      'Outside',
      'At the party',
      'In the house',
      'In the basement',
    ];
    final correctAnswerIndex = 2; // "At the party" is correct

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(answers.length, (index) {
          final isSelected = selectedAnswerIndex == index;
          final isCorrect = index == correctAnswerIndex;
          final showAsCorrect = isSelected && isCorrect;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAnswerIndex = index;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              constraints: BoxConstraints(minWidth: 58.w),
              decoration: BoxDecoration(
                color:
                    showAsCorrect
                        ? MyColors.greenColor.withValues(alpha: 0.1)
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
                              MyColors.redButtonColor.withValues(alpha: 0.1),
                              MyColors.redButtonColor,
                            ],
                  ),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(80.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    answers[index],
                    style: AppTextStyles.heading4().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  if (showAsCorrect) ...[
                    SizedBox(width: 4.w),
                    SvgPicture.asset(
                      MyIcons.circle_check_outline,
                      height: 20.h,
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
        GestureDetector(
          onTap: () {
            // Handle send answer
            Get.toNamed(AppRoutes.scoreboardScreen);
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
              color: 2 != 2 ? MyColors.greenColor : MyColors.redButtonColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Row(
                children: [
                  Text(
                    1 == 1
                        ? 'Send answer'.tr
                        : 2 == 2
                        ? 'Correct'.tr
                        : 'Wrong answer'.tr,
                    style: AppTextStyles.heading1().copyWith(
                      fontSize: 6.sp,
                      color: MyColors.white,
                    ),
                  ),
                  if (1 != 1) ...[
                    SizedBox(width: 3.w),
                    SvgPicture.asset(
                      2 == 2 ? MyIcons.circle_check_outline : MyIcons.close,
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
        ),
      ],
    );
  }
}
