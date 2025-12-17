import 'dart:async';
import 'package:get/get.dart';

/// Controller for managing game timer across all screens
/// This controller ensures timer consistency and persistence during navigation
class GameTimerController extends GetxController {
  // Timer state
  final RxString timerText = '21:30'.obs;
  Timer? _timer;
  bool _isRunning = false;

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
  void startTimer({int? initialMinutes, int? initialSeconds}) {
    if (_isRunning) {
      return; // Timer already running
    }

    // Allow custom initial values
    if (initialMinutes != null) _initialMinutes = initialMinutes;
    if (initialSeconds != null) _initialSeconds = initialSeconds;

    // Reset to initial values
    timerText.value = _formatTime(_initialMinutes, _initialSeconds);
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
  void resetTimer({int? initialMinutes, int? initialSeconds}) {
    stopTimer();
    if (initialMinutes != null) _initialMinutes = initialMinutes;
    if (initialSeconds != null) _initialSeconds = initialSeconds;
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
    startTimer();
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
    // You can add custom logic here, like showing a dialog or navigating
    // For now, we'll just stop the timer
    print('Game timer finished!');
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
