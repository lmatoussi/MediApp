// lib/features/assessment/domain/models/assessment_model.dart

/// Enumeration for balance level assessment
enum BalanceLevel {
  stable,    // Stable
  moderate,  // Moyen
  unstable,  // Instable
}

/// Enumeration for mobility aid status
enum MobilityAid {
  withoutAid,  // Sans aide
  withAid,     // Avec aide
  impossible,  // Impossible
}

/// Assessment model containing all functional status data collected from patient
/// 
/// This model captures the complete assessment state for the medical evaluation.
/// All fields are required and immutable.
class AssessmentModel {
  const AssessmentModel({
    required this.standingCapacity,
    required this.walkingCapacity,
    required this.hasDizziness,
    required this.balanceLevel,
    required this.hasFatigue,
    required this.painPresent,
    required this.painScore,
  });

  // Mobilité (Mobility)
  /// Can patient stand without help (Position debout)
  final MobilityAid standingCapacity;

  /// Can patient walk without help (Marche)
  final MobilityAid walkingCapacity;

  // Équilibre (Balance)
  /// Does patient have dizziness (Vertiges)
  final bool hasDizziness;

  /// Patient's self-reported balance level (Équilibre)
  final BalanceLevel balanceLevel;

  // État général (General State)
  /// Does patient have fatigue (Fatigue)
  final bool hasFatigue;

  /// Does patient have pain (Douleur)
  final bool painPresent;

  /// Pain intensity from 0 to 10
  final int painScore;

  /// Create a copy with modified fields
  AssessmentModel copyWith({
    MobilityAid? standingCapacity,
    MobilityAid? walkingCapacity,
    bool? hasDizziness,
    BalanceLevel? balanceLevel,
    bool? hasFatigue,
    bool? painPresent,
    int? painScore,
  }) {
    return AssessmentModel(
      standingCapacity: standingCapacity ?? this.standingCapacity,
      walkingCapacity: walkingCapacity ?? this.walkingCapacity,
      hasDizziness: hasDizziness ?? this.hasDizziness,
      balanceLevel: balanceLevel ?? this.balanceLevel,
      hasFatigue: hasFatigue ?? this.hasFatigue,
      painPresent: painPresent ?? this.painPresent,
      painScore: painScore ?? this.painScore,
    );
  }

  @override
  String toString() =>
      'AssessmentModel(standing: $standingCapacity, walking: $walkingCapacity, '
      'dizziness: $hasDizziness, balance: $balanceLevel, fatigue: $hasFatigue, '
      'pain: $painPresent, painScore: $painScore)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentModel &&
          runtimeType == other.runtimeType &&
          standingCapacity == other.standingCapacity &&
          walkingCapacity == other.walkingCapacity &&
          hasDizziness == other.hasDizziness &&
          balanceLevel == other.balanceLevel &&
          hasFatigue == other.hasFatigue &&
          painPresent == other.painPresent &&
          painScore == other.painScore;

  @override
  int get hashCode =>
      standingCapacity.hashCode ^
      walkingCapacity.hashCode ^
      hasDizziness.hashCode ^
      balanceLevel.hashCode ^
      hasFatigue.hashCode ^
      painPresent.hashCode ^
      painScore.hashCode;
}
