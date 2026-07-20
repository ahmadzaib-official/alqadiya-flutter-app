import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class NotificationRepository {
  final DioHelper _dioHelper = DioHelper();

  Future<Response<dynamic>> getNotifications({
    int page = 1,
    int limit = 10,
    String? language,
  }) async {
    final String url = ServerConfig.notifications;

    final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

    if (language != null) {
      queryParams['language'] = language;
    }

    final response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
      queryParameters: queryParams,
    );
    return response;
  }

  Future<Response<dynamic>> markAllAsRead() async {
    final String url = ServerConfig.markAllNotificationsRead;
    final response = await _dioHelper.post(url: url, isAuthRequired: true);
    return response;
  }

  Future<Response<dynamic>> markAsRead(String notificationId) async {
    final String url = ServerConfig.markNotificationRead(notificationId);
    final response = await _dioHelper.post(url: url, isAuthRequired: true);
    return response;
  }
}
