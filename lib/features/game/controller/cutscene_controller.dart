import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/model/cutscene_model.dart';
import 'package:alqadiya_game/features/game/repository/cutscene_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CutsceneController extends GetxController {
  final _repository = CutsceneRepository();
  
  RxList<CutsceneModel> cutscenes = <CutsceneModel>[].obs;
  Rx<CutsceneModel?> currentCutscene = Rx<CutsceneModel?>(null);
  var isLoading = false.obs;

  // Get Cutscenes by Game ID
  Future<void> getCutscenesByGame({
    required String gameId,
    String? language,
  }) async {
    try {
      isLoading(true);
      cutscenes.clear();
      
      final response = await _repository.getCutscenesByGame(
        gameId: gameId,
        language: language,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data is List 
            ? response.data 
            : (response.data['data'] ?? []);
        final tempCutscenes = list
            .map((e) => CutsceneModel.fromJson(e))
            .toList();
        
        // Sort by order
        tempCutscenes.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
        cutscenes.assignAll(tempCutscenes);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Get Cutscene by ID
  Future<void> getCutsceneById({
    required String cutsceneId,
    String? language,
  }) async {
    try {
      isLoading(true);
      currentCutscene(null);
      
      final response = await _repository.getCutsceneById(
        cutsceneId: cutsceneId,
        language: language,
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final tempCutscene = CutsceneModel.fromJson(response.data);
        currentCutscene(tempCutscene);
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("${'Something went wrong!!!:'.tr} ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Get next cutscene in order
  CutsceneModel? getNextCutscene(int currentOrder) {
    final sorted = cutscenes.toList()
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    final index = sorted.indexWhere((c) => (c.order ?? 0) > currentOrder);
    return index != -1 ? sorted[index] : null;
  }

  // Get cutscene by order
  CutsceneModel? getCutsceneByOrder(int order) {
    return cutscenes.firstWhereOrNull((c) => c.order == order);
  }
}

