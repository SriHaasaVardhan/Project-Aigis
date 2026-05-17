import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  bool _isMonitoring = false;
  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;
  
  List<double> _accelerometerValues = [0, 0, 0];
  List<double> _gyroscopeValues = [0, 0, 0];
  
  DateTime? _lastMovementTime;
  double _movementScore = 0.0;

  Future<void> startMonitoring() async {
    _isMonitoring = true;
    _lastMovementTime = DateTime.now();
    
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _accelerometerValues = [event.x, event.y, event.z];
      _detectMovement();
    });
    
    _gyroscopeSubscription = gyroscopeEvents.listen((event) {
      _gyroscopeValues = [event.x, event.y, event.z];
      _detectMovement();
    });
  }

  Future<void> stopMonitoring() async {
    _isMonitoring = false;
    await _accelerometerSubscription?.cancel();
    await _gyroscopeSubscription?.cancel();
  }

  void _detectMovement() {
    final acceleration = _calculateAcceleration();
    final rotation = _calculateRotation();
    
    // Combined movement score
    _movementScore = (acceleration + rotation) / 2;
    
    if (_movementScore > 0.5) {
      _lastMovementTime = DateTime.now();
    }
  }

  double _calculateAcceleration() {
    final x = _accelerometerValues[0].abs();
    final y = _accelerometerValues[1].abs();
    final z = _accelerometerValues[2].abs();
    
    return (x + y + z) / 3;
  }

  double _calculateRotation() {
    final x = _gyroscopeValues[0].abs();
    final y = _gyroscopeValues[1].abs();
    final z = _gyroscopeValues[2].abs();
    
    return (x + y + z) / 3;
  }

  Future<Map<String, dynamic>> getData() async {
    final noMovementDuration = _lastMovementTime != null
        ? DateTime.now().difference(_lastMovementTime!).inSeconds
        : 0;
    
    return {
      'accelerometer': _accelerometerValues,
      'gyroscope': _gyroscopeValues,
      'movement': _movementScore,
      'noMovementDuration': noMovementDuration,
      'isFallDetected': _detectFall(),
    };
  }

  bool _detectFall() {
    // Fall detection algorithm
    // A fall is typically characterized by:
    // 1. Sudden high acceleration (impact)
    // 2. Followed by little to no movement
    
    final acceleration = _calculateAcceleration();
    
    // If acceleration is very high (impact detected)
    if (acceleration > 3.0) {
      // Check if movement is low after impact
      if (_movementScore < 0.2) {
        return true;
      }
    }
    
    return false;
  }

  bool isUserImmobile() {
    // Consider user immobile if no movement for 5 minutes
    final noMovementDuration = _lastMovementTime != null
        ? DateTime.now().difference(_lastMovementTime!).inSeconds
        : 0;
    
    return noMovementDuration > 300; // 5 minutes
  }
}
