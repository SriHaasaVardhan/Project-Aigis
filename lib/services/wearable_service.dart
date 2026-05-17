import 'package:health/health.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class WearableService {
  static final WearableService _instance = WearableService._internal();
  factory WearableService() => _instance;
  WearableService._internal();

  final Health _health = Health();
  bool _isConnected = false;

  Future<bool> hasPermissions() async {
    final permissions = [
      Permission.activityRecognition,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ];

    for (final permission in permissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }

  Future<bool> requestPermissions() async {
    final permissions = [
      Permission.activityRecognition,
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ];

    final results = await permissions.request();
    return results.values.every((status) => status.isGranted);
  }

  Future<void> connect() async {
    if (!await hasPermissions()) {
      await requestPermissions();
    }

    // Try to connect to health services
    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];

    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    final bool requested = await _health.requestAuthorization(types, permissions: permissions);
    
    if (requested) {
      _isConnected = true;
    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
  }

  Future<Map<String, dynamic>> getData() async {
    if (!_isConnected) {
      return {
        'heartRate': null,
        'oxygenLevel': null,
        'steps': null,
        'calories': null,
      };
    }

    try {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Get heart rate
      List<HealthDataPoint> heartRateData = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.HEART_RATE],
      );

      // Get blood oxygen
      List<HealthDataPoint> oxygenData = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.BLOOD_OXYGEN],
      );

      // Get steps
      List<HealthDataPoint> stepsData = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: [HealthDataType.STEPS],
      );

      return {
        'heartRate': heartRateData.isNotEmpty 
            ? (heartRateData.last.value as NumericHealthValue).numericValue.toDouble() 
            : null,
        'oxygenLevel': oxygenData.isNotEmpty 
            ? (oxygenData.last.value as NumericHealthValue).numericValue.toDouble() 
            : null,
        'steps': stepsData.isNotEmpty 
            ? (stepsData.last.value as NumericHealthValue).numericValue.toInt() 
            : null,
      };
    } catch (e) {
      return {
        'heartRate': null,
        'oxygenLevel': null,
        'steps': null,
        'calories': null,
      };
    }
  }

  Future<List<BluetoothDevice>> scanForDevices() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      final results = await FlutterBluePlus.scanResults.first;
      await FlutterBluePlus.stopScan();
      return results.map((r) => r.device).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      return device.isConnected;
    } catch (e) {
      return false;
    }
  }
}
