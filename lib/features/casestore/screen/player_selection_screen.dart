import 'dart:async';
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/features/casestore/controller/player_selection_controller.dart';
import 'package:alqadiya_game/widgets/available_players_section.dart';
import 'package:alqadiya_game/widgets/copy_code_button.dart';
import 'package:alqadiya_game/widgets/game_background.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/start_play_button.dart';
import 'package:alqadiya_game/widgets/team_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';

class PlayerSelectionScreen extends StatefulWidget {
  PlayerSelectionScreen({super.key});
  @override
  State<PlayerSelectionScreen> createState() => _PlayerSelectionScreenState();
}

class _PlayerSelectionScreenState extends State<PlayerSelectionScreen> {
  late PlayerSelectionController controller;
  final gameController = Get.find<GameController>();
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PlayerSelectionController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameController.getSessionPlayers();
      // Start polling every 2 seconds
      _startPolling();
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      gameController.getSessionPlayers();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: GameBackground(
        isPurchased: true,
        imageUrl: "https://picsum.photos/200",
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
                      'Who did it?'.tr,
                      style: AppTextStyles.heading1().copyWith(fontSize: 10.sp),
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      width: 1.w,
                      height: 20.h,
                      color: MyColors.white.withValues(alpha: 0.2),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Create teams'.tr,
                      style: AppTextStyles.heading1().copyWith(
                        fontSize: 7.sp,
                        color: MyColors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
                actionButtons: GestureDetector(
                  onTap: () => Get.offAllNamed(AppRoutes.homescreen),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),
            // Body - Player Selection with Drag and Drop
            SizedBox(height: 0.07.sh),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Available Players Section
                    Expanded(
                      flex: 1,
                      child: AvailablePlayersSection(controller: controller),
                    ),

                    // Teams Containers
                    Expanded(
                      flex: 2,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:
                              controller.teams
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                        ),
                                        child: TeamContainer(
                                          team: entry.value,
                                          controller: controller,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),

                    SizedBox(width: 2.w),

                    // Next Button
                    Obx(
                      () => Opacity(
                        opacity: controller.isLoading.value ? 0.6 : 1.0,
                        child: StartPlayButton(
                          buttonWidth: 50.w,
                          buttonText: 'Next'.tr,
                          onTap:
                              controller.isLoading.value
                                  ? () {}
                                  : () => controller.proceedWithTeams(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 50.h),

            // Code sharing section
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Share this code with friends to join.',
                    style: AppTextStyles.captionRegular12().copyWith(
                      color: MyColors.white,
                      height: 1.5,
                      fontSize: 6.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10.w),
                  CopyCodeButton(
                    code: gameController.gameSession.value?.sessionCode ?? '',
                  ),
                ],
              ),
            ),

            SizedBox(height: 0.06.sh),
          ],
        ),
      ),
    );
  }
}
