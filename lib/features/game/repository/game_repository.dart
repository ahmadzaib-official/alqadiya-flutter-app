import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class GameRepository extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // get Games List API
  Future<Response<dynamic>> getGamesList(Map<String, dynamic> body) async {
    final String url = ServerConfig.games;
    var response = await _dioHelper.get(
      url: url,
      queryParameters: body,
      isAuthRequired: true,
    );
    return response;
  }

  // get Game Detail API
  Future<Response<dynamic>> getGameDetail({required String gameId}) async {
    final String url = ServerConfig.games;
    var response = await _dioHelper.get(
      url: "$url$gameId",
      isAuthRequired: true,
    );
    return response;
  }

  // purchase game API
  Future<Response<dynamic>> purchaseGame({required String gameId}) async {
    final String url = ServerConfig.games;
    var response = await _dioHelper.post(
      url: "$url$gameId/purchase",
      requestBody: {"gameId": gameId},
      isAuthRequired: true,
    );
    return response;
  }

  // Create Teams API
  Future<Response<dynamic>> createTeams({
    required String sessionId,
    required List<Map<String, dynamic>> teams,
  }) async {
    final String url = ServerConfig.teams;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"sessionId": sessionId, "teams": teams},
      isAuthRequired: true,
    );
    return response;
  }

  // Get Available Players API
  Future<Response<dynamic>> getAvailablePlayers() async {
    final String url = ServerConfig.getPlayers;
    var response = await _dioHelper.get(url: url, isAuthRequired: true);
    return response;
  }

  // Assign Players API
  Future<Response<dynamic>> assignPlayers({
    required String gameId,
    required List<Map<String, dynamic>> teams,
  }) async {
    final String url = ServerConfig.assignPlayers;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"gameId": gameId, "teams": teams},
      isAuthRequired: true,
    );
    return response;
  }

  // Choose Leader API
  Future<Response<dynamic>> chooseLeader({
    required String teamId,
    required String leaderId,
  }) async {
    final String url = ServerConfig.chooseLeader;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"teamId": teamId, "leaderId": leaderId},
      isAuthRequired: true,
    );
    return response;
  }

  // Join Game API
  // Future<dynamic> joinGame({required String teamCode}) async {
  //   final String url = ServerConfig.joinGame;
  //   var response = await _dioHelper.post(
  //     url: url,
  //     requestBody: {"teamCode": teamCode},
  //     isAuthRequired: true,
  //   );
  //   return response;
  // }

  // Create Game Session API
  Future<Response<dynamic>> createGameSession({required String gameId}) async {
    final String url = ServerConfig.createGameSession;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"gameId": gameId},
      isAuthRequired: true,
    );
    return response;
  }

  // Join Game Session API
  Future<Response<dynamic>> joinGameSession({
    required String sessionCode,
  }) async {
    final String url = ServerConfig.joinGameSession;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"sessionCode": sessionCode},
      isAuthRequired: true,
    );
    return response;
  }

  // Update Game Session Mode API
  Future<Response<dynamic>> updateGameSessionMode({
    required String sessionId,
    required String mode,
  }) async {
    final String url = ServerConfig.createGameSession;
    var response = await _dioHelper.patch(
      url: "$url/$sessionId",
      requestBody: {"mode": mode},
      isAuthRequired: true,
    );
    return response;
  }

  // Update Game Session Status API
  Future<Response<dynamic>> updateGameSessionStatus({
    required String sessionId,
    required String status,
  }) async {
    final String url = ServerConfig.createGameSession;
    var response = await _dioHelper.patch(
      url: "$url/$sessionId",
      requestBody: {"status": status},
      isAuthRequired: true,
    );
    return response;
  }

  // Get Session Players API
  Future<Response<dynamic>> getSessionPlayers({
    required String sessionId,
  }) async {
    final String url = ServerConfig.createGameSession;
    var response = await _dioHelper.get(
      url: "$url/$sessionId/players",
      isAuthRequired: true,
    );
    return response;
  }

  // Assign Members API
  Future<Response<dynamic>> assignMembers({
    required String sessionId,
    required List<Map<String, dynamic>> assignments,
  }) async {
    final String url = ServerConfig.assignMembers;
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"sessionId": sessionId, "assignments": assignments},
      isAuthRequired: true,
    );
    return response;
  }

  // Assign Team Leader API
  Future<Response<dynamic>> assignTeamLeader({
    required String teamId,
    required String userId,
  }) async {
    final String url = "${ServerConfig.teams}/$teamId/leader";
    var response = await _dioHelper.post(
      url: url,
      requestBody: {"userId": userId},
      isAuthRequired: true,
    );
    return response;
  }

  // Get Game Session Details API
  Future<Response<dynamic>> getGameSessionDetails({
    required String sessionId,
  }) async {
    final String url = ServerConfig.getGameSessionDetails(sessionId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }

  // Get Game Session by ID API
  Future<Response<dynamic>> getGameSessionById({
    required String sessionId,
  }) async {
    final String url = ServerConfig.getGameSessionById(sessionId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }

  // Get Scoreboard API
  Future<Response<dynamic>> getScoreboard({
    required String sessionId,
  }) async {
    final String url = ServerConfig.getGameSessionScoreboard(sessionId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }

  // Get Game Result API
  Future<Response<dynamic>> getGameResult({
    required String sessionId,
  }) async {
    final String url = ServerConfig.getGameSessionResult(sessionId);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }

  // Get User Balance API
  Future<Response<dynamic>> getUserBalance() async {
    final String url = ServerConfig.userBalance;
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }
}
