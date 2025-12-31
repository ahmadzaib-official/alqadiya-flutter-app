import 'dart:convert';
import 'dart:developer';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/constants/server_config.dart';
import 'package:alqadiya_game/core/network/app_exceptions.dart';
import 'package:alqadiya_game/core/routes/app_routes.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/features/auth/controller/signin_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../debug/debug_point.dart';

class DioErrorHandler {
  static bool isErrorSnackbarShowing = false;
}

Dio getData() {
  final Dio dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        try {
          DebugPoint.log('➡️ [${options.method}] API URL: ${options.uri}');
          DebugPoint.log('📦 HEADER: ${options.headers}');
          DebugPoint.log('📝 REQUEST BODY: ${jsonEncode(options.data)}');
          return handler.next(options);
        } catch (e) {
          log('Request error $e');
          handler.reject(
            DioException(
              requestOptions: options,
              error: NetworkException(
                'Failed to make request: ${e.toString()}',
              ),
            ),
          );
        }
      },
      onResponse: (response, handler) {
        try {
          DebugPoint.log(
            '✅ [${response.requestOptions.method}] API RESPONSE: ${response.data}',
          );
          return handler.next(response);
        } catch (e) {
          log('Response error $e');
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              error: UnauthorizedException('Authentication failed'),
            ),
          );
        }
      },
      onError: (DioException err, handler) async {
        try {
          final statusCode = err.response?.statusCode ?? 0;
          final errorMessage = _extractErrorMessage(err);

          DebugPoint.log(
            '❌ [${err.requestOptions.method}] STATUS CODE: $statusCode',
          );
          DebugPoint.log('🧨 ERROR TYPE: ${err.type}');
          DebugPoint.log('📢 ERROR MESSAGE: $errorMessage');
          DebugPoint.log('🔍 ERROR DATA: ${err.response?.data ?? ''}');

          // Handle 401 Unauthorized - Try to refresh token
          if (statusCode == 401) {
            final requestOptions = err.requestOptions;

            // Prevent refresh loop
            if (requestOptions.extra['retry'] == true) {
              // Already retried once → force logout
              await _clearStorage();
              if (!DioErrorHandler.isErrorSnackbarShowing) {
                DioErrorHandler.isErrorSnackbarShowing = true;
                _handleErrorDisplay(err, statusCode, errorMessage);
                Future.delayed(const Duration(seconds: 2), () {
                  DioErrorHandler.isErrorSnackbarShowing = false;
                });
              }
              _handleUnauthorized();
              handler.reject(
                DioException(
                  requestOptions: requestOptions,
                  error: UnauthorizedException("Session expired"),
                ),
              );
              return;
            }

            // Ignore login or refresh endpoints
            if (requestOptions.path.contains('/signIn') ||
                requestOptions.path.contains('/signUp') ||
                requestOptions.path.contains('/refreshToken')) {
              if (!DioErrorHandler.isErrorSnackbarShowing) {
                DioErrorHandler.isErrorSnackbarShowing = true;
                _handleErrorDisplay(err, statusCode, errorMessage);
                Future.delayed(const Duration(seconds: 2), () {
                  DioErrorHandler.isErrorSnackbarShowing = false;
                });
              }
              final error = _handleDioError(err);
              handler.reject(
                DioException(requestOptions: err.requestOptions, error: error),
              );
              return;
            }

            log("⚠️ Token expired → Refreshing token...");

            try {
              // Call refresh token
              final newAccessToken = await _refreshToken();

              if (newAccessToken == null || newAccessToken.isEmpty) {
                log("❌ Refresh token returned NULL / EMPTY");
                await _clearStorage();
                _handleUnauthorized();
                handler.reject(
                  DioException(
                    requestOptions: requestOptions,
                    error: UnauthorizedException("Session expired"),
                  ),
                );
                return;
              }

              // Mark request as retried
              requestOptions.extra['retry'] = true;

              // Update header with new token
              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              log("🔄 Retrying original request → ${requestOptions.uri}");

              // Retry original request
              final response = await dio.fetch(requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              log("❌ Refresh failed: $e");
              await _clearStorage();
              _handleUnauthorized();
              handler.reject(
                DioException(
                  requestOptions: requestOptions,
                  error: UnauthorizedException("Session expired"),
                ),
              );
              return;
            }
          }

          // Handle other errors
          if (!DioErrorHandler.isErrorSnackbarShowing) {
            DioErrorHandler.isErrorSnackbarShowing = true;
            _handleErrorDisplay(err, statusCode, errorMessage);
            Future.delayed(const Duration(seconds: 2), () {
              DioErrorHandler.isErrorSnackbarShowing = false;
            });
          }

          _handleSpecificStatusCodes(statusCode);

          final error = _handleDioError(err);
          handler.reject(
            DioException(requestOptions: err.requestOptions, error: error),
          );
        } catch (e) {
          log("❌ Error handler failed: $e");

          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              error: UnauthorizedException("Session expired"),
            ),
          );
        }
      },
    ),
  );

  return dio;
}

