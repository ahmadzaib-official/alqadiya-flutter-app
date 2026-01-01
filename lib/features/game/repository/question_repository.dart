import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class QuestionRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Get Questions by Game ID
  Future<Response<dynamic>> getQuestionsByGame({
    required String gameId,
    String? language,
    int page = 1,
    int limit = 10,
  }) async {
    final String url = ServerConfig.getQuestionsByGame(gameId);
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };
    if (language != null) {
      queryParams['language'] = language;
    }
    var response = await _dioHelper.get(
      url: url,
      queryParameters: queryParams,
      isAuthRequired: true,
    );
    return response;
  }

  // Get Question by ID
  Future<Response<dynamic>> getQuestionById({
    required String questionId,
    String? language,
  }) async {
    final String url = ServerConfig.getQuestionById(questionId);
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


