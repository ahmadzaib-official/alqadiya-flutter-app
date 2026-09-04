import 'package:alqadiya_game/features/transactions/repository/transaction_repository.dart';
import 'package:alqadiya_game/features/transactions/model/transaction_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Controller for managing transactions screen state
class TransactionsController extends GetxController {
  final _repository = TransactionRepository();
  var transactions = <TransactionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final response = await _repository.getTransactions();
      if (response.statusCode == 200 || response.statusCode == 201) {
        transactions.assignAll(
          (response.data as List)
              .map((e) => TransactionModel.fromJson(e))
              .toList(),
        );
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
      print('Error fetching transactions: $e');
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
