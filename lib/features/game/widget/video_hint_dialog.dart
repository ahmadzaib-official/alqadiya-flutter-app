import 'package:alqadiya_game/core/constants/my_icons.dart';
import 'package:alqadiya_game/core/style/text_styles.dart';
import 'package:alqadiya_game/core/theme/my_colors.dart';
import 'package:alqadiya_game/features/game/controller/audio_player_provider.dart';
import 'package:alqadiya_game/features/game/controller/video_player_provider.dart';
import 'package:alqadiya_game/features/game/widget/suspect_detail/pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Dialog to display hints with support for video, image, audio, and document types
class VideoEvidenceDialog extends StatefulWidget {
  final String title;
  final String? videoUrl;
  final String? imageUrl;
  final String? audioUrl;
  final String? documentUrl;
  final String? hintType; // 'video', 'image', 'audio', 'document'
  final VoidCallback? onContinue;
  final bool showHintText;
  final int hintPoints;

  const VideoEvidenceDialog({
    super.key,
    required this.title,
    this.videoUrl,
    this.imageUrl,
    this.audioUrl,
    this.documentUrl,
    this.hintType,
    this.onContinue,
    this.showHintText = false,
    this.hintPoints = 2,
  });

  /// Get media URL based on hint type
  String? get mediaUrl {
    final type = hintType?.toLowerCase();
    switch (type) {
      case 'video':
        return videoUrl;
      case 'image':
        return imageUrl;
      case 'audio':
        return audioUrl;
      case 'document':
        return documentUrl;
      default:
        // Fallback: check URLs in order
        return videoUrl ?? imageUrl ?? audioUrl ?? documentUrl;
    }
  }

  /// Get normalized hint type
  String? get normalizedHintType => hintType?.toLowerCase();

  @override
  State<VideoEvidenceDialog> createState() => _VideoEvidenceDialogState();
}

class _VideoEvidenceDialogState extends State<VideoEvidenceDialog> {
  bool _showText = false;
  late VideoPlayerStateController _videoController;
  late AudioPlayerController _audioController;
  final String _videoControllerTag =
      'video_hint_${DateTime.now().millisecondsSinceEpoch}';
  final String _audioControllerTag =
      'audio_hint_${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize video controller
    _videoController = Get.put(
      VideoPlayerStateController(),
      tag: _videoControllerTag,
    );

    // Initialize audio controller
    _audioController = Get.put(
      AudioPlayerController(),
      tag: _audioControllerTag,
    );

    // Initialize media based on type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final type = widget.normalizedHintType;
      final mediaUrl = widget.mediaUrl;

