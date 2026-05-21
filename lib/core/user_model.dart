class User {
  final int? id;
  final String email;
  final String fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? phone;
  final String? address;
  final String? medicalHistory;
  final bool isActive;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    required this.email,
    required this.fullName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.address,
    this.medicalHistory,
    this.isActive = true,
    this.role = 'patient',
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'phone': phone,
      'address': address,
      'medical_history': medicalHistory,
      'is_active': isActive ? 1 : 0,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      fullName: map['full_name'],
      dateOfBirth: map['date_of_birth'],
      gender: map['gender'],
      phone: map['phone'],
      address: map['address'],
      medicalHistory: map['medical_history'],
      isActive: (map['is_active'] ?? 1) == 1,
      role: map['role'] ?? 'patient',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
