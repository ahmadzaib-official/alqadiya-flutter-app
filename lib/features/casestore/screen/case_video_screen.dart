import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/widgets/custom_icon_text_button.dart';
import 'package:alqadiya_game/widgets/home_header.dart';
import 'package:alqadiya_game/features/game/controller/cutscene_controller.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

class CaseVideoScreen extends StatefulWidget {
  CaseVideoScreen({super.key});

  @override
  State<CaseVideoScreen> createState() => _CaseVideoScreenState();
}

class _CaseVideoScreenState extends State<CaseVideoScreen>
    with WidgetsBindingObserver {
  CachedVideoPlayerPlus? _player;
  bool _showControls = false;
  Timer? _hideControlsTimer;
  final cutsceneController = Get.find<CutsceneController>();
  final gameController = Get.find<GameController>();
  int _currentCutsceneIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Fetch cutscenes and play the first one
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCutscenes();
    });
  }

  Future<void> _loadCutscenes() async {
    final gameId =
        gameController.gameDetail.value?.id ??
        gameController.gameSession.value?.gameId;

    if (gameId != null && gameId.isNotEmpty) {
      await cutsceneController.getCutscenesByGame(gameId: gameId);

      // Play the first cutscene (intro)
      if (cutsceneController.cutscenes.isNotEmpty) {
        _playCutscene(cutsceneController.cutscenes.first);
      }
    } else {
      // Fallback to hardcoded video if no game ID
      _initializePlayer(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      );
    }
  }

  void _playCutscene(dynamic cutscene) {
    final mediaUrl = cutscene?.mediaUrl as String?;
    if (mediaUrl != null && mediaUrl.isNotEmpty) {
      _initializePlayer(mediaUrl);
    }
  }

  void _initializePlayer(String videoUrl) {
    _player?.dispose();
    _player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(videoUrl),
      invalidateCacheIfOlderThan: const Duration(minutes: 120),
    );

    _player!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _player!.controller.play();
      }
    });
  }

  void _playNextCutscene() {
    if (_currentCutsceneIndex < cutsceneController.cutscenes.length - 1) {
      _currentCutsceneIndex++;
      _playCutscene(cutsceneController.cutscenes[_currentCutsceneIndex]);
    } else {
      // No more cutscenes, navigate to game screen
      Get.offAndToNamed(AppRoutes.gameScreen);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _hideControlsTimer?.cancel();
    _player?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkAndShowControls();
    }
  }

  void _checkAndShowControls() {
    if (mounted &&
        _player != null &&
        _player!.isInitialized &&
        !_player!.controller.value.isPlaying) {
      setState(() {
        _showControls = true;
      });
      _startHideTimer();
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _togglePlayPause() {
    if (_player == null || !_player!.isInitialized) return;
    setState(() {
      _player!.controller.value.isPlaying
          ? _player!.controller.pause()
          : _player!.controller.play();
    });
    _startHideTimer();
  }

  void _replayVideo() {
    if (_player == null || !_player!.isInitialized) return;
    _player!.controller.seekTo(Duration.zero);
    if (!_player!.controller.value.isPlaying) {
      _player!.controller.play();
    }
    setState(() {
      _showControls = true;
    });
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Stack(
        children: [
          Obx(() {
            if (cutsceneController.isLoading.value) {
              return Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 20.r,
                ),
              );
            }

            if (_player != null && _player!.isInitialized) {
              return GestureDetector(
                onTap: _toggleControls,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_player!.controller),
                    if (_showControls)
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Container(
                          height: 40.sp,
                          width: 40.sp,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            color: MyColors.black.withValues(alpha: 0.3),
                          ),
                          child: Icon(
                            _player!.controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 28.sp,
                          ),
                        ),
                      ),
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
                if (_player != null && _player!.isInitialized) {
                  _player!.controller.pause();
                }
                await Get.toNamed(AppRoutes.settingsScreen);
                // When returning from settings, show controls if video is paused
                if (mounted && _player != null && _player!.isInitialized) {
                  _checkAndShowControls();
                }
              },
              showDivider: false,
              onChromTap: () {},
              actionButtons: GestureDetector(
                onTap: () => Get.back(),
                child: SvgPicture.asset(MyIcons.arrowbackrounded),
              ),
            ),
          ),
          Positioned(
            left: 10.sp,
            right: 10.sp,
            bottom: 10.sp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconTextButton(
                  onTap: _replayVideo,
                  buttonText: 'Replay'.tr,
                  icon: MyIcons.refresh,
                  isIconButton: true,
                ),
                Obx(() {
                  final currentCutscene =
                      _currentCutsceneIndex <
                              cutsceneController.cutscenes.length
                          ? cutsceneController.cutscenes[_currentCutsceneIndex]
                          : null;
                  final canSkip = currentCutscene?.isSkippable ?? true;

                  if (!canSkip) {
                    return SizedBox.shrink();
                  }
                  return CustomIconTextButton(
                    onTap: () {
                      if (_currentCutsceneIndex <
                          cutsceneController.cutscenes.length - 1) {
                        _playNextCutscene();
                      } else {
                        Get.offAndToNamed(AppRoutes.gameScreen);
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
    );
  }
}
