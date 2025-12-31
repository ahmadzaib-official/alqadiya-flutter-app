import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/suspect_model.dart';
import 'package:alqadiya_game/features/game/repository/suspect_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class SuspectController extends GetxController {
  final _repository = SuspectRepository();
  
  RxList<SuspectModel> suspects = <SuspectModel>[].obs;
  Rx<SuspectModel?> suspectDetail = Rx<SuspectModel?>(null);
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  
  // Pagination variables
  int currentPage = 1;
  int limit = 10;
  var hasMore = true.obs;
  String? currentGameId;

  // Get Suspects by Game ID
  Future<void> getSuspectsByGame({
    required String gameId,
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
        suspects.clear();
        currentGameId = gameId;
      }

      final response = await _repository.getSuspectsByGame(
        gameId: gameId,
        page: currentPage,
        limit: limit,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data['data'] ?? [];
        final tempSuspects = list
            .map((e) => SuspectModel.fromJson(e))
            .toList();

        if (isLoadMore) {
          suspects.addAll(tempSuspects);
        } else {
          suspects.assignAll(tempSuspects);
        }

        if (tempSuspects.length < limit) {
          hasMore(false);
        } else {
          currentPage++;
          hasMore(true);
        }
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("Something went wrong!!!: ${e.toString()}");
    } finally {
      if (isLoadMore) {
        isMoreLoading(false);
      } else {
        isLoading(false);
      }
    }
  }

  // Get Suspect by ID
  Future<void> getSuspectById({
    required String suspectId,
  }) async {
    try {
      isLoading(true);
      suspectDetail(null);

      final response = await _repository.getSuspectById(suspectId: suspectId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempSuspect = SuspectModel.fromJson(response.data);
        suspectDetail(tempSuspect);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("Something went wrong!!!: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}