      if (type == 'video' && mediaUrl != null && mediaUrl.isNotEmpty) {
        _videoController.initializeVideo(mediaUrl);
      } else if (type == 'audio' && mediaUrl != null && mediaUrl.isNotEmpty) {
        _audioController.initializeAudio(mediaUrl);
      }
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<VideoPlayerStateController>(
      tag: _videoControllerTag,
    )) {
      Get.delete<VideoPlayerStateController>(tag: _videoControllerTag);
    }
    if (Get.isRegistered<AudioPlayerController>(tag: _audioControllerTag)) {
      Get.delete<AudioPlayerController>(tag: _audioControllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 0.9.sh, maxWidth: 0.4.sw),
        child: Container(
          width: 0.4.sw,
          decoration: BoxDecoration(
            color: MyColors.redButtonColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    _buildContent(),
                    SizedBox(height: 16.h),
                    _buildContinueButton(),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
              _buildCloseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            MyIcons.bulb,
            width: 10.w,
            height: 10.w,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              widget.title,
              style: AppTextStyles.heading1().copyWith(
                fontSize: 8.sp,
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Calculate max available height: 90% screen - header (~50h) - buttons (~80h) - padding (~32h)
    final maxAvailableHeight = (0.9.sh - 162.h).clamp(100.h, 500.h);
    final preferredHeight = _showText ? 20.h : _getContentHeight();
    final contentHeight =
        preferredHeight > maxAvailableHeight
            ? maxAvailableHeight
            : preferredHeight;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxAvailableHeight,
        minHeight: _showText ? 20.h : 0,
      ),
      child: Container(
        width: double.infinity,
        height: contentHeight,
        margin: EdgeInsets.symmetric(horizontal: _showText ? 5.w : 12.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: _showText ? _buildTextContent() : _buildMediaContent(),
        ),
      ),
    );
  }

  double _getContentHeight() {
    final type = widget.normalizedHintType;
    switch (type) {
      case 'video':
        return 200.h;
      case 'image':
        return 200.h;
      case 'audio':
        return 120.h;
      case 'document':
        return 150.h;
      default:
        return 200.h;
    }
  }

  Widget _buildMediaContent() {
    final type = widget.normalizedHintType;
    final mediaUrl = widget.mediaUrl;

    if (mediaUrl == null || mediaUrl.isEmpty) {
      return _buildEmptyState();
    }

    switch (type) {
      case 'video':
        return _buildVideoContent();
      case 'image':
        return _buildImageContent();
      case 'audio':
        return _buildAudioContent();
      case 'document':
        return _buildDocumentContent();
      default:
        // Fallback: try to determine type from available URLs
        if (widget.videoUrl != null && widget.videoUrl!.isNotEmpty) {
          return _buildVideoContent();
        } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
          return _buildImageContent();
        } else if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
          return _buildAudioContent();
        } else if (widget.documentUrl != null &&
            widget.documentUrl!.isNotEmpty) {
          return _buildDocumentContent();
        }
        return _buildEmptyState();
    }
  }

  Widget _buildVideoContent() {
    return Obx(() {
      if (_videoController.isVideoLoading.value) {
        return _buildLoadingState('Loading video...'.tr);
      }

      if (_videoController.hasError) {
        return _buildErrorState(
          _videoController.errorMessage.value ?? 'Failed to load video'.tr,
          onRetry: () => _videoController.retry(),
        );
      }

      if (_videoController.isVideoInitialized.value &&
          _videoController.videoController != null) {
        return _buildVideoPlayer();
      }

      return _buildLoadingState('Loading video...'.tr);
    });
  }

  Widget _buildVideoPlayer() {
    return Obx(
      () => Stack(
        fit: StackFit.expand,
        children: [
          VideoPlayer(_videoController.videoController!),
          GestureDetector(
            onTap: () => _videoController.togglePlayback(),
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _videoController.isVideoPlaying.value ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _videoController.isVideoPlaying.value
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
        ],
      ),
    );
  }

  Widget _buildImageContent() {
    return CachedNetworkImage(
      imageUrl: widget.mediaUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildLoadingState('Loading image...'.tr),
      errorWidget:
          (context, url, error) => _buildErrorState('Failed to load image'.tr),
    );
  }

  Widget _buildAudioContent() {
    return Obx(() {
      if (_audioController.isLoading.value) {
        return _buildLoadingState('Loading audio...'.tr);
      }

      if (_audioController.hasError) {
        return _buildErrorState(
          _audioController.errorMessage.value ?? 'Failed to load audio'.tr,
          onRetry: () {
            final url = widget.mediaUrl;
            if (url != null && url.isNotEmpty) {
              _audioController.initializeAudio(url);
            }
          },
        );
      }

      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Play/Pause button
              GestureDetector(
                onTap: () => _audioController.togglePlayPause(),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: MyColors.BlueColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _audioController.isPlaying.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Progress indicator
              ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: _audioController.progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4.h,
                ),
              ),
              SizedBox(height: 8.h),
              // Duration info
              if (_audioController.duration.value != Duration.zero)
                Text(
                  '${_formatDuration(_audioController.position.value)} / ${_formatDuration(_audioController.duration.value)}',
                  style: AppTextStyles.captionRegular10().copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDocumentContent() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              MyIcons.document,
              width: 16.w,
              height: 16.w,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),

            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                final url = widget.mediaUrl;
                if (url != null && url.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerScreen(pdfUrl: url),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: MyColors.BlueColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Open Document'.tr,
                  style: AppTextStyles.heading1().copyWith(
                    fontSize: 6.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 12.h),
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.captionRegular10().copyWith(
                color: Colors.white,
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, {VoidCallback? onRetry}) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
              SizedBox(height: 8.h),
              Text(
                message,
                style: AppTextStyles.captionRegular10().copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (onRetry != null) ...[
                SizedBox(height: 12.h),
                GestureDetector(
                  onTap: onRetry,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            color: Colors.white.withValues(alpha: 0.5),
            size: 48.sp,
          ),
          SizedBox(height: 8.h),
          Flexible(
            child: Text(
              'No media available'.tr,
              style: AppTextStyles.captionRegular10().copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Text(
          'Hint used - score will be affected (-${widget.hintPoints} points).',
          style: AppTextStyles.bodyTextMedium16().copyWith(
            fontSize: 6.sp,
            color: MyColors.white.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
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
        child: SvgPicture.asset(MyIcons.close_brown_rounded),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
