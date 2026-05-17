import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences? _prefs;
  
  bool _notificationsEnabled = true;
  bool _voiceAssistantEnabled = true;
  bool _wearableIntegrationEnabled = true;
  bool _facialAnalysisEnabled = true;
  bool _voiceAnalysisEnabled = true;
  bool _darkMode = false;
  String _language = 'en';
  int _emergencyConfirmationTime = 30;
  bool _autoCallEmergency = false;
  String _emergencyPhoneNumber = '108';
  
  bool get notificationsEnabled => _notificationsEnabled;
  bool get voiceAssistantEnabled => _voiceAssistantEnabled;
  bool get wearableIntegrationEnabled => _wearableIntegrationEnabled;
  bool get facialAnalysisEnabled => _facialAnalysisEnabled;
  bool get voiceAnalysisEnabled => _voiceAnalysisEnabled;
  bool get darkMode => _darkMode;
  String get language => _language;
  int get emergencyConfirmationTime => _emergencyConfirmationTime;
  bool get autoCallEmergency => _autoCallEmergency;
  String get emergencyPhoneNumber => _emergencyPhoneNumber;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    _notificationsEnabled = _prefs?.getBool('notifications_enabled') ?? true;
    _voiceAssistantEnabled = _prefs?.getBool('voice_assistant_enabled') ?? true;
    _wearableIntegrationEnabled = _prefs?.getBool('wearable_enabled') ?? true;
    _facialAnalysisEnabled = _prefs?.getBool('facial_analysis_enabled') ?? true;
    _voiceAnalysisEnabled = _prefs?.getBool('voice_analysis_enabled') ?? true;
    _darkMode = _prefs?.getBool('dark_mode') ?? false;
    _language = _prefs?.getString('language') ?? 'en';
    _emergencyConfirmationTime = _prefs?.getInt('emergency_confirmation_time') ?? 30;
    _autoCallEmergency = _prefs?.getBool('auto_call_emergency') ?? false;
    _emergencyPhoneNumber = _prefs?.getString('emergency_phone') ?? '108';
    
    notifyListeners();
  }
  
  Future<void> _saveSetting(String key, dynamic value) async {
    await _prefs?.setBool(key, value as bool);
    notifyListeners();
  }
  
  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    _prefs?.setBool('notifications_enabled', value);
    notifyListeners();
  }
  
  void toggleVoiceAssistant(bool value) {
    _voiceAssistantEnabled = value;
    _prefs?.setBool('voice_assistant_enabled', value);
    notifyListeners();
  }
  
  void toggleWearableIntegration(bool value) {
    _wearableIntegrationEnabled = value;
    _prefs?.setBool('wearable_enabled', value);
    notifyListeners();
  }
  
  void toggleFacialAnalysis(bool value) {
    _facialAnalysisEnabled = value;
    _prefs?.setBool('facial_analysis_enabled', value);
    notifyListeners();
  }
  
  void toggleVoiceAnalysis(bool value) {
    _voiceAnalysisEnabled = value;
    _prefs?.setBool('voice_analysis_enabled', value);
    notifyListeners();
  }
  
  void toggleDarkMode(bool value) {
    _darkMode = value;
    _prefs?.setBool('dark_mode', value);
    notifyListeners();
  }
  
  void setLanguage(String value) {
    _language = value;
    _prefs?.setString('language', value);
    notifyListeners();
  }
  
  void setEmergencyConfirmationTime(int value) {
    _emergencyConfirmationTime = value;
    _prefs?.setInt('emergency_confirmation_time', value);
    notifyListeners();
  }
  
  void toggleAutoCallEmergency(bool value) {
    _autoCallEmergency = value;
    _prefs?.setBool('auto_call_emergency', value);
    notifyListeners();
  }
  
  void setEmergencyPhoneNumber(String value) {
    _emergencyPhoneNumber = value;
    _prefs?.setString('emergency_phone', value);
    notifyListeners();
  }
}
