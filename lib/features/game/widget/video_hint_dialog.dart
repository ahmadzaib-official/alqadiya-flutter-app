import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/video_player_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoEvidenceDialog extends StatefulWidget {
  final String title;
  final String? videoUrl;
  final String? imageUrl;
  final VoidCallback? onContinue;
  final bool showHintText;
  final int hintPoints;

  const VideoEvidenceDialog({
    super.key,
    required this.title,
    this.videoUrl,
    this.imageUrl,
    this.onContinue,
    this.showHintText = false,
    this.hintPoints = 2,
  });

  @override
  State<VideoEvidenceDialog> createState() => _VideoEvidenceDialogState();
}

class _VideoEvidenceDialogState extends State<VideoEvidenceDialog> {
  bool _showText = false;
  late VideoPlayerStateController _videoController;
  final String _controllerTag =
      'video_hint_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    // Create controller with unique tag for this widget instance
    _videoController = Get.put(
      VideoPlayerStateController(),
      tag: _controllerTag,
    );
    // Initialize video after frame is built
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _videoController.initializeVideo(widget.videoUrl);
      });
    }
  }

  @override
  void dispose() {
    // Remove controller when widget is disposed
    if (Get.isRegistered<VideoPlayerStateController>(tag: _controllerTag)) {
      Get.delete<VideoPlayerStateController>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        width: 0.4.sw,
        height: _showText ? 0.4.sh : null,
        constraints: _showText ? null : BoxConstraints(maxHeight: 0.9.sh),
        decoration: BoxDecoration(
          color: MyColors.redButtonColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with title
                _buildHeader(context),
                // Content area (video or image or text)
                _buildContent(),
                // Continue button
                SizedBox(height: 16.h),
                _buildContinueButton(context),
                SizedBox(height: 16.h),
              ],
            ),
            // Close button positioned at top-right
            Positioned(
              top: -10,
              right: -10,
              child: GestureDetector(
                onTap: () {
                  if (_showText) {
                    Navigator.of(context).pop();
                    widget.onContinue?.call();
                  } else {
                    setState(() {
                      _showText = true;
                    });
                  }
                },
                child: SvgPicture.asset(
                  MyIcons.close_brown_rounded,

                  // width: 12.w,
                  // height: 12.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lightbulb icon
          SvgPicture.asset(
            MyIcons.bulb,
            width: 10.w,
            height: 10.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          // Title - centered
          Text(
            widget.title,
            style: AppTextStyles.heading1().copyWith(
              fontSize: 8.sp,
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      width: double.infinity,
      height: _showText ? 20.h : 200.h,
      margin: EdgeInsets.symmetric(horizontal: _showText ? 5.w : 12.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: _buildMediaContent(),
      ),
    );
  }

  Widget _buildMediaContent() {
    // If text should be shown instead of video
    if (_showText) {
      return _buildTextContent();
    }

    // If video URL is provided, show video player with GetX
    if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
      return Obx(() {
        // Loading state
        if (_videoController.isVideoLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 12.h),
                Text(
                  'Loading video...'.tr,
                  style: AppTextStyles.captionRegular10().copyWith(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          );
        }

        // Error state
        if (_videoController.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
                  SizedBox(height: 8.h),
                  Text(
                    _videoController.errorMessage.value ??
                        'Failed to load video'.tr,
                    style: AppTextStyles.captionRegular10().copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  // Retry button
                  GestureDetector(
                    onTap: () => _videoController.retry(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: MyColors.BlueColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'Retry'.tr,
                        style: AppTextStyles.captionRegular10().copyWith(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Video initialized and ready to play
        if (_videoController.isVideoInitialized.value &&
            _videoController.videoController != null) {
          return _buildVideoPlayer(_videoController);
        }

        // Default loading state
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      });
    }

    // Fallback to image if no video
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
        errorWidget:
            (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
                  SizedBox(height: 8.h),
                  Text(
                    'Failed to load image'.tr,
                    style: AppTextStyles.captionRegular10().copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
      );
    }

    // Default placeholder
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 48.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            'No media available'.tr,
            style: AppTextStyles.captionRegular10().copyWith(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerStateController controller) {
    return Obx(
      () => Stack(
        fit: StackFit.expand,
        children: [
          // Video player
          VideoPlayer(controller.videoController!),
          // Play/Pause overlay
          GestureDetector(
            onTap: () => controller.togglePlayback(),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  opacity: controller.isVideoPlaying.value ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isVideoPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Video controls at bottom
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.transparent,
          //           Colors.black.withValues(alpha: 0.7),
          //         ],
          //       ),
          //     ),
          //     child: Row(
          //       children: [
          //         // Play/Pause button
          //         GestureDetector(
          //           onTap: () => provider.togglePlayback(),
          //           child: Icon(
          //             provider.isVideoPlaying ? Icons.pause : Icons.play_arrow,
          //             color: Colors.white,
          //             size: 20.sp,
          //           ),
          //         ),
          //         SizedBox(width: 8.w),
          //         // Progress indicator
          //         Expanded(
          //           child:
          //               provider.videoController!.value.isInitialized
          //                   ? VideoProgressIndicator(
          //                     provider.videoController!,
          //                     allowScrubbing: true,
          //                     colors: const VideoProgressColors(
          //                       playedColor: Colors.white,
          //                       bufferedColor: Colors.grey,
          //                       backgroundColor: Colors.black54,
          //                     ),
          //                   )
          //                   : const SizedBox(),
          //         ),
          //         SizedBox(width: 8.w),
          //         // Duration
          //         if (provider.videoController!.value.isInitialized)
          //           Text(
          //             _formatDuration(provider.videoController!.value.position) +
          //                 ' / ' +
          //                 _formatDuration(
          //                   provider.videoController!.value.duration,
          //                 ),
          //             style: AppTextStyles.captionRegular10().copyWith(
          //               color: Colors.white,
          //               fontSize: 10.sp,
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Center(
      child: Text(
        'Hint used - score will be affected (02- points).',
        style: AppTextStyles.bodyTextMedium16().copyWith(
          fontSize: 6.sp,
          color: MyColors.white.withValues(alpha: 0.5),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          if (_showText) {
            // Second continue press - close dialog
            Navigator.of(context).pop();
            widget.onContinue?.call();
          } else {
            // First continue press - replace video with text
            setState(() {
              _showText = true;
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: 100.w,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: MyColors.BlueColor,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Continue'.tr,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 8.sp,
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }
}
