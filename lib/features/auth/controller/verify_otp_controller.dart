import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class VerificationController extends GetxController {
  final otp = ''.obs;
  final countdown = 60.obs; // 1 minute 50 seconds in seconds
  final isButtonEnabled = false.obs;
  var isVeifyOtp = false.obs;
  var isResendingOtp = false.obs;
  Timer? timer;
  var phoneNumber = '';
  var isRegister = false;
  var isEmailVerfication = false;
  var isResend = false;
  var isForgotPassword = false;
  var isVerifyPhoneNumber = false;
  final pinputController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var userId = '';
  final int otpLength = 6; // Configurable OTP length

  @override
  void onInit() {
    super.onInit();
    isRegister = Get.arguments['isRegister'] ?? false;
    userId = Get.arguments['userId'] ?? '';
    isForgotPassword = Get.arguments['isForgotPassword'] ?? false;
    isVerifyPhoneNumber = Get.arguments['isVerifyPhoneNumber'] ?? false;
    phoneNumber = Get.arguments['phoneNumber'] ?? '';
    isEmailVerfication = Get.arguments['isEmailVerfication'] ?? false;
    startTimer();
    ever(otp, (value) {
      isButtonEnabled.value = value.length == otpLength;
    });
  }

  void startTimer() {
    timer?.cancel(); // Cancel existing timer if any
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> resendCode() async {
    if (countdown.value > 0) {
      return;
    }

    try {
      isResendingOtp.value = true;
      otp.value = '';
      pinputController.clear();
      isButtonEnabled.value = false;

      String cleanPhoneNumber = phoneNumber;
      if (phoneNumber.contains('  ')) {
        cleanPhoneNumber = phoneNumber.split('  ').first.trim();
      }

      final body = {"phoneNumber": cleanPhoneNumber, "callingCode": '+965'};
      final response = await ApiFetch().sendOtp(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        countdown.value = 60;
        otp.value = response.data['otpCode'].toString();
        startTimer();
        CustomSnackbar.showSuccess('OTP sent successfully'.tr);
      }
    } on DioException catch (e) {
      // Error already shown by interceptor
      DebugPoint.log("Resend OTP error: $e");
    } catch (e) {
      CustomSnackbar.showError('Error: ${e.toString()}');
      DebugPoint.log("Resend OTP error: $e");
    } finally {
      isResendingOtp.value = false;
    }
  }

  Future<bool> verifyOtp() async {
    try {
      isVeifyOtp(true);
      final userId1 =
          Get.find<Preferences>().getString(AppStrings.userId) ?? userId;

      final otpCode = int.tryParse(otp.value);
      final body = {"userId": userId1, "otpCode": otpCode};
      final response = await ApiFetch().verifyOtp(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null && response.data['accessToken'] != null) {
          await Get.find<Preferences>().setString(
            AppStrings.userId,
            response.data['userId'],
          );
          await Get.find<Preferences>().setString(
            AppStrings.accessToken,
            response.data['accessToken'],
          );
          await Get.find<Preferences>().setBool(
            AppStrings.isFirstRegister,
            true,
          );
          Get.find<Preferences>().remove(AppStrings.isGuest);
        }
        return true;
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (_) {
      // Handle unexpected errors
    } finally {
      isVeifyOtp(false);
    }
    return false;
  }

  Future<bool> verifyPhoneOtp() async {
    try {
      isVeifyOtp(true);
      final userId1 =
          Get.find<Preferences>().getString(AppStrings.userId) ?? userId;

      final otpCode = int.tryParse(otp.value);
      final body = {"userId": userId1, "otpCode": otpCode};
      final response = await ApiFetch().verifyOtp(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (_) {
      // Handle unexpected errors
    } finally {
      isVeifyOtp(false);
    }
    return false;
  }

  @override
  void onClose() {
    timer?.cancel();
    pinputController.dispose();
    super.onClose();
  }
}
