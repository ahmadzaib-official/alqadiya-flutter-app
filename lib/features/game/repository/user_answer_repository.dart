import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class UserAnswerRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Submit User Answer
  Future<Response<dynamic>> submitAnswer({
    required String sessionId,
    required String questionId,
    required String selectedOptionId,
    required int timeSpentSeconds,
    bool hintUsed = false,
  }) async {
    final String url = ServerConfig.userAnswers;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {
        "sessionId": sessionId,
        "questionId": questionId,
        "selectedOptionId": selectedOptionId,
        "timeSpentSeconds": timeSpentSeconds,
        "hintUsed": hintUsed,
      },
      isAuthRequired: true,
    );
    return response;
  }
}
