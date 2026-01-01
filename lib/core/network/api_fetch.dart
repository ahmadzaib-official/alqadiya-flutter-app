import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

class ApiFetch extends GetxService {
  static final DioHelper _dioHelper = DioHelper();

  // Signup API
  Future<Response<dynamic>> signUp(Map<String, dynamic> body) async {
    final String url = ServerConfig.register;
    var response = await _dioHelper.post(
      url: url,
      requestBody: body,
      isAuthRequired: false, // Signup doesn't require auth
    );
    return response;
  }

  //verify Otp
  Future<Response<dynamic>> verifyOtp(Map<String, dynamic> body) async {
    final String url = ServerConfig.verifyOtp;
    var response = await _dioHelper.post(
      url: url,
      requestBody: body,
      isAuthRequired: false, // Signup doesn't require auth
    );
    return response;
  }

  //sendOtp
  Future<Response<dynamic>> sendOtp(Map<String, dynamic> body) async {
    final String url = ServerConfig.sendOtp;
    var response = await _dioHelper.post(
      url: url,
      requestBody: body,
      isAuthRequired: true,
    );
    return response;
  }

  // Signin API
  Future<Response<dynamic>> signIn(Map<String, dynamic> body) async {
    final String url = ServerConfig.login;
    var response = await _dioHelper.post(
      url: url,
      requestBody: body,
      isAuthRequired: false, // Signin doesn't require auth
    );
    return response;
  }

  // forgetPassword API
  Future<Response<dynamic>> forgetPassword(Map<String, dynamic> body) async {
    final String url = ServerConfig.forgetPassword;
    var response = await _dioHelper.post(
      url: url,
      requestBody: body,
      isAuthRequired: false, // Signin doesn't require auth
    );
    return response;
  }

  Future<Response<dynamic>> updateProfile(Map<String, dynamic> body) async {
    final String url = ServerConfig.updateProfile;
    var response = await _dioHelper.patch(
      url: url,
      requestBody: body,
      isAuthRequired: true,
    );
    return response;
  }

  Future<Response<dynamic>> getUserData() async {
    final String url = ServerConfig.currentUser;
    var response = await _dioHelper.get(url: url, isAuthRequired: true);
    return response;
  }

  Future<Response<dynamic>> deleteAccount() async {
    final String url = ServerConfig.deleteUser;
    var response = await _dioHelper.delete(url: url, isAuthRequired: true);
    return response;
  }

  Future<Response<dynamic>> resetPassword(Map<String, dynamic> body) async {
    final String url = ServerConfig.resetPassword;
    var response = await _dioHelper.patch(
      url: url,
      requestBody: body,
      isAuthRequired: true,
    );
    return response;
  }

  Future<Response<dynamic>> changePassword(Map<String, dynamic> body) async {
    final String url = ServerConfig.resetUserPassword;
    var response = await _dioHelper.patch(
      url: url,
      requestBody: body,
      isAuthRequired: true,
    );
    return response;
  }

  // Get photo upload link
  Future<Response<dynamic>> getPhotoUploadLink({required String fileType}) async {
    final String url = '${ServerConfig.uploadPhotoLink}?linkType=photo';
    var response = await _dioHelper.post(
      url: url,
      requestBody: {'fileType': fileType},
      isAuthRequired: true,
    );
    return response;
  }
}
