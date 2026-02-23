import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class DeviceTokenRepository {
  final DioHelper _dioHelper = DioHelper();

  /// Register device token with backend
  Future<Response<dynamic>> registerDeviceToken({
    required String deviceToken,
    required String deviceType,
    required String deviceId,
  }) async {
    final String url = ServerConfig.registerDeviceToken;

    final Map<String, dynamic> requestBody = {
      'deviceToken': deviceToken,
      'deviceType': deviceType,
      'deviceId': deviceId,
    };

    var response = await _dioHelper.post(
      url: url,
      requestBody: requestBody,
      isAuthRequired: true,
      excludeLanguage: true, // Exclude language query param for this endpoint
    );

    return response;
  }
}
