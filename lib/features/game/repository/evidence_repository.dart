import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class EvidenceRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Get Evidences by Game ID
  Future<Response<dynamic>> getEvidencesByGame({
    required String gameId,
    int page = 1,
    int limit = 10,
  }) async {
    final String url = ServerConfig.getEvidencesByGame(gameId);
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

  // Get Evidence by ID
  Future<Response<dynamic>> getEvidenceById({
    required String evidenceId,
  }) async {
    final String url = ServerConfig.getEvidenceById(evidenceId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }
}

