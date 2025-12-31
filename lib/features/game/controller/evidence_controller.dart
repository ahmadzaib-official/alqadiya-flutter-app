import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/evidence_model.dart';
import 'package:alqadiya_game/features/game/repository/evidence_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class EvidenceController extends GetxController {
  final _repository = EvidenceRepository();
  
  RxList<EvidenceModel> evidences = <EvidenceModel>[].obs;
  Rx<EvidenceModel?> evidenceDetail = Rx<EvidenceModel?>(null);
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  
  // Pagination variables
  int currentPage = 1;
  int limit = 10;
  var hasMore = true.obs;
  String? currentGameId;

  // Get Evidences by Game ID
  Future<void> getEvidencesByGame({
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
        evidences.clear();
        currentGameId = gameId;
      }

      final response = await _repository.getEvidencesByGame(
        gameId: gameId,
        page: currentPage,
        limit: limit,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data['data'] ?? [];
        final tempEvidences = list
            .map((e) => EvidenceModel.fromJson(e))
            .toList();

        if (isLoadMore) {
          evidences.addAll(tempEvidences);
        } else {
          evidences.assignAll(tempEvidences);
        }

        if (tempEvidences.length < limit) {
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

  // Get Evidence by ID
  Future<void> getEvidenceById({
    required String evidenceId,
  }) async {
    try {
      isLoading(true);
      evidenceDetail(null);

      final response = await _repository.getEvidenceById(evidenceId: evidenceId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempEvidence = EvidenceModel.fromJson(response.data);
        evidenceDetail(tempEvidence);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }
}

