import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/services/screen_cast_service.dart';
import 'package:get/get.dart';

class Services {
  static final Services _instance = Services._();

  Services._();

  factory Services() => _instance;
  Future<void> initServices() async {
    await Get.putAsync<Preferences>(() => Preferences().initial());

    // Initialize screen cast service
    Get.put(ScreenCastService());
  }
}
