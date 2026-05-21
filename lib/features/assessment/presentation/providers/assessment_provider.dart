// lib/features/assessment/presentation/providers/assessment_provider.dart

import 'package:flutter/material.dart';
import '../../domain/models/assessment_model.dart';
import '../../logic/scoring_engine.dart';
import '../../../result/domain/models/assessment_result_model.dart';

/// State notifier for managing functional assessment data
/// 
/// Handles the collection of functional status information and calculates
/// the result using the medical scoring engine.
/// Uses Provider package for state management.
class AssessmentProvider extends ChangeNotifier {
  AssessmentModel? _assessment;
  AssessmentResultModel? _result;

  AssessmentModel? get assessment => _assessment;
  AssessmentResultModel? get result => _result;

  /// Initialize assessment with default values
  void initializeAssessment() {
    _assessment = AssessmentModel(
      standingCapacity: MobilityAid.withoutAid,
      walkingCapacity: MobilityAid.withoutAid,
      hasDizziness: false,
      balanceLevel: BalanceLevel.stable,
      hasFatigue: false,
      painPresent: false,
      painScore: 0,
    );
    notifyListeners();
  }

  /// Update standing capacity (Position debout)
  void setStandingCapacity(MobilityAid value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(standingCapacity: value);
      notifyListeners();
    }
  }

  /// Update walking capacity (Marche)
  void setWalkingCapacity(MobilityAid value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(walkingCapacity: value);
      notifyListeners();
    }
  }

  /// Update dizziness status (Vertiges)
  void setHasDizziness(bool value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(hasDizziness: value);
      notifyListeners();
    }
  }

  /// Update balance level (Équilibre)
  void setBalanceLevel(BalanceLevel value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(balanceLevel: value);
      notifyListeners();
    }
  }

  /// Update fatigue status (Fatigue)
  void setHasFatigue(bool value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(hasFatigue: value);
      notifyListeners();
    }
  }

  /// Update pain presence (Douleur)
  void setPainPresent(bool value) {
    if (_assessment != null) {
      _assessment = _assessment!.copyWith(painPresent: value);
      notifyListeners();
    }
  }

  /// Update pain score (0-10)
  void setPainScore(int value) {
    if (_assessment != null) {
      final clampedValue = value.clamp(0, 10);
      _assessment = _assessment!.copyWith(painScore: clampedValue);
      notifyListeners();
    }
  }

  /// Calculate result based on current assessment data
  void calculateResult() {
    if (_assessment == null) {
      throw Exception('Assessment not initialized');
    }
    _result = ScoringEngine.calculateResult(_assessment!);
    notifyListeners();
  }

  /// Check if assessment is initialized
  bool get isAssessmentSet => _assessment != null;

  /// Check if result has been calculated
  bool get hasResult => _result != null;

  /// Reset assessment and result
  void reset() {
    _assessment = null;
    _result = null;
    notifyListeners();
  }

  /// Get current assessment or throw if not set
  AssessmentModel getAssessmentOrThrow() {
    if (_assessment == null) {
      throw Exception('Assessment not initialized');
    }
    return _assessment!;
  }

  /// Get current result or throw if not calculated
  AssessmentResultModel getResultOrThrow() {
    if (_result == null) {
      throw Exception('Result not calculated');
    }
    return _result!;
  }
}
