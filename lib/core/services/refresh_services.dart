// import 'package:alqadiya_game/features/booking/controller/booking_controller.dart';
// import 'package:alqadiya_game/features/home/controller/home_screen_controller.dart';
// import 'package:alqadiya_game/features/loyalty/controller/loyality_controller.dart';
// import 'package:get/get.dart';

class RefreshService {
  static Future<void> refreshAll() async {
    await Future.wait([
      // Get.find<HomeScreenController>().refresChalets(),
      // Get.find<BookingController>().fetchBookings(Get.locale!.languageCode),
      // Get.find<LoyalityController>().fetchRewards(Get.locale!.languageCode),
    ]);
  }
}
