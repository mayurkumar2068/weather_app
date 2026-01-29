import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Future<bool> requestLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        await openAppSettings();
        return false;
      }

      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  static Future<bool> requestNotificationPermission() async {
    try {
      PermissionStatus status = await Permission.notification.request();
      return status == PermissionStatus.granted;
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }
}