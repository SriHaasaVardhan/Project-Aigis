import 'package:flutter/foundation.dart';
import 'package:health_guardian/models/health_data.dart';
import 'package:health_guardian/services/facial_analysis_service.dart';
import 'package:health_guardian/services/voice_analysis_service.dart';
import 'package:health_guardian/services/wearable_service.dart';
import 'package:health_guardian/services/sensor_service.dart';

class HealthMonitorProvider with ChangeNotifier {
  final FacialAnalysisService _facialService = FacialAnalysisService();
  final VoiceAnalysisService _voiceService = VoiceAnalysisService();
  final WearableService _wearableService = WearableService();
  final SensorService _sensorService = SensorService();
  
  HealthData _currentHealthData = HealthData();
  List<HealthData> _healthHistory = [];
  bool _isMonitoring = false;
  MonitoringStatus _status = MonitoringStatus.normal;
  
  HealthData get currentHealthData => _currentHealthData;
  List<HealthData> get healthHistory => _healthHistory;
  bool get isMonitoring => _isMonitoring;
  MonitoringStatus get status => _status;
  
  HealthMonitorProvider() {
    _loadHealthHistory();
  }
  
  Future<void> _loadHealthHistory() async {
    // Load from local storage
    _healthHistory = [];
    notifyListeners();
  }
  
  Future<void> startMonitoring() async {
    _isMonitoring = true;
    notifyListeners();
    
    // Start all monitoring services
    await _facialService.startMonitoring();
    await _voiceService.startMonitoring();
    await _wearableService.connect();
    await _sensorService.startMonitoring();
    
    // Continuous monitoring loop
    _monitoringLoop();
  }
  
  Future<void> stopMonitoring() async {
    _isMonitoring = false;
    notifyListeners();
    
    await _facialService.stopMonitoring();
    await _voiceService.stopMonitoring();
    await _wearableService.disconnect();
    await _sensorService.stopMonitoring();
  }
  
  Future<void> _monitoringLoop() async {
    while (_isMonitoring) {
      await Future.delayed(const Duration(seconds: 5));
      
      if (!_isMonitoring) break;
      
      // Collect data from all sources
      final facialData = await _facialService.analyze();
      final voiceData = await _voiceService.analyze();
      final wearableData = await _wearableService.getData();
      final sensorData = await _sensorService.getData();
      
      // Update current health data
      _currentHealthData = HealthData(
        heartRate: wearableData['heartRate'],
        oxygenLevel: wearableData['oxygenLevel'],
        stressLevel: facialData['stressLevel'] + voiceData['stressLevel'],
        facialExpression: facialData['expression'],
        voiceStress: voiceData['stressLevel'],
        movement: sensorData['movement'],
        timestamp: DateTime.now(),
      );
      
      // Analyze for emergencies
      _analyzeForEmergency();
      
      // Save to history
      _healthHistory.add(_currentHealthData);
      if (_healthHistory.length > 100) {
        _healthHistory.removeAt(0);
      }
      
      notifyListeners();
    }
  }
  
  void _analyzeForEmergency() {
    _status = MonitoringStatus.normal;
    
    // Check for heart rate anomalies
    if (_currentHealthData.heartRate != null) {
      if (_currentHealthData.heartRate! > 120 || _currentHealthData.heartRate! < 50) {
        _status = MonitoringStatus.warning;
      }
      if (_currentHealthData.heartRate! > 150 || _currentHealthData.heartRate! < 40) {
        _status = MonitoringStatus.critical;
      }
    }
    
    // Check for oxygen level
    if (_currentHealthData.oxygenLevel != null && _currentHealthData.oxygenLevel! < 90) {
      _status = MonitoringStatus.critical;
    }
    
    // Check for high stress
    if (_currentHealthData.stressLevel != null && _currentHealthData.stressLevel! > 0.8) {
      _status = MonitoringStatus.warning;
    }
    
    // Check for distress expressions
    if (_currentHealthData.facialExpression == 'distress' || 
        _currentHealthData.facialExpression == 'pain') {
      _status = MonitoringStatus.warning;
    }
    
    // Check for lack of movement (potential fall)
    if (_currentHealthData.movement != null && _currentHealthData.movement! < 0.1) {
      _status = MonitoringStatus.warning;
    }
    
    notifyListeners();
  }
  
  void updateHealthData(HealthData data) {
    _currentHealthData = data;
    _healthHistory.add(data);
    if (_healthHistory.length > 100) {
      _healthHistory.removeAt(0);
    }
    notifyListeners();
  }
}

enum MonitoringStatus {
  normal,
  warning,
  critical,
}
