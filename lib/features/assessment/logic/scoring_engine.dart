// lib/features/assessment/logic/scoring_engine.dart

import '../domain/models/assessment_model.dart';
import '../../result/domain/models/assessment_result_model.dart';

/// Medical scoring engine for calculating functional assessment results
/// 
/// Implements the scoring logic to determine patient severity level based on:
/// - Mobility (standing and walking capacity)
/// - Balance (dizziness and stability)
/// - General state (fatigue, pain)
/// 
/// Returns AssessmentLevel as: Level 1 (CRITIQUE), Level 2 (MODÉRÉ), Level 3 (BON)
class ScoringEngine {
  /// Calculate assessment result based on patient data
  /// 
  /// Scoring algorithm:
  /// - Each impaired mobility/balance factor increases risk score
  /// - Pain and fatigue add to risk score
  /// - Total score determines final assessment level
  static AssessmentResultModel calculateResult(AssessmentModel assessment) {
    int riskScore = 0;

    // Mobility assessment (Standing capacity)
    if (assessment.standingCapacity == MobilityAid.impossible) {
      riskScore += 3; // Critical mobility issue
    } else if (assessment.standingCapacity == MobilityAid.withAid) {
      riskScore += 2; // Moderate mobility issue
    }

    // Mobility assessment (Walking capacity)
    if (assessment.walkingCapacity == MobilityAid.impossible) {
      riskScore += 3; // Critical mobility issue
    } else if (assessment.walkingCapacity == MobilityAid.withAid) {
      riskScore += 2; // Moderate mobility issue
    }

    // Balance assessment (Dizziness)
    if (assessment.hasDizziness) {
      riskScore += 2;
    }

    // Balance assessment (Balance level)
    if (assessment.balanceLevel == BalanceLevel.unstable) {
      riskScore += 3; // Critical balance issue
    } else if (assessment.balanceLevel == BalanceLevel.moderate) {
      riskScore += 2; // Moderate balance issue
    }

    // General state (Fatigue)
    if (assessment.hasFatigue) {
      riskScore += 1;
    }

    // General state (Pain)
    if (assessment.painPresent) {
      riskScore += 1;
    }

    // Pain intensity adds to score
    if (assessment.painScore >= 7) {
      riskScore += 2; // High pain
    } else if (assessment.painScore >= 4) {
      riskScore += 1; // Moderate pain
    }

    // Determine level and create result model
    return _determineLevelAndCreateResult(riskScore);
  }

  /// Determine assessment level based on risk score and create result model
  static AssessmentResultModel _determineLevelAndCreateResult(int riskScore) {
    if (riskScore >= 10) {
      return const AssessmentResultModel(
        level: AssessmentLevel.level1,
        status: 'CRITIQUE',
        description:
            'Le patient présente un risque fonctionnel critique. Une intervention médicale immédiate est recommandée. '
            'Réduire l\'activité physique et consulter un professionnel de santé avant toute activité.',
        levelNumber: 1,
      );
    } else if (riskScore >= 5) {
      return const AssessmentResultModel(
        level: AssessmentLevel.level2,
        status: 'MODÉRÉ',
        description:
            'Le patient présente un risque fonctionnel modéré. Des exercices adaptés sont recommandés avec supervision. '
            'Augmenter progressivement l\'activité physique tout en surveillant les symptômes.',
        levelNumber: 2,
      );
    } else {
      return const AssessmentResultModel(
        level: AssessmentLevel.level3,
        status: 'BON',
        description:
            'Le patient présente une bonne capacité fonctionnelle. Les exercices réguliers sont recommandés pour maintenir la mobilité. '
            'Continuer une activité physique régulière adaptée à l\'âge et aux capacités.',
        levelNumber: 3,
      );
    }
  }
}
