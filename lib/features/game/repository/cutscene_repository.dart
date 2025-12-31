import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class CutsceneRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Get Cutscenes by Game ID
  Future<Response<dynamic>> getCutscenesByGame({
    required String gameId,
    String? language,
  }) async {
    final String url = ServerConfig.getCutscenesByGame(gameId);
    final Map<String, dynamic> queryParams = {};
    if (language != null) {
      queryParams['language'] = language;
    }
    var response = await _dioHelper.get(
      url: url,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      isAuthRequired: true,
    );
    return response;
  }

  // Get Cutscene by ID
  Future<Response<dynamic>> getCutsceneById({
    required String cutsceneId,
    String? language,
  }) async {
    final String url = ServerConfig.getCutsceneById(cutsceneId);
    final Map<String, dynamic> queryParams = {};
    if (language != null) {
      queryParams['language'] = language;
    }
    var response = await _dioHelper.get(
      url: url,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
      isAuthRequired: true,
    );
    return response;
  }
}

