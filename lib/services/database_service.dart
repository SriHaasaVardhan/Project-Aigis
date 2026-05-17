import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'aigis.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            name TEXT NOT NULL,
            phone TEXT,
            date_of_birth TEXT,
            blood_type TEXT,
            gender TEXT,
            height TEXT,
            weight TEXT,
            bio TEXT,
            allergies TEXT,
            medical_conditions TEXT,
            current_medications TEXT,
            emergency_contact_name TEXT,
            emergency_contact_phone TEXT,
            emergency_contact_relationship TEXT,
            medical_notes TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE medicine_reminders (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            medicine_name TEXT NOT NULL,
            dosage TEXT NOT NULL,
            frequency TEXT,
            reminder_hours TEXT NOT NULL,
            reminder_days TEXT NOT NULL,
            notes TEXT,
            is_active INTEGER DEFAULT 1,
            created_at TEXT NOT NULL,
            next_reminder TEXT,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE emergency_contacts (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            relationship TEXT,
            is_primary INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
      },
    );
  }

  // ==================== User Authentication ====================

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> registerUser(Map<String, dynamic> userData) async {
    final db = await database;
    try {
      await db.insert('users', userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> emailExists(String email) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return results.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    final db = await database;
    try {
      await db.update('users', data, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePassword(String email, String newPassword) async {
    final db = await database;
    try {
      await db.update(
        'users',
        {'password': newPassword},
        where: 'email = ?',
        whereArgs: [email],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Medicine Reminders ====================

  Future<List<Map<String, dynamic>>> getMedicineReminders(String userId) async {
    final db = await database;
    return await db.query(
      'medicine_reminders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<bool> addMedicineReminder(Map<String, dynamic> reminder) async {
    final db = await database;
    try {
      await db.insert('medicine_reminders', reminder);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMedicineReminder(String id, Map<String, dynamic> data) async {
    final db = await database;
    try {
      await db.update('medicine_reminders', data, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMedicineReminder(String id) async {
    final db = await database;
    try {
      await db.delete('medicine_reminders', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleMedicineReminder(String id, bool isActive) async {
    final db = await database;
    try {
      await db.update(
        'medicine_reminders',
        {'is_active': isActive ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Emergency Contacts ====================

  Future<List<Map<String, dynamic>>> getEmergencyContacts(String userId) async {
    final db = await database;
    return await db.query(
      'emergency_contacts',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'is_primary DESC, created_at DESC',
    );
  }

  Future<bool> addEmergencyContact(Map<String, dynamic> contact) async {
    final db = await database;
    try {
      await db.insert('emergency_contacts', contact);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteEmergencyContact(String id) async {
    final db = await database;
    try {
      await db.delete('emergency_contacts', where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==================== Cleanup ====================

  Future<void> deleteUserData(String userId) async {
    final db = await database;
    await db.delete('medicine_reminders', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('emergency_contacts', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}
