class EmergencyContact {
  final String id;
  final String name;
  final String phone;
  final String relationship;
  final bool isPrimary;
  final DateTime createdAt;

  EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
    this.isPrimary = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'isPrimary': isPrimary,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      relationship: json['relationship'],
      isPrimary: json['isPrimary'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
