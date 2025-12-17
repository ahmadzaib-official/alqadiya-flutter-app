import 'package:alqadiya_game/core/debug/debug_point.dart';
import 'package:alqadiya_game/core/network/api_fetch.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  // Check and request location permissions
  Future<bool> _checkLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return false;
    }

    return true;
  }

  // Get current location coordinates
  Future getCurrentLocation() async {
    try {
      bool hasPermission = await _checkLocationPermissions();
      if (!hasPermission) return null;

      return await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  // Your existing update method with location fetching
  Future<bool> updateUserLocation(String name, String email) async {
    try {
      Position? position = await getCurrentLocation();
      if (position == null) return false;

      final body = {
        "fullName": name,
        "email": email,
        "isUpdatingAddress": true,
        "latitude": position.latitude,
        "longitude": position.longitude,
      };

      final response = await ApiFetch().updateProfile(body);
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      // Error already shown by interceptor
      DebugPoint.log(e);
      return false;
    } catch (e) {
      DebugPoint.log(e);
      return false;
    }
  }
}
