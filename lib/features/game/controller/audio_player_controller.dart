import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

/// Controller for managing audio player state and controls
class AudioPlayerController extends GetxController {
  late just_audio.AudioPlayer _audioPlayer;
  final isPlaying = false.obs;
  final isLoading = false.obs;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;
  final errorMessage = Rxn<String>();
  String? _currentAudioUrl;
  StreamSubscription<Duration?>? _durationSubscription;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<just_audio.PlayerState>? _playerStateSubscription;

  // Getters
  bool get hasError => errorMessage.value != null;
  double get progress =>
      duration.value.inMilliseconds > 0
          ? position.value.inMilliseconds / duration.value.inMilliseconds
          : 0.0;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = just_audio.AudioPlayer();
    _setupListeners();
  }

  /// Setup stream listeners for audio player
  void _setupListeners() {
    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });

    // Listen to duration changes
    _durationSubscription = _audioPlayer.durationStream.listen((dur) {
      duration.value = dur ?? Duration.zero;
    });

    // Listen to position changes
    _positionSubscription = _audioPlayer.positionStream.listen((pos) {
      position.value = pos;
    });
  }

  /// Initialize audio player with the given URL
  Future<void> initializeAudio(String audioUrl) async {
    if (audioUrl.isEmpty) {
      errorMessage.value = 'Audio URL is empty';
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      // If same URL, just reset position and state
      if (_currentAudioUrl == audioUrl && !hasError) {
        // Reset to beginning if audio has finished or is at end
        final currentPosition = _audioPlayer.position;
        final audioDuration = _audioPlayer.duration;
        if (audioDuration != null &&
            (currentPosition >= audioDuration ||
                _audioPlayer.processingState ==
                    just_audio.ProcessingState.completed)) {
          await _audioPlayer.seek(Duration.zero);
        }
        // Pause if playing to reset state
        if (isPlaying.value) {
          await _audioPlayer.pause();
        }
        isLoading.value = false;
        return;
      }

      // New URL - load it
      _currentAudioUrl = audioUrl;
      await _audioPlayer.setUrl(audioUrl);
      // Reset position to start
      await _audioPlayer.seek(Duration.zero);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Failed to load audio: ${e.toString()}';
    }
  }

  /// Toggle audio playback (play/pause)
  Future<void> togglePlayPause() async {
    if (hasError) return;

    try {
      if (isPlaying.value) {
        await _audioPlayer.pause();
      } else {
        // If audio has finished, reset to beginning before playing
        final audioDuration = _audioPlayer.duration;
        final currentPosition = _audioPlayer.position;
        if (audioDuration != null &&
            (currentPosition >= audioDuration ||
                _audioPlayer.processingState ==
                    just_audio.ProcessingState.completed)) {
          await _audioPlayer.seek(Duration.zero);
        }
        await _audioPlayer.play();
      }
      // State will be updated by stream listener
    } catch (e) {
      errorMessage.value = 'Playback error: ${e.toString()}';
    }
  }

  /// Play audio
  Future<void> play() async {
    if (hasError) return;
    try {
      await _audioPlayer.play();
    } catch (e) {
      errorMessage.value = 'Play error: ${e.toString()}';
    }
  }

  /// Pause audio
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      errorMessage.value = 'Pause error: ${e.toString()}';
    }
  }

  /// Seek to position
  Future<void> seek(Duration pos) async {
    try {
      await _audioPlayer.seek(pos);
    } catch (e) {
      errorMessage.value = 'Seek error: ${e.toString()}';
    }
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = null;
  }

  /// Reset audio player to beginning
  Future<void> reset() async {
    try {
      await _audioPlayer.seek(Duration.zero);
      if (isPlaying.value) {
        await _audioPlayer.pause();
      }
    } catch (e) {
      errorMessage.value = 'Reset error: ${e.toString()}';
    }
  }

  @override
  void onClose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.onClose();
  }
}
