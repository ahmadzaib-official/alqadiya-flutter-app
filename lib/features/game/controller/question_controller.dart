import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/question_model.dart';
import 'package:alqadiya_game/features/game/repository/question_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController {
  final _repository = QuestionRepository();
  
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  Rx<QuestionModel?> currentQuestion = Rx<QuestionModel?>(null);
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  
  // Pagination variables
  int currentPage = 1;
  int limit = 10;
  var hasMore = true.obs;
  String? currentGameId;

  // Get Questions by Game ID
  Future<void> getQuestionsByGame({
    required String gameId,
    String? language,
    bool isLoadMore = false,
  }) async {
    try {
      if (isLoadMore) {
        if (isMoreLoading.value || !hasMore.value) return;
        isMoreLoading(true);
      } else {
        isLoading(true);
        currentPage = 1;
        hasMore(true);
        questions.clear();
        currentGameId = gameId;
      }

      final response = await _repository.getQuestionsByGame(
        gameId: gameId,
        language: language,
        page: currentPage,
        limit: limit,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data is List
            ? response.data
            : (response.data['data'] ?? []);
        final tempQuestions = list
            .map((e) => QuestionModel.fromJson(e))
            .toList();

        // Sort by order
        tempQuestions.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

        if (isLoadMore) {
          questions.addAll(tempQuestions);
        } else {
          questions.assignAll(tempQuestions);
        }

        if (tempQuestions.length < limit) {
          hasMore(false);
        } else {
          currentPage++;
          hasMore(true);
        }
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      if (isLoadMore) {
        isMoreLoading(false);
      } else {
        isLoading(false);
      }
    }
  }

  // Get Question by ID
  Future<void> getQuestionById({
    required String questionId,
    String? language,
  }) async {
    try {
      isLoading(true);
      currentQuestion(null);

      final response = await _repository.getQuestionById(
        questionId: questionId,
        language: language,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempQuestion = QuestionModel.fromJson(response.data);
        currentQuestion(tempQuestion);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Get question by order
  QuestionModel? getQuestionByOrder(int order) {
    return questions.firstWhereOrNull((q) => q.order == order);
  }

  // Get next question
  QuestionModel? getNextQuestion(int currentOrder) {
    final sorted = questions.toList()
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final index = sorted.indexWhere((q) => (q.order ?? 0) > currentOrder);
    return index != -1 ? sorted[index] : null;
  }
}

