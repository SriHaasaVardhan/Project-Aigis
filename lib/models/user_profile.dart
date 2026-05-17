class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? bloodType;
  final List<String> allergies;
  final List<String> medicalConditions;
  final List<String> currentMedications;
  final String? emergencyContact;
  final String? emergencyContactPhone;
  final Map<String, dynamic>? medicalNotes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.bloodType,
    this.allergies = const [],
    this.medicalConditions = const [],
    this.currentMedications = const [],
    this.emergencyContact,
    this.emergencyContactPhone,
    this.medicalNotes,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'bloodType': bloodType,
      'allergies': allergies,
      'medicalConditions': medicalConditions,
      'currentMedications': currentMedications,
      'emergencyContact': emergencyContact,
      'emergencyContactPhone': emergencyContactPhone,
      'medicalNotes': medicalNotes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      bloodType: json['bloodType'],
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : [],
      medicalConditions: json['medicalConditions'] != null
          ? List<String>.from(json['medicalConditions'])
          : [],
      currentMedications: json['currentMedications'] != null
          ? List<String>.from(json['currentMedications'])
          : [],
      emergencyContact: json['emergencyContact'],
      emergencyContactPhone: json['emergencyContactPhone'],
      medicalNotes: json['medicalNotes'] != null
          ? Map<String, dynamic>.from(json['medicalNotes'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    final age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      return age - 1;
    }
    return age;
  }
}
