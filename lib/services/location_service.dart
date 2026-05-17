import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<bool> hasPermission() async {
    return await Permission.location.isGranted;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      if (!await hasPermission()) {
        await requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      return null;
    }
  }

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      final placemark = placemarks.first;
      
      return '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}';
    } catch (e) {
      return 'Unknown location';
    }
  }

  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
