import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:health_guardian/models/emergency_event.dart';
import 'package:health_guardian/models/health_data.dart';

class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  factory OfflineService() => _instance;
  OfflineService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_guardian.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE emergency_events (
        id TEXT PRIMARY KEY,
        type TEXT,
        timestamp TEXT,
        details TEXT,
        status TEXT,
        location TEXT,
        notified_contacts TEXT,
        resolved_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE health_data (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        heart_rate REAL,
        oxygen_level REAL,
        stress_level REAL,
        facial_expression TEXT,
        voice_stress REAL,
        movement REAL,
        steps INTEGER,
        calories REAL,
        timestamp TEXT,
        additional_data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE emergency_contacts (
        id TEXT PRIMARY KEY,
        name TEXT,
        phone TEXT,
        relationship TEXT,
        is_primary INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_alerts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipient TEXT,
        message TEXT,
        location TEXT,
        created_at TEXT,
        sent INTEGER DEFAULT 0
      )
    ''');
  }

  // Save emergency event offline
  Future<void> saveEmergencyEvent(EmergencyEvent event) async {
    final db = await database;
    await db.insert(
      'emergency_events',
      {
        'id': event.id,
        'type': event.type.toString(),
        'timestamp': event.timestamp.toIso8601String(),
        'details': event.details,
        'status': event.status.toString(),
        'location': event.location?.toString(),
        'notified_contacts': event.notifiedContacts?.join(','),
        'resolved_at': event.resolvedAt?.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Save health data offline
  Future<void> saveHealthData(HealthData data) async {
    final db = await database;
    await db.insert(
      'health_data',
      {
        'heart_rate': data.heartRate,
        'oxygen_level': data.oxygenLevel,
        'stress_level': data.stressLevel,
        'facial_expression': data.facialExpression,
        'voice_stress': data.voiceStress,
        'movement': data.movement,
        'steps': data.steps,
        'calories': data.calories,
        'timestamp': data.timestamp.toIso8601String(),
        'additional_data': data.additionalData?.toString(),
      },
    );
  }

  // Queue alert for offline sending
  Future<void> queueAlert({
    required String recipient,
    required String message,
    Map<String, double>? location,
  }) async {
    final db = await database;
    await db.insert(
      'pending_alerts',
      {
        'recipient': recipient,
        'message': message,
        'location': location?.toString(),
        'created_at': DateTime.now().toIso8601String(),
        'sent': 0,
      },
    );
  }

  // Get pending alerts to send when online
  Future<List<Map<String, dynamic>>> getPendingAlerts() async {
    final db = await database;
    return await db.query(
      'pending_alerts',
      where: 'sent = ?',
      whereArgs: [0],
    );
  }

  // Mark alert as sent
  Future<void> markAlertAsSent(int id) async {
    final db = await database;
    await db.update(
      'pending_alerts',
      {'sent': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get recent health data for offline display
  Future<List<HealthData>> getRecentHealthData(int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_data',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) {
      return HealthData(
        heartRate: maps[i]['heart_rate'],
        oxygenLevel: maps[i]['oxygen_level'],
        stressLevel: maps[i]['stress_level'],
        facialExpression: maps[i]['facial_expression'],
        voiceStress: maps[i]['voice_stress'],
        movement: maps[i]['movement'],
        steps: maps[i]['steps'],
        calories: maps[i]['calories'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  // Get emergency history
  Future<List<EmergencyEvent>> getEmergencyHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emergency_events',
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return EmergencyEvent(
        id: maps[i]['id'],
        type: EmergencyType.values.firstWhere(
          (e) => e.toString() == maps[i]['type'],
        ),
        timestamp: DateTime.parse(maps[i]['timestamp']),
        details: maps[i]['details'],
        status: EmergencyStatus.values.firstWhere(
          (e) => e.toString() == maps[i]['status'],
        ),
        resolvedAt: maps[i]['resolved_at'] != null
            ? DateTime.parse(maps[i]['resolved_at'])
            : null,
      );
    });
  }

  // Clear old data to save space
  Future<void> clearOldData({int daysToKeep = 30}) async {
    final db = await database;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    
    await db.delete(
      'health_data',
      where: 'timestamp < ?',
      whereArgs: [cutoffDate.toIso8601String()],
    );
    
    await db.delete(
      'emergency_events',
      where: 'timestamp < ? AND status = ?',
      whereArgs: [cutoffDate.toIso8601String(), 'EmergencyStatus.resolved'],
    );
  }

  // Get database size
  Future<int> getDatabaseSize() async {
    final db = await database;
    final result = await db.rawQuery('PRAGMA page_count');
    final pageSize = await db.rawQuery('PRAGMA page_size');
    final pageCount = result.first['page_count'] as int;
    final sizePerPage = pageSize.first['page_size'] as int;
    return pageCount * sizePerPage;
  }
}
