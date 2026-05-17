enum EmergencyType {
  heartAttack,
  breathingDifficulty,
  fall,
  panicAttack,
  unconsciousness,
  manualRequest,
  abnormalHeartRate,
  lowOxygen,
  highStress,
  other,
}

enum EmergencyStatus {
  pending,
  active,
  resolved,
  cancelled,
}

class EmergencyEvent {
  final String id;
  final EmergencyType type;
  final DateTime timestamp;
  final String? details;
  EmergencyStatus status;
  final Map<String, dynamic>? location;
  final List<String>? notifiedContacts;
  final DateTime? resolvedAt;

  EmergencyEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    this.details,
    required this.status,
    this.location,
    this.notifiedContacts,
    this.resolvedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'details': details,
      'status': status.toString(),
      'location': location,
      'notifiedContacts': notifiedContacts,
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  factory EmergencyEvent.fromJson(Map<String, dynamic> json) {
    return EmergencyEvent(
      id: json['id'],
      type: EmergencyType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      timestamp: DateTime.parse(json['timestamp']),
      details: json['details'],
      status: EmergencyStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      location: json['location'] != null 
          ? Map<String, dynamic>.from(json['location']) 
          : null,
      notifiedContacts: json['notifiedContacts'] != null
          ? List<String>.from(json['notifiedContacts'])
          : null,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
    );
  }
}