/// Refresh the access token using the refresh token
Future<String?> _refreshToken() async {
  try {
    final preferences = Get.find<Preferences>();
    final refreshToken = preferences.getString(AppStrings.refreshToken);

    if (refreshToken == null || refreshToken.isEmpty) {
      log("❌ No refresh token found");
      return null;
    }

    // Create a new Dio instance without interceptors to avoid infinite loop
    final refreshDio = Dio();

    final response = await refreshDio.post(
      ServerConfig.refreshToken,
      data: {'refreshToken': refreshToken},
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data;

      if (data['accessToken'] != null) {
        final newAccessToken = data['accessToken'] as String;

        // Update access token in preferences
        await preferences.setString(AppStrings.accessToken, newAccessToken);

        // Update refresh token if provided
        if (data['refreshToken'] != null) {
          await preferences.setString(
            AppStrings.refreshToken,
            data['refreshToken'] as String,
          );
        }

        log("✅ Token refreshed successfully");
        return newAccessToken;
      }
    }

    log("❌ Invalid refresh token response");
    return null;
  } catch (e) {
    log("❌ Refresh token error: $e");
    return null;
  }
}

/// Clear storage and logout user
Future<void> _clearStorage() async {
  try {
    final preferences = Get.find<Preferences>();
    await preferences.remove(AppStrings.accessToken);
    await preferences.remove(AppStrings.refreshToken);
    await preferences.remove(AppStrings.userId);
  } catch (e) {
    log("Error clearing storage: $e");
  }
}

AppException _handleDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkException('Connection timeout');
    case DioExceptionType.badResponse:
      switch (error.response?.statusCode) {
        case 400:
          return ValidationException(
            error.response?.data['message'] ?? 'Invalid request',
            data: error.response?.data,
          );
        case 401:
          return UnauthorizedException(
            error.response?.data['message'] ?? 'Unauthorized',
            data: error.response?.data,
          );
        case 403:
          return UnauthorizedException(
            error.response?.data['message'] ?? 'Access denied',
            data: error.response?.data,
          );
        case 404:
          return ServerException(
            error.response?.data['message'] ?? 'Resource not found',
            data: error.response?.data,
          );
        case 500:
        case 502:
        case 503:
          return ServerException(
            error.response?.data['message'] ?? 'Server error',
            data: error.response?.data,
          );
        default:
          return ServerException(
            error.response?.data['message'] ?? 'Unknown error occurred',
            data: error.response?.data,
          );
      }
    case DioExceptionType.cancel:
      return NetworkException('Request cancelled');
    case DioExceptionType.unknown:
      if (error.error is NetworkException) {
        return NetworkException('No internet connection');
      }
      return ServerException('Unknown error occurred');
    default:
      return ServerException('Unknown error occurred');
  }
}

String _extractErrorMessage(DioException e) {
  final data = e.response?.data;

  if (data == null) return 'Something went wrong';

  // Case 1: If `message` key exists
  if (data is Map<String, dynamic>) {
    final rawMessage = data['message'];

    if (rawMessage is String) {
      return rawMessage.replaceAll(RegExp(r'[\[\]]'), '').trim();
    } else if (rawMessage is List && rawMessage.isNotEmpty) {
      return rawMessage.first
          .toString()
          .replaceAll(RegExp(r'[\[\]]'), '')
          .trim();
    }
  }

  // Case 2: Direct List response
  if (data is List && data.isNotEmpty) {
    return data.first.toString().replaceAll(RegExp(r'[\[\]]'), '').trim();
  }

  return 'Something went wrong';
}

void _handleErrorDisplay(DioException e, int statusCode, String errorMessage) {
  if (errorMessage == 'Phone number not verified') {
    Future.delayed(Duration.zero, () {
      Get.find<SignInController>().verifyPhoneNumber();
    });
    return;
  }

  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    Future.delayed(Duration.zero, () {
      CustomSnackbar.showError(
        'Connection error. Please check your internet connection',
      );
    });
    return;
  }

  if (statusCode >= 500 && statusCode < 600) {
    Future.delayed(Duration.zero, () {
      CustomSnackbar.showError('Server error occurred. Please try again later');
    });
    return;
  }

  // 🔥 Always delayed to ensure UI is ready21
  Future.delayed(Duration.zero, () {
    CustomSnackbar.showError(errorMessage);
  });
}

void _handleSpecificStatusCodes(int statusCode) {
  switch (statusCode) {
    case 400:
      // Bad Request - Client sent an invalid request
      break;
    case 401:
      // Unauthorized - Token expired or not provided
      _handleUnauthorized();
      break;
    case 403:
      // Forbidden - You don't have permission to access this resource
      break;
    case 404:
      // Not Found - API endpoint not found
      break;
    case 409:
      // Conflict - Duplicate data or resource conflict
      break;
    case 422:
      // Unprocessable Entity - Validation error
      break;
    // Other cases can be added as needed
  }
}

void _handleUnauthorized() async {
  try {
    // Example logout logic
    Get.find<Preferences>().logout();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Get.offAllNamed(AppRoutes.sigin);
  } catch (e) {
    DebugPoint.log('Error during logout: $e');
  }
}
