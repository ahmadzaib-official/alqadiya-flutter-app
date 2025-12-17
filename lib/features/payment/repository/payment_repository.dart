import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class PaymentRepository {
  final DioHelper _dioHelper = DioHelper();

  Future<Response<dynamic>> getPaymentMethods() async {
    final String url = ServerConfig.paymentMethods;
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }

  Future<Response<dynamic>> purchasePoints({
    required String packageId,
    required String paymentMethodId,
  }) async {
    final String url = ServerConfig.purchasePoints;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {
        "packageId": packageId,
        "paymentMethodId": paymentMethodId,
      },
      isAuthRequired: true,
    );
    return response;
  }
}
