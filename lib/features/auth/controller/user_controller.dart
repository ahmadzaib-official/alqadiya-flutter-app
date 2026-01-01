import 'dart:convert';
import 'dart:io';
import 'package:alqadiya_game/core/constants/app_strings.dart';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:alqadiya_game/core/services/prefferences.dart';
import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/features/auth/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  var isUpdatingProfile = false.obs;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  Future<void> getUserData() async {
    try {
      final prefs = Get.find<Preferences>();
      final isGuest = prefs.getBool(AppStrings.isGuest) ?? false;

      if (isGuest) {
        isLoading(false);
        return;
      }
      isLoading(true);
      final response = await ApiFetch().getUserData();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = UserModel.fromJson(response.data);
        user.value = userData;
      }
    } on DioException {
      // Error already shown by interceptor
    } catch (e) {
      CustomSnackbar.showError("Failed to load user data: ${e.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Upload photo to S3 and get uploadId
  Future<String?> uploadPhotoToS3(File imageFile) async {
    try {
      // Determine file type from file extension
      final fileType = _getMimeType(imageFile.path);
      
      // Get upload link from API
      final uploadLinkResponse = await ApiFetch().getPhotoUploadLink(
        fileType: fileType,
      );

      if (uploadLinkResponse.statusCode != 200 &&
          uploadLinkResponse.statusCode != 201) {
        CustomSnackbar.showError('Failed to get upload link');
        return null;
      }

      final uploadData = uploadLinkResponse.data;
      final uploadId = uploadData['uploadId'] as String;
      final fields = uploadData['fields'] as Map<String, dynamic>;
      final key = fields['key'] as String;

      DebugPoint.log('Upload ID: $uploadId');
      DebugPoint.log('Upload Key from API: $key');
      DebugPoint.log('Full Upload Data: $uploadData');

      // Upload to S3 using http package
      final success = await _uploadToS3(uploadData, imageFile);
      
      if (success) {
        DebugPoint.log('✅ Photo uploaded successfully, uploadId: $uploadId');
        return uploadId;
      } else {
        CustomSnackbar.showError('Failed to upload photo to S3');
        return null;
      }
    } on DioException catch (e) {
      DebugPoint.log('DioException during upload: ${e.message}');
      CustomSnackbar.showError('Failed to get upload link: ${e.message}');
      return null;
    } catch (e) {
      DebugPoint.log('Exception during upload: $e');
      CustomSnackbar.showError("Failed to upload photo: ${e.toString()}");
      return null;
    }
  }

  /// Upload file to S3 using presigned POST
  Future<bool> _uploadToS3(Map<String, dynamic> uploadData, File file) async {
    try {
      final String uploadUrl = uploadData['url'];
      final Map<String, dynamic> fields = uploadData['fields'];
      final String fileKey = fields['key'] as String;
      final String ext = fileKey.split('.').last.toLowerCase();

      // Decode Policy to check what key it expects
      try {
        final policyBase64 = fields['Policy'] as String;
        final policyJson = utf8.decode(base64Decode(policyBase64));
        DebugPoint.log('Policy JSON: $policyJson');
      } catch (e) {
        DebugPoint.log('Could not decode Policy: $e');
      }

      DebugPoint.log('S3 Upload - Key from API: $fileKey');
      DebugPoint.log('S3 Upload - URL: $uploadUrl');
      DebugPoint.log('S3 Upload - All Fields: $fields');

      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      // Add required S3 form fields (use exact key from response - cannot modify due to Policy signature)
      request.fields.addAll({
        'key': fileKey, // Must use exact key from API (Policy is signed with this key)
        'bucket': fields['bucket'],
        'X-Amz-Algorithm': fields['X-Amz-Algorithm'],
        'X-Amz-Credential': fields['X-Amz-Credential'],
        'X-Amz-Date': fields['X-Amz-Date'],
        'Policy': fields['Policy'],
        'X-Amz-Signature': fields['X-Amz-Signature'],
        'Content-Type': 'image/$ext',
      });

      // Add the actual file
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', ext),
        ),
      );

      DebugPoint.log('Sending S3 upload request...');
      final response = await request.send();
      final success = response.statusCode == 200 || response.statusCode == 204;
      
      if (success) {
        DebugPoint.log('✅ Uploaded successfully: ${file.path}');
        DebugPoint.log('✅ Uploaded to S3 key: $fileKey');
      } else {
        DebugPoint.log('❌ Upload failed with status: ${response.statusCode}');
        final responseBody = await response.stream.bytesToString();
        DebugPoint.log('❌ Error Response: $responseBody');
      }
      return success;
    } catch (e) {
      DebugPoint.log('uploadToS3 Error: $e');
      return false;
    }
  }

  /// Helper: detect MIME type
  String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
        return 'image/jpg';
      case 'jpeg':
        return 'image/jpeg';
      default:
        return 'image/jpeg';
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? callingCode,
    String? countryCode,
    String? photoId,
    String? password,
    int? otpCode,
  }) async {
    try {
      isUpdatingProfile(true);

      final body = <String, dynamic>{};
      if (fullName != null && fullName.isNotEmpty) {
        body['fullName'] = fullName;
      }
      if (email != null && email.isNotEmpty) {
        body['email'] = email;
      }
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        body['phoneNumber'] = phoneNumber;
      }
      if (callingCode != null && callingCode.isNotEmpty) {
        body['callingCode'] = callingCode;
      }
      if (countryCode != null && countryCode.isNotEmpty) {
        body['countryCode'] = countryCode;
      }
      if (photoId != null && photoId.isNotEmpty) {
        body['photoId'] = photoId;
      }
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }
      if (otpCode != null) {
        body['otpCode'] = otpCode;
      }

      // Ensure at least one field is being updated
      if (body.isEmpty) {
        CustomSnackbar.showError('Please update at least one field');
        isUpdatingProfile(false);
        return false;
      }

      print('Update profile body: $body');
      final response = await ApiFetch().updateProfile(body);
      print('Update profile response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh user data
        await getUserData();
        CustomSnackbar.showSuccess('Profile updated successfully');
        return true;
      }
      return false;
    } on DioException {
      // Error already shown by interceptor
      return false;
    } catch (e) {
      CustomSnackbar.showError("Failed to update profile: ${e.toString()}");
      return false;
    } finally {
      isUpdatingProfile(false);
    }
  }
}
