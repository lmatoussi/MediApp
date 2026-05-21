// lib/features/patient/domain/models/patient_model.dart

/// Enumeration for patient sex/gender
enum PatientSex {
  male,   // Homme
  female, // Femme
}

/// Patient identification model
/// 
/// Holds patient demographic information and assessment metadata.
/// All fields are immutable and non-nullable for safety.
class PatientModel {
  const PatientModel({
    required this.id,
    required this.name,
    required this.sex,
    required this.age,
    required this.avcDate,
  });

  /// Unique patient identifier
  final String id;

  /// Patient full name (Nom/Prénom)
  final String name;

  /// Patient sex (Homme or Femme)
  final PatientSex sex;

  /// Patient age in years
  final int age;

  /// Date of stroke (Date d'AVC) in format JJ/MM/YYYY
  final String avcDate;

  /// Create a copy with modified fields
  PatientModel copyWith({
    String? id,
    String? name,
    PatientSex? sex,
    int? age,
    String? avcDate,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      avcDate: avcDate ?? this.avcDate,
    );
  }

  @override
  String toString() => 'PatientModel(id: $id, name: $name, sex: $sex, age: $age, avcDate: $avcDate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          sex == other.sex &&
          age == other.age &&
          avcDate == other.avcDate;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ sex.hashCode ^ age.hashCode ^ avcDate.hashCode;
}
