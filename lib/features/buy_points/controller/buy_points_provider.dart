import 'package:alqadiya_game/features/buy_points/repository/buy_points_repository.dart';
import 'package:alqadiya_game/features/buy_points/model/package_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Controller for managing buy points screen state
class BuyPointsController extends GetxController {
  final _repository = BuyPointsRepository();
  var pointPackages = <PackageModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    isLoading.value = true;
    try {
      final response = await _repository.getPackages();
      if (response.statusCode == 200 || response.statusCode == 201) {
        pointPackages.assignAll(
          (response.data as List)
              .map((e) => PackageModel.fromJson(e as Map<String, dynamic>))
              .toList(),
         );
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
      print('Error fetching packages: $e');
    } catch (e) {
      print('Error fetching packages: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Purchase points package
  Future<void> purchasePoints(int packageIndex) async {
    if (packageIndex >= 0 && packageIndex < pointPackages.length) {
      // TODO: Implement actual purchase logic
      // This would typically involve:
      // 1. Payment processing
      // 2. API call to add points to user account
      // 3. Update user's points balance
    }
  }
}
