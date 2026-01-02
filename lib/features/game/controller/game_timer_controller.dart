import 'dart:async';
import 'package:get/get.dart';

/// Controller for managing game timer across all screens
/// This controller ensures timer consistency and persistence during navigation
class GameTimerController extends GetxController {
  // Timer state
  final RxString timerText = '21:30'.obs;
  Timer? _timer;
  bool _isRunning = false;
  
  // Track current game ID to detect new games
  String? _currentGameId;

  // Initial timer values (can be configured)
  int _initialMinutes = 21;
  int _initialSeconds = 30;

  // Getters
  bool get isRunning => _isRunning;
  String get formattedTime => timerText.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize timer text
    timerText.value = _formatTime(_initialMinutes, _initialSeconds);
  }

  /// Start the timer countdown
  /// This should be called when entering the game screen
  /// [gameId] is used to detect if it's a new game and reset the timer
  void startTimer({int? initialMinutes, int? initialSeconds, String? gameId}) {
    // If it's a new game (different gameId), reset the timer
    if (gameId != null && gameId != _currentGameId) {
      _currentGameId = gameId;
      // Force reset for new game
      stopTimer();
      if (initialMinutes != null) _initialMinutes = initialMinutes;
      if (initialSeconds != null) _initialSeconds = initialSeconds;
      timerText.value = _formatTime(_initialMinutes, _initialSeconds);
    } else if (_isRunning) {
      // Timer already running for the same game, don't restart
      return;
    } else if (gameId != null && gameId == _currentGameId && !_isRunning) {
      // Same game, timer paused - resume from current time instead of resetting
      resumeTimer();
      return;
    }

    // Update game ID if provided
    if (gameId != null) {
      _currentGameId = gameId;
    }

    // Allow custom initial values
    if (initialMinutes != null) _initialMinutes = initialMinutes;
    if (initialSeconds != null) _initialSeconds = initialSeconds;

    // Reset to initial values if not already set above (for first start or when gameId is null)
    // Note: For new games, this was already set above, so we skip here
    if (_currentGameId == null || gameId == null) {
      timerText.value = _formatTime(_initialMinutes, _initialSeconds);
    }
    
    _isRunning = true;

    // Cancel any existing timer
    _timer?.cancel();

    // Start periodic timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final parts = timerText.value.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);

      if (seconds > 0) {
        seconds--;
      } else if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else {
        // Timer reached zero
        stopTimer();
        _onTimerFinished();
        return;
      }

      timerText.value = _formatTime(minutes, seconds);
    });
  }

  /// Stop the timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  /// Reset timer to initial values
  void resetTimer({int? initialMinutes, int? initialSeconds, String? gameId}) {
    stopTimer();
    if (initialMinutes != null) _initialMinutes = initialMinutes;
    if (initialSeconds != null) _initialSeconds = initialSeconds;
    if (gameId != null) _currentGameId = gameId;
    timerText.value = _formatTime(_initialMinutes, _initialSeconds);
  }

  /// Pause the timer (keeps current time)
  void pauseTimer() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
  }

  /// Resume the timer from current time
  void resumeTimer() {
    if (_isRunning) return;
    
    // Parse current time from timerText
    final parts = timerText.value.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    
    // Don't resume if timer is already at zero
    if (minutes == 0 && seconds == 0) return;
    
    _isRunning = true;
    _timer?.cancel();
    
    // Start timer from current time
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final parts = timerText.value.split(':');
      int minutes = int.parse(parts[0]);
      int seconds = int.parse(parts[1]);

      if (seconds > 0) {
        seconds--;
      } else if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else {
        stopTimer();
        _onTimerFinished();
        return;
      }

      timerText.value = _formatTime(minutes, seconds);
    });
  }

  /// Clean up the timer controller (call when game ends)
  /// This will stop the timer and remove it from GetX
  void cleanup() {
    stopTimer();
    if (Get.isRegistered<GameTimerController>()) {
      Get.delete<GameTimerController>();
    }
  }

  /// Callback when timer reaches zero
  void _onTimerFinished() {
    // Timer finished - should handle game timeout
    // TODO: Navigate to game result screen or show timeout dialog
    // Get.toNamed(AppRoutes.gameResultScreen, arguments: {'reason': 'timeout'});
  }

  /// Format time as MM:SS
  String _formatTime(int minutes, int seconds) {
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }
}
