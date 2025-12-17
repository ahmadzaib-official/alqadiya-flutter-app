import 'dart:io';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/network/dio_injector.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

class DioHelper {
  final Dio dio = getData();

  Map<String, dynamic> get defaultHeaders {
    final token =
        getx.Get.find<Preferences>().getString(AppStrings.accessToken) ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Options _buildOptions({bool isAuthRequired = false}) {
    return Options(
      receiveDataWhenStatusError: true,
      contentType: 'application/json',
      headers: isAuthRequired ? defaultHeaders : null,
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  //get
  Future<Response<dynamic>> get({
    required String url,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } on DioException {
      // Optionally log error here
      rethrow;
    }
  }

  //post
  Future<Response<dynamic>> post({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  //update
  Future<Response<dynamic>> put({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final response = await dio.put(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  //patch
  Future<Response<dynamic>> patch({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final response = await dio.patch(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // delete
  Future<Response<dynamic>> delete({
    required String url,
    Object? requestBody,
    bool isAuthRequired = false,
  }) async {
    try {
      final response = await dio.delete(
        url,
        data: requestBody,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // multipart
  Future<Response<dynamic>> multiPart({
    required String url,
    required Map<String, dynamic> fields,
    required List<File> files,
    String fileFieldName = 'file', // default field name
    bool isAuthRequired = false,
  }) async {
    try {
      FormData formData = FormData();
      //Add from fields
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
      // Add files
      for (var file in files) {
        String fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            fileFieldName,
            await MultipartFile.fromFile(file.path, filename: fileName),
          ),
        );
      }
      final response = await dio.post(
        url,
        data: formData,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
