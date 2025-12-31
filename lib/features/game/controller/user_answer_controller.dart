import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/user_answer_model.dart';
import 'package:alqadiya_game/features/game/repository/user_answer_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class UserAnswerController extends GetxController {
  final _repository = UserAnswerRepository();
  
  Rx<UserAnswerModel?> lastAnswer = Rx<UserAnswerModel?>(null);
  var isLoading = false.obs;

  // Submit Answer
  Future<bool> submitAnswer({
    required String sessionId,
    required String questionId,
    required String selectedOptionId,
    required int timeSpentSeconds,
    bool hintUsed = false,
  }) async {
    try {
      isLoading(true);
      lastAnswer(null);

      final response = await _repository.submitAnswer(
        sessionId: sessionId,
        questionId: questionId,
        selectedOptionId: selectedOptionId,
        timeSpentSeconds: timeSpentSeconds,
        hintUsed: hintUsed,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempAnswer = UserAnswerModel.fromJson(response.data);
        lastAnswer(tempAnswer);
        return true;
      }
      return false;
    } on DioException {
      // Error already shown by interceptor
      return false;
    } catch (e) {
      CustomSnackbar.showError("Something went wrong!!!: ${e.toString()}");
      return false;
    } finally {
      isLoading(false);
    }
  }
}

