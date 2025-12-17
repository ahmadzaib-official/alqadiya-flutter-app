import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';

class TransactionRepository {
  final DioHelper _dioHelper = DioHelper();

   Future<Response<dynamic>>  getTransactions() async {
    final String url = ServerConfig.transactions;
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  
  }

  Future<Response<dynamic>> getTransactionReceipt(String id) async {
    final String url = ServerConfig.getReceipt(id);
    var response = await _dioHelper.get(
      url: url,
      isAuthRequired: true,
    );
    return response;
  }
}
