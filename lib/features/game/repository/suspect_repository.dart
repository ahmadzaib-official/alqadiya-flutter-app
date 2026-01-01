import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class SuspectRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Get Suspects by Game ID
  Future<Response<dynamic>> getSuspectsByGame({
    required String gameId,
    int page = 1,
    int limit = 10,
  }) async {
    final String url = ServerConfig.getSuspectsByGame(gameId);
    var response = await _dioHelper.get(
      url: url,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      isAuthRequired: true,
    );
    return response;
  }

  // Get Suspect by ID
  Future<Response<dynamic>> getSuspectById({
    required String suspectId,
  }) async {
    final String url = ServerConfig.getSuspectById(suspectId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }
}


