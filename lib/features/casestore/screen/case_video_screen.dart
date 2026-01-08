import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/widgets/custom_icon_text_button.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/widgets/leave_dialog.dart';
import 'package:alqadiya_game/features/game/controller/cutscene_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/casestore/controller/case_video_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:video_player/video_player.dart';

class CaseVideoScreen extends StatefulWidget {
  CaseVideoScreen({super.key});

  @override
  State<CaseVideoScreen> createState() => _CaseVideoScreenState();
}

class _CaseVideoScreenState extends State<CaseVideoScreen>
    with WidgetsBindingObserver {
  final cutsceneController = Get.find<CutsceneController>();
  final gameController = Get.find<GameController>();
  late final CaseVideoController videoController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    videoController = Get.put(CaseVideoController());

    // Fetch cutscenes and play the first one
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCutscenes();
    });
  }

  Future<void> _loadCutscenes() async {
    final gameId =
        gameController.gameDetail.value.id ??
        gameController.gameSession.value?.gameId;

    if (gameId != null && gameId.isNotEmpty) {
      await cutsceneController.getCutscenesByGame(gameId: gameId);

      // Play the first cutscene (intro)
      if (cutsceneController.cutscenes.isNotEmpty) {
        _playCutscene(cutsceneController.cutscenes.first);
      }
    } else {
      // Fallback to hardcoded video if no game ID
      await videoController.initializePlayer(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      );
    }
  }

  void _playCutscene(dynamic cutscene) {
    final mediaUrl = cutscene?.mediaUrl as String?;
    if (mediaUrl != null && mediaUrl.isNotEmpty) {
      videoController.initializePlayer(mediaUrl);
    }
  }

  void _playNextCutscene() {
    if (videoController.currentCutsceneIndex.value <
        cutsceneController.cutscenes.length - 1) {
      videoController.playNextCutscene();
      _playCutscene(
        cutsceneController.cutscenes[videoController
            .currentCutsceneIndex
            .value],
      );
    } else {
      // No more cutscenes, navigate to game screen
      Get.toNamed(AppRoutes.gameScreen);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Get.delete<CaseVideoController>();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      videoController.checkAndShowControls();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await LeaveDialog.showAndNavigateHome(context);
      },
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: Stack(
          children: [
            // Video Player Section
            Obx(() {
              if (cutsceneController.isLoading.value ||
                  videoController.isLoading.value) {
                return Center(
                  child: CupertinoActivityIndicator(
                    color: Colors.white,
                    radius: 20.r,
                  ),
                );
              }

              if (videoController.isInitialized.value &&
                  videoController.player != null) {
                return GestureDetector(
                  onTap: videoController.toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VideoPlayer(videoController.player!.controller),
                      // Play/Pause Button Overlay
                      Obx(() {
                        if (videoController.showControls.value) {
                          return GestureDetector(
                            onTap: videoController.togglePlayPause,
                            child: Container(
                              height: 40.sp,
                              width: 40.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color: MyColors.black.withValues(alpha: 0.3),
                              ),
                              child: Obx(
                                () => Icon(
                                  videoController.isPlaying.value
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 28.sp,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                );
              }

              return Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 20.r,
                ),
              );
            }),

            // Top Bar
            Padding(
              padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 5.sp),
              child: HomeHeader(
                onProfileTap: () async {
                  videoController.pauseVideo();
                  await Get.toNamed(AppRoutes.settingsScreen);
                  // When returning from settings, show controls if video is paused
                  videoController.checkAndShowControls();
                },
                showDivider: false,
                onChromTap: () {},
                actionButtons: GestureDetector(
                  onTap:
                      () async =>
                          await LeaveDialog.showAndNavigateHome(context),
                  child: SvgPicture.asset(MyIcons.arrowbackrounded),
                ),
              ),
            ),

            // Bottom Controls
            Positioned(
              left: 10.sp,
              right: 10.sp,
              bottom: 10.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Replay Button
                  Obx(
                    () => CustomIconTextButton(
                      onTap:
                          videoController.isReplaying.value
                              ? () {} // Empty function when replaying
                              : () => videoController.replayVideo(),
                      buttonText: 'Replay'.tr,
                      icon: MyIcons.refresh,
                      isIconButton: true,
                    ),
                  ),

                  // Skip Button
                  Obx(() {
                    final currentCutsceneIndex =
                        videoController.currentCutsceneIndex.value;
                    final currentCutscene =
                        currentCutsceneIndex <
                                cutsceneController.cutscenes.length
                            ? cutsceneController.cutscenes[currentCutsceneIndex]
                            : null;
                    final canSkip = currentCutscene?.isSkippable ?? true;

                    if (!canSkip) {
                      return const SizedBox.shrink();
                    }

                    return CustomIconTextButton(
                      onTap: () {
                        if (currentCutsceneIndex <
                            cutsceneController.cutscenes.length - 1) {
                          _playNextCutscene();
                        } else {
                          Get.toNamed(AppRoutes.gameScreen);
                        }
                      },
                      buttonText: 'Skip'.tr,
                      icon: MyIcons.arrow_right,
                      isIconButton: true,
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
