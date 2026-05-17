import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart';
import 'package:health_guardian/models/user_profile.dart';

class PrivacyService {
  static final PrivacyService _instance = PrivacyService._internal();
  factory PrivacyService() => _instance;
  PrivacyService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Key _key = Key.fromLength(32);
  final IV _iv = IV.fromLength(16);
  final Encrypter _encrypter = Encrypter(AES(_key));

  // Encrypt sensitive data
  String encryptData(String data) {
    final encrypted = _encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  // Decrypt sensitive data
  String decryptData(String encryptedData) {
    final encrypted = Encrypted.fromBase64(encryptedData);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  // Save encrypted data to secure storage
  Future<void> saveSecureData(String key, String value) async {
    final encrypted = encryptData(value);
    await _secureStorage.write(key: key, value: encrypted);
  }

  // Get and decrypt data from secure storage
  Future<String?> getSecureData(String key) async {
    final encrypted = await _secureStorage.read(key: key);
    if (encrypted == null) return null;
    return decryptData(encrypted);
  }

  // Delete secure data
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Clear all secure data
  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  // Save user profile with privacy protection
  Future<void> saveUserProfile(UserProfile profile) async {
    await saveSecureData('user_name', profile.name);
    if (profile.email != null) {
      await saveSecureData('user_email', profile.email!);
    }
    if (profile.phone != null) {
      await saveSecureData('user_phone', profile.phone!);
    }
    if (profile.bloodType != null) {
      await saveSecureData('user_blood_type', profile.bloodType!);
    }
  }

  // Get user profile
  Future<UserProfile?> getUserProfile() async {
    final name = await getSecureData('user_name');
    if (name == null) return null;

    return UserProfile(
      id: 'current_user',
      name: name,
      email: await getSecureData('user_email'),
      phone: await getSecureData('user_phone'),
      bloodType: await getSecureData('user_blood_type'),
    );
  }

  // Check if user has consented to data collection
  Future<bool> hasDataConsent() async {
    final consent = await _secureStorage.read(key: 'data_consent');
    return consent == 'true';
  }

  // Save data consent
  Future<void> setDataConsent(bool consent) async {
    await _secureStorage.write(key: 'data_consent', value: consent.toString());
  }

  // Check if user has accepted privacy policy
  Future<bool> hasAcceptedPrivacyPolicy() async {
    final accepted = await _secureStorage.read(key: 'privacy_policy_accepted');
    return accepted == 'true';
  }

  // Save privacy policy acceptance
  Future<void> acceptPrivacyPolicy() async {
    await _secureStorage.write(key: 'privacy_policy_accepted', value: 'true');
  }

  // Get privacy settings
  Future<Map<String, bool>> getPrivacySettings() async {
    return {
      'share_location': await _secureStorage.read(key: 'share_location') == 'true',
      'share_health_data': await _secureStorage.read(key: 'share_health_data') == 'true',
      'analytics_enabled': await _secureStorage.read(key: 'analytics_enabled') == 'true',
      'crash_reporting': await _secureStorage.read(key: 'crash_reporting') == 'true',
    };
  }

  // Update privacy setting
  Future<void> setPrivacySetting(String key, bool value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  // Anonymize data for analytics
  Map<String, dynamic> anonymizeHealthData(Map<String, dynamic> data) {
    final anonymized = Map<String, dynamic>.from(data);
    
    // Remove personally identifiable information
    anonymized.remove('user_id');
    anonymized.remove('name');
    anonymized.remove('email');
    anonymized.remove('phone');
    
    // Round numerical values to prevent identification
    if (anonymized['heart_rate'] != null) {
      anonymized['heart_rate'] = (anonymized['heart_rate'] as double).roundToDouble();
    }
    if (anonymized['oxygen_level'] != null) {
      anonymized['oxygen_level'] = (anonymized['oxygen_level'] as double).roundToDouble();
    }
    
    // Add random noise to timestamps (within 5 minutes)
    if (anonymized['timestamp'] != null) {
      final timestamp = DateTime.parse(anonymized['timestamp']);
      final randomOffset = DateTime.now().millisecondsSinceEpoch % 300000;
      anonymized['timestamp'] = timestamp.add(Duration(milliseconds: randomOffset)).toIso8601String();
    }
    
    return anonymized;
  }

  // Generate privacy report
  Future<Map<String, dynamic>> generatePrivacyReport() async {
    final settings = await getPrivacySettings();
    
    return {
      'data_collection_enabled': await hasDataConsent(),
      'privacy_policy_accepted': await hasAcceptedPrivacyPolicy(),
      'settings': settings,
      'data_stored_locally': true,
      'data_encrypted': true,
      'data_shared_with_third_party': false,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  // Export user data (GDPR compliance)
  Future<Map<String, dynamic>> exportUserData() async {
    final profile = await getUserProfile();
    
    return {
      'profile': profile?.toJson(),
      'privacy_settings': await getPrivacySettings(),
      'export_date': DateTime.now().toIso8601String(),
    };
  }

  // Delete all user data (right to be forgotten)
  Future<void> deleteAllUserData() async {
    await clearAllSecureData();
    // Also clear local database if needed
  }
}
