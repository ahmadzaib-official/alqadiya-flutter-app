import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/widgets/spinkkit_ripple_efffect.dart'
    show SpinkitRipple;
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;
  var isGoogle = false.obs;
  var isVerify = false.obs;
  var isTermsAccepted = false.obs;
  var isEmailInput = false.obs;
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  var userId = ''.obs;
  var otpCode = 0.obs;
  var isEye = false.obs;
  var isEyeConfirm = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleEye() {
    isEye.value = !isEye.value;
  }

  void toggleTermsAccepted() {
    isTermsAccepted.value = !isTermsAccepted.value;
  }

  void toggleEyeConfirm() {
    isEyeConfirm.value = !isEyeConfirm.value;
  }

  void updatePhoneOrEmailInput(String value) {
    // Check if input contains @ symbol (email)
    isEmailInput.value = value.contains('@');
  }

  bool isValidEmailFormat(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return RegExp(
      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
    ).hasMatch(value);
  }

  bool isValidPhoneFormat(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    return value.length >= 7 &&
        value.length <= 10 &&
        RegExp(r'^\d+$').hasMatch(value);
  }

  Future<void> signUp() async {
    try {
      isLoading(true);
      // Map<String, String> body = {};
      // if (isEmailInput.value) {
      //   body = {
      //     "fullName": fullNameController.text.trim(),
      //     "email": phoneNumberController.text.trim(),
      //     "password": passwordController.text.trim(),
      //     "authProvider": "email",
      //   };
      // } else {
      Map<String, String> body = {
        "fullName": fullNameController.text.trim(),
        "phoneNumber": phoneNumberController.text.trim(),
        "callingCode": '+965',
        "countryCode": 'KW',
        "password": passwordController.text.trim(),
        "authProvider": "phone",
      };
      // }

      final response = await ApiFetch().signUp(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null) {
          userId.value = response.data['userId'];
          otpCode.value = response.data['otpCode'];
          // First clear any existing user data
          await Get.find<Preferences>().remove(AppStrings.userId);

          // await registerAndSendSMS(otpCode.value);
          // Only navigate after all data is saved
          Get.toNamed(
            AppRoutes.otpScreen,
            arguments: {
              'isRegister': true,
              'userId': userId.value,
              'phoneNumber': phoneNumberController.text.trim(),
              'email': phoneNumberController.text.trim(),
            },
          );

          clearField();
        }
      }
    } catch (e) {
      DebugPoint.log("Sign Up Error: $e");

      rethrow;
    } finally {
      isLoading(false);
    }
  }

  // Future<void> registerAndSendSMS(int otp) async {
  //   try {
  //     await ApiFetch().sendSMS(
  //       toPhoneNumber: phoneNumberController.text,
  //       message: otp,
  //     );
  //     DebugPoint.log('SMS sent successfully');
  //   } catch (e) {
  //     Get.snackbar('Error', 'An error occurred: ${e.toString()}');
  //   }
  // }

  Future<void> signUpWithGoogle() async {
    try {
      isGoogle.value = true;
      Get.dialog(Center(child: SpinkitRipple()), barrierDismissible: false);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return; // User canceled the sign-in
      }

      // Prepare the exact payload your backend expects
      final body = {
        "googleId": googleUser.id,
        "authProvider": "google",
        "fullName": googleUser.displayName ?? "Unknown User",
        "email": googleUser.email,
      };
      DebugPoint.log("Google Sign In Body: $body");
      final response = await ApiFetch().signUp(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null && response.data['accessToken'] != null) {
          // Store tokens securely
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
          // Navigate to dashboard
          Get.offAllNamed(AppRoutes.homescreen);
        }
      } else {
        throw Exception("Invalid response from server");
      }
    } catch (e) {
      // CustomSnackbar.showError("Google sign in failed: ${e.toString()}");

      DebugPoint.log(e);
    } finally {
      isGoogle.value = false;
      if (Get.isDialogOpen!) Get.back(); // Close dialog if still open
    }
  }

  Future<void> signUpWithApple() async {
    try {
      Get.dialog(Center(child: SpinkitRipple()), barrierDismissible: false);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      DebugPoint.log('-------${credential.familyName}');
      DebugPoint.log('-------${credential.email}');
      DebugPoint.log('-------${credential.givenName}');

      final body = {
        "appleId": credential.userIdentifier,
        "authProvider": "apple",
        "fullName":
            '${credential.givenName ?? ""} ${credential.familyName ?? ""}',
        "email": credential.email,
      };

      final response = await ApiFetch().signUp(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null && response.data['accessToken'] != null) {
          String userId = response.data['userId'];
          String assesToken = response.data['accessToken'];
          await Get.find<Preferences>().setString(AppStrings.userId, userId);
          await Get.find<Preferences>().setString(
            AppStrings.accessToken,
            assesToken,
          );
          await Get.find<Preferences>().setBool(AppStrings.isFirstRegister, true);
        }

        Get.back(); // Close progress dialog
        Get.offAllNamed(AppRoutes.homescreen);
      }
    } catch (e) {
      DebugPoint.log("Apple Sign In Error: $e");
      Get.back(); // Close progress dialog
      // CustomSnackbar.showError("Apple Sign up failed: ${e.toString()}");
    }
  }

  void clearField() {
    fullNameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
