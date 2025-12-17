import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/payment/model/payment_method_model.dart';
import 'package:alqadiya_game/features/payment/repository/payment_repository.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:get/get.dart';

/// Controller for managing payment screen state
class PaymentController extends GetxController {
  final _repository = PaymentRepository();
  final orderPoints = ''.obs;
  // final orderNumber = '12345'.obs; // Not used effectively for now, keeping dynamic
  final discountCode = ''.obs;
  final isDiscountVerified = false.obs;

  // Selected payment method
  final selectedPaymentMethod = Rx<PaymentMethodModel?>(null);

  // Package Details
  String packageId = '';

  // List of payment methods
  final paymentMethods = <PaymentMethodModel>[].obs;

  final termsAccepted = false.obs;
  final totalAmount = 0.0.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      packageId = args['id'] ?? '';
      orderPoints.value = "${args['points']} points";
      totalAmount.value = (args['price'] as num?)?.toDouble() ?? 0.0;
    }
    fetchPaymentMethods();
  }

  /// Fetch payment methods from API
  Future<void> fetchPaymentMethods() async {
    isLoading(true);
    try {
      final response = await _repository.getPaymentMethods();
        if(response.statusCode==200||response.statusCode==201){

        final methods =
             (response.data as List).map((e) => PaymentMethodModel.fromJson(e)).toList();
        paymentMethods.assignAll(methods);

        // Auto-select first method or logic to select 'myatoorah' if needed
        if (paymentMethods.isNotEmpty) {
          selectedPaymentMethod.value = paymentMethods.first;
        }
      }
    } catch (e) {
      print("Error fetching payment methods: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Update discount code
  void updateDiscountCode(String code) {
    discountCode.value = code;
  }

  /// Verify discount code
  void verifyDiscountCode() {
    // TODO: Implement actual discount code validation
    isDiscountVerified.value = discountCode.value.isNotEmpty;
  }

  /// Select payment method
  void selectPaymentMethod(PaymentMethodModel method) {
    selectedPaymentMethod.value = method;
  }

  /// Toggle terms acceptance
  void toggleTermsAccepted() {
    termsAccepted.value = !termsAccepted.value;
  }

  /// Process payment
  Future<void> processPayment() async {
    if (!termsAccepted.value) {
      CustomSnackbar.showError("Please accept terms and conditions");
      return;
    }
    if (selectedPaymentMethod.value == null) {
      CustomSnackbar.showError("Please select a payment method");
      return;
    }

    isLoading(true);
    try {
      final response = await _repository.purchasePoints(
        packageId: packageId,
        paymentMethodId: selectedPaymentMethod.value!.id!,
      );

       if(response.statusCode==200||response.statusCode==201){

        // Navigate even if response structure isn't perfect for now, usually checks strictly
        // Assuming success if no exception thrown, or check response status map

        Get.offAllNamed(AppRoutes.paymentDoneScreen);
      }
    } catch (e) {
      CustomSnackbar.showError("Payment Failed: $e");
    } finally {
      isLoading(false);
    }
  }
}
