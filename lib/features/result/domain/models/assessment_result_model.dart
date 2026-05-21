// lib/features/result/domain/models/assessment_result_model.dart

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Assessment severity level
enum AssessmentLevel {
  level1, // Niveau 1 - CRITIQUE
  level2, // Niveau 2 - MODÉRÉ
  level3, // Niveau 3 - BON
}

/// Result of medical assessment calculation
/// 
/// Contains the level determination and related metadata for display.
class AssessmentResultModel {
  const AssessmentResultModel({
    required this.level,
    required this.status,
    required this.description,
    required this.levelNumber,
  });

  /// Severity level (1, 2, or 3)
  final AssessmentLevel level;

  /// Human-readable status text (CRITIQUE, MODÉRÉ, BON)
  final String status;

  /// French medical description and recommendations
  final String description;

  /// Level as integer (1, 2, or 3)
  final int levelNumber;

  /// Get level color based on severity
  Color get color {
    switch (level) {
      case AssessmentLevel.level1:
        return AppColors.levelCritical;
      case AssessmentLevel.level2:
        return AppColors.levelModerate;
      case AssessmentLevel.level3:
        return AppColors.levelGood;
    }
  }

  /// Create a copy with modified fields
  AssessmentResultModel copyWith({
    AssessmentLevel? level,
    String? status,
    String? description,
    int? levelNumber,
  }) {
    return AssessmentResultModel(
      level: level ?? this.level,
      status: status ?? this.status,
      description: description ?? this.description,
      levelNumber: levelNumber ?? this.levelNumber,
    );
  }

  @override
  String toString() =>
      'AssessmentResultModel(level: $level, status: $status, levelNumber: $levelNumber)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssessmentResultModel &&
          runtimeType == other.runtimeType &&
          level == other.level &&
          status == other.status &&
          levelNumber == other.levelNumber;

  @override
  int get hashCode => level.hashCode ^ status.hashCode ^ levelNumber.hashCode;
}
