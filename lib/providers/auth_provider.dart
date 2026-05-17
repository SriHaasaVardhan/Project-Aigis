import 'package:flutter/foundation.dart';
import 'package:health_guardian/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  String? _currentUserId;
  String? _currentUserName;
  String? _currentUserEmail;
  bool _isLoggedIn = false;

  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;
  String? get currentUserEmail => _currentUserEmail;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('current_user_id');
    _currentUserName = prefs.getString('current_user_name');
    _currentUserEmail = prefs.getString('current_user_email');
    _isLoggedIn = _currentUserId != null;
    notifyListeners();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final user = await _db.loginUser(email.trim(), password);
    if (user != null) {
      _currentUserId = user['id'] as String;
      _currentUserName = user['name'] as String;
      _currentUserEmail = user['email'] as String;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', _currentUserId!);
      await prefs.setString('current_user_name', _currentUserName!);
      await prefs.setString('current_user_email', _currentUserEmail!);
      notifyListeners();
      return {'success': true};
    }
    return {'success': false, 'error': 'Invalid email or password'};
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final exists = await _db.emailExists(userData['email']);
    if (exists) {
      return {'success': false, 'error': 'Email already registered'};
    }
    final success = await _db.registerUser(userData);
    if (success) {
      _currentUserId = userData['id'] as String;
      _currentUserName = userData['name'] as String;
      _currentUserEmail = userData['email'] as String;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_id', _currentUserId!);
      await prefs.setString('current_user_name', _currentUserName!);
      await prefs.setString('current_user_email', _currentUserEmail!);
      notifyListeners();
      return {'success': true};
    }
    return {'success': false, 'error': 'Registration failed'};
  }

  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    final exists = await _db.emailExists(email.trim());
    if (!exists) {
      return {'success': false, 'error': 'Email not found'};
    }
    final success = await _db.updatePassword(email.trim(), newPassword);
    if (success) {
      return {'success': true};
    }
    return {'success': false, 'error': 'Password reset failed'};
  }

  Future<void> logout() async {
    _currentUserId = null;
    _currentUserName = null;
    _currentUserEmail = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_id');
    await prefs.remove('current_user_name');
    await prefs.remove('current_user_email');
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (_currentUserId == null) return null;
    return await _db.getUserById(_currentUserId!);
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    if (_currentUserId == null) return false;
    data['updated_at'] = DateTime.now().toIso8601String();
    final success = await _db.updateUser(_currentUserId!, data);
    if (success && data.containsKey('name')) {
      _currentUserName = data['name'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_name', _currentUserName!);
      notifyListeners();
    }
    return success;
  }
}
