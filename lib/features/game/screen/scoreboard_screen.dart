import 'dart:async';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/features/game/controller/scoreboard_provider.dart';
import 'package:alqadiya_game/features/game/controller/game_timer_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/widget/team_progress_indicator.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/game_footer.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({super.key});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  Timer? _pollingTimer;
  final gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    final scoreboardController = Get.find<ScoreboardController>();
    final sessionId = gameController.gameSession.value?.id;

    if (sessionId != null) {
      // Initial fetch
      scoreboardController.getScoreboard(sessionId: sessionId);

      // Start polling every 5 seconds
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        scoreboardController.refreshScoreboard(sessionId: sessionId);
      });
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the existing timer controller (should already be initialized from game_screen)
    // If not found, create it (fallback scenario)
    final timerController =
        Get.isRegistered<GameTimerController>()
              ? Get.find<GameTimerController>()
              : Get.put(GameTimerController(), permanent: true)
          ..startTimer();

    // Initialize scoreboard controller
    final scoreboardController = Get.find<ScoreboardController>();

    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        imageUrl: "https://picsum.photos/200",
        body: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
              child: HomeHeader(
                onChromTap: () {},
                title: Row(
                  children: [
                    Text(
                      'Scoreboard'.tr,
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

            SizedBox(height: 5.h),

            // Main Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  children: [
                    // Teams Row or Solo Player
                    Obx(() {
                      final isSoloMode =
                          gameController.gameSession.value?.mode == 'solo';

                      if (isSoloMode) {
                        // Solo mode UI
                        final soloPlayer = scoreboardController.soloPlayer;
                        if (soloPlayer == null) {
                          return Center(
                            child: Text(
                              'Loading scoreboard...'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 8.sp,
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: Row(
                            children: [
                              // Solo Player Card
                              Expanded(
                                child: _buildSoloPlayerCard(
                                  context,
                                  soloPlayer,
                                ),
                              ),
                              SizedBox(width: 10.w),

                              // Timer and Continue Button
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 6.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            80.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Remaining time'.tr,
                                              style: AppTextStyles.heading2()
                                                  .copyWith(
                                                    fontSize: 6.sp,
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                            ),
                                            Obx(
                                              () => Text(
                                                ' ${timerController.timerText.value}',
                                                style: AppTextStyles.heading1()
                                                    .copyWith(
                                                      fontSize: 8.sp,
                                                      color: MyColors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),

                                      GestureDetector(
                                        onTap: () {
                                          // Continue playing action
                                          Get.toNamed(AppRoutes.gameScreen);
                                        },
                                        child: Container(
                                          width: 70.w,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: MyColors.greenColor,
                                            borderRadius: BorderRadius.circular(
                                              100.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Spacer(flex: 6),
                                              Text(
                                                'Continue playing'.tr,
                                                style: AppTextStyles.heading2()
                                                    .copyWith(
                                                      fontSize: 6.sp,
                                                      color: MyColors.white,
                                                    ),
                                              ),
                                              Spacer(flex: 1),
                                              SvgPicture.asset(
                                                MyIcons.arrow_right,
                                                colorFilter: ColorFilter.mode(
                                                  MyColors.darkGreenColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              Spacer(flex: 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Team mode UI (existing)
                        final teams = scoreboardController.teams;
                        if (teams.isEmpty) {
                          return Center(
                            child: Text(
                              'Loading scoreboard...'.tr,
                              style: AppTextStyles.heading1().copyWith(
                                fontSize: 8.sp,
                                color: MyColors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          );
                        }

                        return Expanded(
                          child: Row(
                            children: [
                              // Team 1
                              if (teams.length > 0)
                                Expanded(
                                  child: _buildTeamCard(context, teams[0]),
                                ),
                              if (teams.length > 0) SizedBox(width: 10.w),
                              // Team 2
                              if (teams.length > 1)
                                Expanded(
                                  child: _buildTeamCard(context, teams[1]),
                                ),
                              if (teams.length <= 1)
                                Expanded(child: SizedBox()),
                              if (teams.length > 1) SizedBox(width: 10.w),

                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8.h,
                                    horizontal: 6.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MyColors.black.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyColors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            80.r,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Remaining time'.tr,
                                              style: AppTextStyles.heading2()
                                                  .copyWith(
                                                    fontSize: 6.sp,
                                                    color: MyColors.white
                                                        .withValues(alpha: 0.5),
                                                  ),
                                            ),
                                            Obx(
                                              () => Text(
                                                ' ${timerController.timerText.value}',
                                                style: AppTextStyles.heading1()
                                                    .copyWith(
                                                      fontSize: 8.sp,
                                                      color: MyColors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20.h),

                                      GestureDetector(
                                        onTap: () {
                                          // Continue playing action
                                          Get.toNamed(AppRoutes.gameScreen);
                                        },
                                        child: Container(
                                          width: 70.w,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: MyColors.greenColor,
                                            borderRadius: BorderRadius.circular(
                                              100.r,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Spacer(flex: 6),
                                              Text(
                                                'Continue playing'.tr,
                                                style: AppTextStyles.heading2()
                                                    .copyWith(
                                                      fontSize: 6.sp,
                                                      color: MyColors.white,
                                                    ),
                                              ),
                                              Spacer(flex: 1),
                                              SvgPicture.asset(
                                                MyIcons.arrow_right,
                                                colorFilter: ColorFilter.mode(
                                                  MyColors.darkGreenColor,
                                                  BlendMode.srcIn,
                                                ),
                                              ),
                                              Spacer(flex: 1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 5.sp),
              child: GameFooter(
                isResultCompleted: true,

                onGameResultTap: () {
                  Get.toNamed(AppRoutes.gameResultSummaryScreen);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, Map<String, dynamic> team) {
    final players = team['players'] as List<Map<String, dynamic>>;
    final progressStart = team['progressStart'] as int;
    final progressEnd = team['progressEnd'] as int;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Team Name
          Text(
            team['name'] as String,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 8.sp,
              color: MyColors.white,
            ),
          ),

          SizedBox(height: 10.h),

          // Players Row - Overlapping avatars
          Expanded(
            child: Center(
              child: SizedBox(
                width: players.length * 22.w + 5.w,
                child: Stack(
                  children:
                      players.asMap().entries.map((entry) {
                        final index = entry.key;
                        final player = entry.value;
                        final isLastPlayer = index == players.length - 1;
                        // Overlap by 50% of avatar width
                        final overlapOffset = index * 22.w;

                        return Positioned(
                          left: overlapOffset,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 25.w,
                                    height: 25.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.r),
                                      child:
                                          (player['avatar'] as String)
                                                  .isNotEmpty
                                              ? CachedNetworkImage(
                                                imageUrl:
                                                    player['avatar'] as String,
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) => Container(
                                                      color:
                                                          MyColors
                                                              .darkBlueColor,
                                                      child: Center(
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                Color
                                                              >(
                                                                MyColors
                                                                    .greenColor,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      color:
                                                          MyColors
                                                              .darkBlueColor,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 25.sp,
                                                        color: MyColors.white
                                                            .withValues(
                                                              alpha: 0.5,
                                                            ),
                                                      ),
                                                    ),
                                              )
                                              : Container(
                                                color: MyColors.darkBlueColor,
                                                child: Icon(
                                                  Icons.person,
                                                  size: 25.sp,
                                                  color: MyColors.white
                                                      .withValues(alpha: 0.5),
                                                ),
                                              ),
                                    ),
                                  ),
                                  // Green checkmark overlay - only on rightmost member
                                  if (isLastPlayer)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 10.w,
                                        height: 10.w,
                                        decoration: BoxDecoration(
                                          color: MyColors.greenColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          size: 8.sp,
                                          color: MyColors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              // Player name
                              Text(
                                player['name'] as String,
                                style: AppTextStyles.bodyTextMedium16()
                                    .copyWith(
                                      fontSize: 5.sp,
                                      color: MyColors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),

          // Progress Indicator
          TeamProgressIndicator(
            currentQuestion: progressStart - progressEnd,
            totalQuestions: progressStart,
          ),

          SizedBox(height: 10.h),

          // Team Score
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: MyColors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(80.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${team['score'] ?? 0}',
                  style: AppTextStyles.heading1().copyWith(
                    fontSize: 8.sp,
                    color: MyColors.white,
                  ),
                ),
                SizedBox(width: 10.h),

                Text(
                  'Team Score'.tr,
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 6.sp,
                    color: MyColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoloPlayerCard(
    BuildContext context,
    Map<String, dynamic> player,
  ) {
    final progressStart = player['progressStart'] as int;
    final progressEnd = player['progressEnd'] as int;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: MyColors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Player Name
          Text(
            player['name'] as String,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 8.sp,
              color: MyColors.white,
            ),
          ),

          SizedBox(height: 10.h),

          // Player Avatar
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  // Avatar
                  Container(
                    width: 30.w,
                    height: 30.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child:
                          (player['avatar'] as String).isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl: player['avatar'] as String,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color: MyColors.darkBlueColor,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                MyColors.greenColor,
                                              ),
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: MyColors.darkBlueColor,
                                      child: Icon(
                                        Icons.person,
                                        size: 50.sp,
                                        color: MyColors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                              )
                              : Container(
                                color: MyColors.darkBlueColor,
                                child: Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: MyColors.white.withValues(alpha: 0.5),
                                ),
                              ),
                    ),
                  ),
                  // // Green checkmark overlay
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   child: Container(
                  //     width: 15.w,
                  //     height: 15.w,
                  //     decoration: BoxDecoration(
                  //       color: MyColors.greenColor,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: Icon(
                  //       Icons.check,
                  //       size: 10.sp,
                  //       color: MyColors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Progress Indicator
          TeamProgressIndicator(
            currentQuestion: progressStart - progressEnd,
            totalQuestions: progressStart,
          ),

          SizedBox(height: 10.h),

          // Player Score
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: MyColors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(80.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${player['score'] ?? 0}',
                  style: AppTextStyles.heading1().copyWith(
                    fontSize: 8.sp,
                    color: MyColors.white,
                  ),
                ),
                SizedBox(width: 10.h),

                Text(
                  'Score'.tr,
                  style: AppTextStyles.heading2().copyWith(
                    fontSize: 6.sp,
                    color: MyColors.white.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
