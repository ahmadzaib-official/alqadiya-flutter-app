import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:get/get.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';

class SplashController extends GetxController {
  final Preferences pref = Get.find<Preferences>();

  var progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startProgressAnimation();
    // Check if user is guest or logged in
    final bool isGuest = pref.getBool(AppStrings.isGuest) ?? false;
    final bool isLoggedIn = pref.getString(AppStrings.userId) != null;

    // ✅ Always use Get.offAllNamed to clear navigation stack
    if (isGuest || isLoggedIn) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(AppRoutes.homescreen);
      });
      return;
    }

    // Directly navigate after 4 seconds (splash wait)
    Future.delayed(const Duration(seconds: 3), _navigateToAppropriateScreen);
  }

  void _startProgressAnimation() {
    const duration = 3;
    for (int i = 0; i <= duration * 100; i++) {
      Future.delayed(Duration(milliseconds: i * 10), () {
        progress.value = i / 300;
      });
    }
  }

  Future<void> _navigateToAppropriateScreen() async {
    final bool isFirstTime = pref.getBool(AppStrings.isFirstRegister) ?? false;
    final String? userId = pref.getString(AppStrings.userId);
    final String? accessToken = pref.getString(AppStrings.accessToken);

    DebugPoint.log(
      'isFirstTime: $isFirstTime | userId: $userId | accessToken: $accessToken',
    );

    if (!isFirstTime) {
      Get.offAllNamed(AppRoutes.onbordingScreen);
    } else if (userId != null && accessToken != null) {
      Get.offAllNamed(AppRoutes.homescreen);
    } else {
      Get.offAllNamed(AppRoutes.sigin);
    }
  }
}
