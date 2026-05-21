class MedicalRecord {
  final int? id;
  final int userId;
  final String? diagnosis;
  final String? treatment;
  final String? notes;
  final DateTime recordDate;
  final DateTime? createdAt;

  MedicalRecord({
    this.id,
    required this.userId,
    this.diagnosis,
    this.treatment,
    this.notes,
    required this.recordDate,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'notes': notes,
      'record_date': recordDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      userId: map['user_id'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
      notes: map['notes'],
      recordDate: DateTime.parse(map['record_date']),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
