import 'dart:async';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Controller for managing cached video player state and controls
class CachedVideoPlayerController extends GetxController {
  CachedVideoPlayerPlus? _player;
  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final isLoading = false.obs;
  final showControls = false.obs;
  final errorMessage = Rxn<String>();
  String? _currentVideoUrl;
  Timer? _hideControlsTimer;
  bool _isDisposed = false;

  // Getters
  CachedVideoPlayerPlus? get player => _player;
  VideoPlayerController? get controller => _player?.controller;
  bool get hasError => errorMessage.value != null;

  /// Initialize video player with the given URL
  Future<void> initializeVideo(
    String videoUrl, {
    Duration? cacheInvalidationDuration,
  }) async {
    if (_isDisposed) return;

    if (videoUrl.isEmpty) {
      errorMessage.value = 'Video URL is empty';
      return;
    }

    // Don't reinitialize if same URL and already initialized
    if (_currentVideoUrl == videoUrl && isInitialized.value && !hasError) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    isInitialized.value = false;
    isPlaying.value = false;
    _currentVideoUrl = videoUrl;

    try {
      // Dispose previous player if exists
      await _disposePlayer();
      if (_isDisposed) return;

      // Validate URL
      final trimmedUrl = videoUrl.trim();
      if (trimmedUrl.isEmpty) {
        throw Exception('Video URL is empty');
      }

      Uri videoUri;
      try {
        videoUri = Uri.parse(trimmedUrl);
      } catch (e) {
        throw Exception('Invalid video URL format: $e');
      }

      // Create cached video player
      _player = CachedVideoPlayerPlus.networkUrl(
        videoUri,
        invalidateCacheIfOlderThan:
            cacheInvalidationDuration ?? const Duration(minutes: 120),
      );

      if (_isDisposed) {
        await _disposePlayer();
        return;
      }

      // Initialize with timeout
      await _player!.initialize().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException(
            'Video initialization timeout after 30 seconds',
          );
        },
      );

      if (_isDisposed) {
        await _disposePlayer();
        return;
      }

      // Check if initialization was successful
      if (!_player!.isInitialized) {
        throw Exception('Video player failed to initialize');
      }

      // Check for errors in the controller
      if (_player!.controller.value.hasError) {
        final errorDesc =
            _player!.controller.value.errorDescription ?? 'Unknown video error';
        throw Exception(errorDesc);
      }

      // Setup listener AFTER successful initialization
      _setupListener();

      isInitialized.value = true;
      isLoading.value = false;
      isPlaying.value = _player!.controller.value.isPlaying;

      if (_isDisposed) return;

      // Auto-play after initialization
      await _player!.controller.play();
    } on TimeoutException {
      if (!_isDisposed) {
        isLoading.value = false;
        errorMessage.value = 'Video loading timeout. Please check your connection.';
        await _disposePlayer();
      }
    } catch (e) {
      if (!_isDisposed) {
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
          errorMsg = 'Failed to load video: ${e.toString()}';
        }

        isLoading.value = false;
        errorMessage.value = errorMsg;
        await _disposePlayer();
      }
    }
  }

  /// Setup listener to track playback state and errors
  void _setupListener() {
    if (_player == null) return;

    // Listen to controller value changes
    _player!.controller.addListener(_valueListener);
  }

  /// Value listener to track playback state and errors
  void _valueListener() {
    if (_isDisposed || _player == null) return;

    try {
      // Check for errors during playback
      if (_player!.controller.value.hasError) {
        errorMessage.value =
            _player!.controller.value.errorDescription ??
            'Video playback error';
        isInitialized.value = false;
        return;
      }

      // Update playing state
      final playing = _player!.controller.value.isPlaying;
      if (isPlaying.value != playing) {
        isPlaying.value = playing;
      }
    } catch (e) {
      // Ignore errors in listener to prevent infinite loops
      Get.log('Error in video player listener: $e');
    }
  }

  /// Toggle controls visibility
  void toggleControls() {
    showControls.value = !showControls.value;
    _startHideTimer();
  }

  /// Show controls overlay
  void showControlsOverlay() {
    if (!showControls.value) {
      showControls.value = true;
    }
    _startHideTimer();
  }

  /// Hide controls
  void hideControls() {
    if (showControls.value) {
      showControls.value = false;
    }
    _hideControlsTimer?.cancel();
  }

  /// Start timer to auto-hide controls
  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    if (showControls.value) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        hideControls();
      });
    }
  }

  /// Toggle video playback (play/pause)
  Future<void> togglePlayPause() async {
    if (_player == null || !isInitialized.value || hasError) return;

    try {
      if (isPlaying.value) {
        await _player!.controller.pause();
      } else {
        await _player!.controller.play();
      }
      // State will be updated by listener
      _startHideTimer();
    } catch (e) {
      errorMessage.value = 'Playback error: ${e.toString()}';
    }
  }

  /// Play video
  Future<void> play() async {
    if (_player == null || !isInitialized.value || hasError) return;
    try {
      await _player!.controller.play();
    } catch (e) {
      errorMessage.value = 'Play error: ${e.toString()}';
    }
  }

  /// Pause video
  Future<void> pause() async {
    if (_player == null || !isInitialized.value) return;
    try {
      await _player!.controller.pause();
    } catch (e) {
      errorMessage.value = 'Pause error: ${e.toString()}';
    }
  }

  /// Seek to position
  Future<void> seekTo(Duration position) async {
    if (_player == null || !isInitialized.value) return;
    try {
      await _player!.controller.seekTo(position);
    } catch (e) {
      errorMessage.value = 'Seek error: ${e.toString()}';
    }
  }

  /// Retry video initialization
  Future<void> retry() async {
    if (_currentVideoUrl != null) {
      await initializeVideo(_currentVideoUrl!);
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = null;
  }

  /// Dispose video player
  Future<void> _disposePlayer() async {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;

    if (_player != null) {
      try {
        // Remove listener before disposing
        _player!.controller.removeListener(_valueListener);
        await _player!.dispose();
      } catch (e) {
        Get.log('Error disposing video player: $e');
      } finally {
        _player = null;
      }
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    // Don't await async dispose in synchronous dispose method
    // The async cleanup will happen, but we mark as disposed immediately
    _disposePlayer().catchError((error) {
      Get.log('Error in dispose: $error');
    });
    super.onClose();
  }
}
