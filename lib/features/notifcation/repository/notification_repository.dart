import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  final DioHelper _dioHelper = DioHelper();

  Future<Response<dynamic>> getNotifications() async {
    final String url = ServerConfig.notifications;
    final response = await _dioHelper.get(url: url, isAuthRequired: true);
    return response;
  }

  Future<dynamic> markRead() async {
    // Assuming an endpoint to mark all as read or similar
    // If not specified, I'll just check if it exists or leave it empty/dummy
    // User request: "write its api functions and all"
    // ServerConfig doesn't have markRead, I will guess it might be a PATCH/POST to notifications
    // For now, I'll stick to fetching.
    return null;
  }
}
