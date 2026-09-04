import 'dart:async';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:get/get.dart';

class CaseVideoController extends GetxController {
  CachedVideoPlayerPlus? _player;
  Timer? _hideControlsTimer;
  Timer? _stateCheckTimer;

  // Reactive state variables
  final RxBool isInitialized = false.obs;
  final RxBool isPlaying = false.obs;
  final RxBool showControls = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isReplaying = false.obs;
  final RxInt currentCutsceneIndex = 0.obs;

  CachedVideoPlayerPlus? get player => _player;

  @override
  void onClose() {
    _disposePlayer();
    _hideControlsTimer?.cancel();
    _stateCheckTimer?.cancel();
    super.onClose();
  }

  void _disposePlayer() {
    _player?.dispose();
    _player = null;
    isInitialized.value = false;
    isPlaying.value = false;
  }

  Future<void> initializePlayer(String videoUrl) async {
    try {
      isLoading.value = true;
      _disposePlayer();

      _player = CachedVideoPlayerPlus.networkUrl(
        Uri.parse(videoUrl),
        invalidateCacheIfOlderThan: const Duration(minutes: 120),
      );

      await _player!.initialize();

      if (_player != null) {
        isInitialized.value = true;
        _startStateMonitoring();
        await _player!.controller.play();
        _updatePlayingState();
      }
    } catch (e) {
      print('Error initializing video player: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _startStateMonitoring() {
    // Monitor video player state changes every 100ms for accurate state tracking
    _stateCheckTimer?.cancel();
    _stateCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (_player != null && _player!.isInitialized) {
        _updatePlayingState();
      } else {
        timer.cancel();
      }
    });

    // Also listen to video player state changes
    _player?.controller.addListener(_onVideoStateChanged);
  }

  void _onVideoStateChanged() {
    if (_player != null && _player!.isInitialized) {
      _updatePlayingState();
    }
  }

  void _updatePlayingState() {
    if (_player != null && _player!.isInitialized) {
      final newIsPlaying = _player!.controller.value.isPlaying;
      if (isPlaying.value != newIsPlaying) {
        isPlaying.value = newIsPlaying;
      }
    }
  }

  void toggleControls() {
    showControls.value = !showControls.value;
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    if (showControls.value) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        showControls.value = false;
      });
    }
  }

  void togglePlayPause() {
    if (_player == null || !_player!.isInitialized) return;

    if (_player!.controller.value.isPlaying) {
      _player!.controller.pause();
    } else {
      _player!.controller.play();
    }
    _startHideTimer();
  }

  Future<void> replayVideo() async {
    if (_player == null || !_player!.isInitialized || isReplaying.value) return;

    try {
      isReplaying.value = true;
      await _player!.controller.seekTo(Duration.zero);
      await _player!.controller.play();
      showControls.value = true;
      _startHideTimer();
    } catch (e) {
      print('Error replaying video: $e');
    } finally {
      isReplaying.value = false;
    }
  }

  void checkAndShowControls() {
    if (_player != null &&
        _player!.isInitialized &&
        !_player!.controller.value.isPlaying) {
      showControls.value = true;
      _startHideTimer();
    }
  }

  void pauseVideo() {
    if (_player != null &&
        _player!.isInitialized &&
        _player!.controller.value.isPlaying) {
      _player!.controller.pause();
    }
  }

  void playNextCutscene() {
    currentCutsceneIndex.value++;
  }

  void resetCutsceneIndex() {
    currentCutsceneIndex.value = 0;
  }
}
