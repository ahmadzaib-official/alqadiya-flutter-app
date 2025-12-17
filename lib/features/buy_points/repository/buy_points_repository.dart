import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class BuyPointsRepository {
  final DioHelper _dioHelper = DioHelper();

  Future<Response<dynamic>> getPackages() async {
    final String url = ServerConfig.packages;
    final response = await _dioHelper.get(url: url, isAuthRequired: true);
    return response;
  }
}
