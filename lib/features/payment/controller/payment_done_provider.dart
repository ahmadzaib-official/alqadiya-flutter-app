import 'package:get/get.dart';

/// Controller for managing payment done screen state
class PaymentDoneController extends GetxController {
  final orderNumber = '12345'.obs;
  final receiptUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf'.obs;

  /// Set order number
  void setOrderNumber(String orderNum) {
    orderNumber.value = orderNum;
  }

  /// Set receipt URL
  void setReceiptUrl(String url) {
    receiptUrl.value = url;
  }
}
