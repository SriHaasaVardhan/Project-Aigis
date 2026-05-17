import 'package:flutter/foundation.dart';
import 'package:health_guardian/services/database_service.dart';

class MedicineProvider with ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  List<Map<String, dynamic>> _reminders = [];
  String? _userId;

  List<Map<String, dynamic>> get reminders => _reminders;

  void setUserId(String userId) {
    _userId = userId;
    loadReminders();
  }

  Future<void> loadReminders() async {
    if (_userId == null) return;
    _reminders = await _db.getMedicineReminders(_userId!);
    notifyListeners();
  }

  Future<bool> addReminder({
    required String name,
    required String dosage,
    String? frequency,
    required List<int> hours,
    required List<int> days,
    String? notes,
  }) async {
    if (_userId == null) return false;
    final reminder = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': _userId!,
      'medicine_name': name,
      'dosage': dosage,
      'frequency': frequency ?? 'Daily',
      'reminder_hours': hours.join(','),
      'reminder_days': days.join(','),
      'notes': notes,
      'is_active': 1,
      'created_at': DateTime.now().toIso8601String(),
    };
    final success = await _db.addMedicineReminder(reminder);
    if (success) await loadReminders();
    return success;
  }

  Future<bool> deleteReminder(String id) async {
    final success = await _db.deleteMedicineReminder(id);
    if (success) await loadReminders();
    return success;
  }

  Future<bool> toggleReminder(String id, bool isActive) async {
    final success = await _db.toggleMedicineReminder(id, isActive);
    if (success) await loadReminders();
    return success;
  }
}
