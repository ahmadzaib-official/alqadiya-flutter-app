// Video Player Screen
import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/cached_video_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late CachedVideoPlayerController _videoController;
  final String _controllerTag =
      'cached_video_player_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    // Create controller with unique tag for this widget instance
    _videoController = Get.put(
      CachedVideoPlayerController(),
      tag: _controllerTag,
    );
    // Initialize video after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _videoController.initializeVideo(widget.videoUrl);
    });
  }

  @override
  void dispose() {
    // Remove controller when widget is disposed
    if (Get.isRegistered<CachedVideoPlayerController>(tag: _controllerTag)) {
      Get.delete<CachedVideoPlayerController>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Obx(
        () => Stack(
          children: [
            // Video player content
            if (_videoController.isLoading.value)
              const Center(child: CircularProgressIndicator.adaptive())
            else if (_videoController.hasError)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: MyColors.white,
                      size: 48.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      _videoController.errorMessage.value ??
                          'Failed to load video',
                      style: TextStyle(color: MyColors.white, fontSize: 14.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () => _videoController.retry(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.redButtonColor,
                      ),
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: MyColors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (_videoController.isInitialized.value &&
                _videoController.player != null)
              GestureDetector(
                onTap: () => _videoController.toggleControls(),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController.player!.controller),
                    Obx(
                      () =>
                          _videoController.showControls.value
                              ? GestureDetector(
                                onTap: () => _videoController.togglePlayPause(),
                                child: Container(
                                  height: 40.sp,
                                  width: 40.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.r),
                                    color: MyColors.black.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                  child: Icon(
                                    _videoController.isPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                ),
                              )
                              : SizedBox.shrink(),
                    ),
                  ],
                ),
              )
            else
              const Center(child: CircularProgressIndicator.adaptive()),

            // Back button
            Positioned(
              top: 40.h,
              left: 20.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SvgPicture.asset(
                  MyIcons.arrowbackrounded,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
