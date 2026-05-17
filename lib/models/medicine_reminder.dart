class MedicineReminder {
  final String id;
  final String medicineName;
  final String dosage;
  final List<int> reminderHours; // Hours of the day (0-23)
  final List<int> reminderDays; // Days of the week (1-7, 1=Monday)
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? nextReminder;

  MedicineReminder({
    required this.id,
    required this.medicineName,
    required this.dosage,
    required this.reminderHours,
    required this.reminderDays,
    this.notes,
    this.isActive = true,
    DateTime? createdAt,
    this.nextReminder,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'dosage': dosage,
      'reminderHours': reminderHours,
      'reminderDays': reminderDays,
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'nextReminder': nextReminder?.toIso8601String(),
    };
  }

  factory MedicineReminder.fromJson(Map<String, dynamic> json) {
    return MedicineReminder(
      id: json['id'],
      medicineName: json['medicineName'],
      dosage: json['dosage'],
      reminderHours: List<int>.from(json['reminderHours']),
      reminderDays: List<int>.from(json['reminderDays']),
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      nextReminder: json['nextReminder'] != null
          ? DateTime.parse(json['nextReminder'])
          : null,
    );
  }
}
