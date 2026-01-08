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

  Future<Response<dynamic>> markAllAsRead() async {
    final String url = ServerConfig.markAllNotificationsRead;
    final response = await _dioHelper.post(url: url, isAuthRequired: true);
    return response;
  }
}
