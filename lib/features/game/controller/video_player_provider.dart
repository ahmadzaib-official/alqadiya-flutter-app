import 'dart:async';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Controller for managing video player state and controls
class VideoPlayerStateController extends GetxController {
  VideoPlayerController? _videoController;
  final isVideoInitialized = false.obs;
  final isVideoPlaying = false.obs;
  final isVideoLoading = false.obs;
  final errorMessage = Rxn<String>();
  String? _currentVideoUrl;

  // Getters
  VideoPlayerController? get videoController => _videoController;
  bool get hasError => errorMessage.value != null;

  /// Initialize video player with the given URL
  Future<void> initializeVideo(String? videoUrl) async {
    if (videoUrl == null || videoUrl.isEmpty) {
      errorMessage.value = 'Video URL is empty';
      return;
    }

    // Don't reinitialize if same URL
    if (_currentVideoUrl == videoUrl && isVideoInitialized.value) {
      return;
    }

    isVideoLoading.value = true;
    errorMessage.value = null;
    isVideoInitialized.value = false;
    _currentVideoUrl = videoUrl;

    try {
      // Dispose previous controller if exists
      await _disposeController();

      // Validate URL
      final trimmedUrl = videoUrl.trim();
      if (trimmedUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      Uri videoUri;
      try {
        videoUri = Uri.parse(trimmedUrl);
      } catch (e) {
        throw Exception('Invalid video URL format');
      }

      // Create video controller
      _videoController = VideoPlayerController.networkUrl(videoUri);

      // Add error listener before initialization
      _videoController!.addListener(_videoListener);

      // Initialize with timeout
      await _videoController!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'Video initialization timeout after 30 seconds',
          );
        },
      );

      // Check if initialization was successful
      if (!_videoController!.value.isInitialized) {
        throw Exception('Video controller failed to initialize');
      }

      // Check for errors in the controller
      if (_videoController!.value.hasError) {
        final errorDesc =
            _videoController!.value.errorDescription ?? 'Unknown video error';
        throw Exception(errorDesc);
      }

      isVideoInitialized.value = true;
      isVideoLoading.value = false;
      isVideoPlaying.value = _videoController!.value.isPlaying;
    } on TimeoutException {
      isVideoLoading.value = false;
      errorMessage.value = 'Video loading timeout. Please check your connection.';
      await _disposeController();
    } catch (e) {
      String errorMsg = 'Failed to load video';
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('timeout')) {
        errorMsg = 'Video loading timeout. Please check your connection.';
      } else if (errorString.contains('format') ||
          errorString.contains('codec')) {
        errorMsg = 'Video format not supported';
      } else if (errorString.contains('network') ||
          errorString.contains('connection')) {
        errorMsg = 'Network error. Please check your internet connection.';
      } else if (errorString.contains('404') ||
          errorString.contains('not found')) {
        errorMsg = 'Video not found';
      } else {
        errorMsg = 'Failed to load video. Please try again.';
      }

      isVideoLoading.value = false;
      errorMessage.value = errorMsg;
      await _disposeController();
    }
  }

  /// Video listener to track playback state and errors
  void _videoListener() {
    if (_videoController == null) return;

    // Check for errors during playback
    if (_videoController!.value.hasError) {
      errorMessage.value =
          _videoController!.value.errorDescription ?? 'Video playback error';
      isVideoInitialized.value = false;
      return;
    }

    // Update playing state
    final playing = _videoController!.value.isPlaying;
    if (isVideoPlaying.value != playing) {
      isVideoPlaying.value = playing;
    }
  }

  /// Toggle video playback (play/pause)
  void togglePlayback() {
    if (_videoController == null || !isVideoInitialized.value) return;

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
    // State will be updated by listener
  }

  /// Play video
  void play() {
    if (_videoController == null || !isVideoInitialized.value) return;
    _videoController!.play();
  }

  /// Pause video
  void pause() {
    if (_videoController == null || !isVideoInitialized.value) return;
    _videoController!.pause();
  }

  /// Retry video initialization
  Future<void> retry() async {
    if (_currentVideoUrl != null) {
      await initializeVideo(_currentVideoUrl);
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = null;
  }

  /// Dispose video controller
  Future<void> _disposeController() async {
    if (_videoController != null) {
      _videoController!.removeListener(_videoListener);
      await _videoController!.dispose();
      _videoController = null;
    }
  }

  @override
  void onClose() {
    _disposeController();
    super.onClose();
  }
}
