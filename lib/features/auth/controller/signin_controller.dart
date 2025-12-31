import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/widgets/spinkkit_ripple_efffect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInController extends GetxController {
  var isReadme = false.obs;
  var isSignIn = false.obs;
  var isVerify = false.obs;
  var isReset = false.obs;
  var isEye = false.obs;
  bool isEmailInput = false;
  var userId = ''.obs;
  var isLoading = false.obs;
  var newPasswordEye = false.obs;
  var confirmPasswordEye = false.obs;
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final phorgetPhoneNumberController = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  Future<void> enableLandscapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> enablePortraitMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void onClose() {
    // phoneNumberController.dispose();
    // passwordController.dispose();
    // newPassword.dispose();
    // confirmPassword.dispose();
    // phorgetPhoneNumberController.dispose();
    super.onClose();
  }

  void updatePhoneOrEmailInput(String value) {
    // Check if input contains @ symbol (email)
    isEmailInput = value.contains('@');
    update();
  }

  void toggleEye() {
    isEye.value = !isEye.value;
    update();
  }

  Future<void> signIn() async {
    try {
      isSignIn(true);
      // Map<String, String> body = {};
      // if (isEmailInput) {
      //   body = {
      //     "email": phoneNumberController.text.trim(),
      //     "password": passwordController.text.trim(),
      //     "authProvider": "email",
      //   };
      // } else {
      Map<String, String> body = {
        "phoneNumber": phoneNumberController.text.trim(),
        "callingCode": "+965",
        "countryCode": "KW",
        "password": passwordController.text.trim(),
        "authProvider": "phone",
      };
      // }
      final response = await ApiFetch().signIn(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data == 'Phone number not verified') {
          CustomSnackbar.showError(
            "Phone number not verified. Please verify your phone number.",
          );
          await verifyPhoneNumber();
          return;
        }
        if (response.data['userId'] != null &&
            response.data['accessToken'] != null) {
          String userId = response.data['userId'];
          String assesToken = response.data['accessToken'];
          await Get.find<Preferences>().setString(AppStrings.userId, userId);
          await Get.find<Preferences>().setString(
            AppStrings.accessToken,
            assesToken,
          );

          // Store refresh token if provided
          if (response.data['refreshToken'] != null) {
            await Get.find<Preferences>().setString(
              AppStrings.refreshToken,
              response.data['refreshToken'],
            );
          }
        }

        Get.back(); // Close progress dialog
        Get.find<Preferences>().remove(AppStrings.isGuest);
        // await SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight,
        // ]);

        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        Get.offAllNamed(AppRoutes.homescreen);
        clearField();
      }
    } catch (e) {
      Get.back(); // Close progress dialog
      CustomSnackbar.showError("Failed to sign in: ${e.toString()}");
    } finally {
      isSignIn(false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      Get.dialog(Center(child: SpinkitRipple()), barrierDismissible: false);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Get.back();
        return; // User canceled the sign-in
      }

      // Prepare the exact payload your backend expects
      final body = {"googleId": googleUser.id, "authProvider": "google"};
      DebugPoint.log("Google Sign In Body: $body");
      final response = await ApiFetch().signIn(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null &&
            response.data['accessToken'] != null) {
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
      CustomSnackbar.showError("Google sign in failed: ${e.toString()}");
      DebugPoint.log(e);
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen!) Get.back(); // Close dialog if still open
    }
  }

  Future<void> signInWithApple() async {
    try {
      Get.dialog(Center(child: SpinkitRipple()), barrierDismissible: false);

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final body = {
        "appleId": credential.userIdentifier,
        "authProvider": "apple",
      };

      final response = await ApiFetch().signIn(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null &&
            response.data['accessToken'] != null) {
          String userId = response.data['userId'];
          String assesToken = response.data['accessToken'];
          await Get.find<Preferences>().setString(AppStrings.userId, userId);
          await Get.find<Preferences>().setString(
            AppStrings.accessToken,
            assesToken,
          );
        }

        Get.back(); // Close progress dialogs
        Get.offAllNamed(AppRoutes.homescreen);
      }
    } catch (e) {
      Get.back(); // Close progress dialog
    }
  }

  Future<void> forgetPassword() async {
    try {
      isVerify(true);
      final body = {
        "phoneNumber": phorgetPhoneNumberController.text.trim(),
        "callingCode": '+965',
      };

      final response = await ApiFetch().forgetPassword(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null) {
          await Get.find<Preferences>().setString(
            AppStrings.userId,
            response.data['userId'],
          );
          // await registerAndSendSMS(response['otpCode']);
        }

        Get.offAllNamed(
          AppRoutes.otpScreen,
          arguments: {
            'phoneNumber': phoneNumberController.text,
            'userId': response.data['userId'] ?? '',
            'isForgotPassword': true,
          },
        );

        phoneNumberController.clear();
      }
    } finally {
      isVerify(false);
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
  //     // Get.snackbar('Error', 'An error occurred: ${e.toString()}');
  //   }
  // }

  Future<void> verifyPhoneNumber() async {
    try {
      isSignIn(true);
      final body = {
        "phoneNumber": phoneNumberController.text,
        "callingCode": '+965',
      };

      final response = await ApiFetch().forgetPassword(body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['userId'] != null) {
          await Get.find<Preferences>().setString(
            AppStrings.userId,
            response.data['userId'],
          );
        }

        Get.offAllNamed(
          AppRoutes.otpScreen,
          arguments: {
            'phoneNumber': phoneNumberController.text,
            'userId': response.data['userId'] ?? '',
            'isRegister': true,
          },
        );

        phoneNumberController.clear();
      }
    } finally {
      isSignIn(false);
    }
  }

  Future<void> resetPassword() async {
    try {
      isReset(true);

      final body = {
        "newPassword": newPassword.text,
        "confirmPassword": confirmPassword.text,
      };
      final response = await ApiFetch().resetPassword(body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back(); // Close progress dialog
        Get.toNamed(
          AppRoutes.verifcationSussesfulscreen,
          arguments: {
            // 'title': 'Password Created Successfully'.tr,
            // 'message':
            //     'Your new password is set. You can now log in to your account.'
            //         .tr,
            'title': 'Change password'.tr,
            'message': 'Password changed successfully'.tr,
            'isRegister': false,
          },
        );
        newPassword.clear();
        confirmPassword.clear();
      }
    } finally {
      isReset(false);
    }
  }

  void clearField() {
    passwordController.clear();
  }

  void toggleReadme(bool value) {
    isReadme.value = value;
    update();
  }
}
