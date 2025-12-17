
import 'package:alqadiya_game/features/transactions/model/transaction_receipt_model.dart';
import 'package:alqadiya_game/features/transactions/repository/transaction_repository.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class TransactionReceiptController extends GetxController {
  final TransactionRepository _repository = TransactionRepository();
  final RxBool isLoading = true.obs;
  final Rx<TransactionReceiptModel?> receipt = Rx<TransactionReceiptModel?>(null);
  String? transactionId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      transactionId = Get.arguments as String;
      fetchReceipt();
    }
  }

  Future<void> fetchReceipt() async {
    if (transactionId == null) return;
    try {
      isLoading.value = true;
      final response = await _repository.getTransactionReceipt(transactionId!);
        if(response.statusCode==200||response.statusCode==201){

        receipt.value = TransactionReceiptModel.fromJson(response.data);
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
      print("Error fetching receipt: $e");
    } catch (e) {
      print("Error fetching receipt: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
