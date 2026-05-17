import 'package:flutter/foundation.dart';
import 'package:health_guardian/models/emergency_contact.dart';
import 'package:health_guardian/models/emergency_event.dart';
import 'package:health_guardian/services/location_service.dart';
import 'package:health_guardian/services/sms_service.dart';
import 'package:health_guardian/services/voice_assistant_service.dart';

class EmergencyProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final SMSService _smsService = SMSService();
  final VoiceAssistantService _voiceAssistant = VoiceAssistantService();
  
  List<EmergencyContact> _emergencyContacts = [];
  EmergencyEvent? _currentEmergency;
  bool _isEmergencyActive = false;
  bool _isMonitoring = true;
  int _confirmationTimer = 30;
  
  List<EmergencyContact> get emergencyContacts => _emergencyContacts;
  EmergencyEvent? get currentEmergency => _currentEmergency;
  bool get isEmergencyActive => _isEmergencyActive;
  bool get isMonitoring => _isMonitoring;
  int get confirmationTimer => _confirmationTimer;
  
  EmergencyProvider() {
    _loadEmergencyContacts();
  }
  
  Future<void> _loadEmergencyContacts() async {
    // Load from local storage
    _emergencyContacts = [];
    notifyListeners();
  }
  
  void addEmergencyContact(EmergencyContact contact) {
    _emergencyContacts.add(contact);
    notifyListeners();
  }
  
  void removeEmergencyContact(String id) {
    _emergencyContacts.removeWhere((c) => c.id == id);
    notifyListeners();
  }
  
  void toggleMonitoring() {
    _isMonitoring = !_isMonitoring;
    notifyListeners();
  }
  
  Future<void> triggerEmergency(EmergencyType type, {String? details}) async {
    if (!_isMonitoring) return;
    
    _currentEmergency = EmergencyEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      timestamp: DateTime.now(),
      details: details,
      status: EmergencyStatus.pending,
    );
    
    _isEmergencyActive = true;
    _confirmationTimer = 30;
    notifyListeners();
    
    // Start confirmation timer
    _startConfirmationTimer();
    
    // Voice alert
    await _voiceAssistant.speak('Emergency detected. Are you okay? Please respond within 30 seconds.');
  }
  
  void _startConfirmationTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isEmergencyActive) return false;
      
      _confirmationTimer--;
      notifyListeners();
      
      if (_confirmationTimer <= 0) {
        await _executeEmergencyResponse();
        return false;
      }
      
      return true;
    });
  }
  
  void confirmUserIsOkay() {
    _isEmergencyActive = false;
    _currentEmergency = null;
    _confirmationTimer = 30;
    notifyListeners();
  }
  
  Future<void> _executeEmergencyResponse() async {
    if (_currentEmergency == null) return;
    
    _currentEmergency!.status = EmergencyStatus.active;
    notifyListeners();
    
    // Get current location
    final location = await _locationService.getCurrentLocation();
    
    // Send alerts to emergency contacts
    for (final contact in _emergencyContacts) {
      await _smsService.sendEmergencyAlert(
        phoneNumber: contact.phone,
        message: _buildEmergencyMessage(_currentEmergency!, location),
        location: location,
      );
    }
    
    // Voice guidance
    await _voiceAssistant.speak('Emergency response activated. Help is on the way. Stay calm and follow the instructions.');
    
    // Call emergency services if configured
    // await _callEmergencyServices();
  }
  
  String _buildEmergencyMessage(EmergencyEvent event, Map<String, double>? location) {
    String message = 'EMERGENCY ALERT!\n\n';
    message += 'Type: ${event.type.toString().split('.').last}\n';
    message += 'Time: ${event.timestamp.toLocal()}\n';
    
    if (location != null) {
      message += 'Location: https://maps.google.com/?q=${location['latitude']},${location['longitude']}\n';
    }
    
    if (event.details != null) {
      message += 'Details: ${event.details}\n';
    }
    
    message += '\nPlease check on the user immediately.';
    return message;
  }
  
  Future<void> cancelEmergency() async {
    _isEmergencyActive = false;
    _currentEmergency = null;
    _confirmationTimer = 30;
    notifyListeners();
    
    await _voiceAssistant.speak('Emergency cancelled. Monitoring continues.');
  }
  
  Future<void> requestHelp() async {
    await triggerEmergency(EmergencyType.manualRequest, details: 'User requested help manually');
  }
}
