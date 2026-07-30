import 'dart:io';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/network/dio_injector.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter/material.dart';

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

  // Get current language for API requests
  Map<String, String> get languageQuery {
    String currentLang = getx.Get.find<Preferences>().getString(AppStrings.language) ?? '';
    if (currentLang.isEmpty) {
      currentLang = getx.Get.locale?.languageCode ?? WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    }
    return {'language': currentLang == 'ar' ? 'ar' : 'en'};
  }

  Options _buildOptions({bool isAuthRequired = false}) {
    return Options(
      receiveDataWhenStatusError: true,
      contentType: 'application/json',
      headers: isAuthRequired ? defaultHeaders : null,
      // sendTimeout: const Duration(seconds: 10),
      // receiveTimeout: const Duration(seconds: 10),
    );
  }

  //get
  Future<Response<dynamic>> get({
    required String url,
    bool isAuthRequired = false,
    Map<String, dynamic>? queryParameters,
    bool excludeLanguage = false, // Add this parameter
  }) async {
    try {
      // Merge language query with existing query parameters (only if not excluded)
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
      // Remove language parameter if excluded
      if (excludeLanguage) {
        mergedQueryParameters.remove('language');
      }
      
      final response = await dio.get(
        url,
        queryParameters: mergedQueryParameters,
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
    Map<String, dynamic>? queryParameters,
    bool excludeLanguage = false,
  }) async {
    try {
      // Merge language query with existing query parameters
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
      // Remove language parameter if excluded
      if (excludeLanguage) {
        mergedQueryParameters.remove('language');
      }
      
      final response = await dio.post(
        url,
        data: requestBody,
        queryParameters: mergedQueryParameters,
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
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Merge language query with existing query parameters
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
      final response = await dio.put(
        url,
        data: requestBody,
        queryParameters: mergedQueryParameters,
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
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Merge language query with existing query parameters
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
      final response = await dio.patch(
        url,
        data: requestBody,
        queryParameters: mergedQueryParameters,
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
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Merge language query with existing query parameters
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
      final response = await dio.delete(
        url,
        data: requestBody,
        queryParameters: mergedQueryParameters,
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
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // Merge language query with existing query parameters
      final mergedQueryParameters = Map<String, dynamic>.from(languageQuery);
      if (queryParameters != null) {
        mergedQueryParameters.addAll(queryParameters);
      }
      
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
        queryParameters: mergedQueryParameters,
        options: _buildOptions(isAuthRequired: isAuthRequired),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
