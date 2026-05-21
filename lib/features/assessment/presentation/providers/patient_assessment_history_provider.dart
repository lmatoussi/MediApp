// lib/features/assessment/presentation/providers/patient_assessment_history_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/assessment_model.dart';
import '../../../result/domain/models/assessment_result_model.dart';

/// Saved assessment record with metadata
class SavedAssessment {
  final String id;
  final String patientId;
  final String patientName;
  final DateTime dateCompleted;
  final AssessmentModel assessmentData;
  final AssessmentResultModel result;

  SavedAssessment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.dateCompleted,
    required this.assessmentData,
    required this.result,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'dateCompleted': dateCompleted.toIso8601String(),
      'assessmentData': _assessmentToJson(assessmentData),
      'result': _resultToJson(result),
    };
  }

  /// Restore from JSON
  factory SavedAssessment.fromJson(Map<String, dynamic> json) {
    return SavedAssessment(
      id: json['id'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      dateCompleted: DateTime.parse(json['dateCompleted']),
      assessmentData: _assessmentFromJson(json['assessmentData']),
      result: _resultFromJson(json['result']),
    );
  }

  /// Get assessment level number
  int get levelNumber => result.levelNumber;

  /// Get status text
  String get status => result.status;
}

/// Convert AssessmentModel to JSON
Map<String, dynamic> _assessmentToJson(AssessmentModel assessment) {
  return {
    'standingCapacity': assessment.standingCapacity.toString(),
    'walkingCapacity': assessment.walkingCapacity.toString(),
    'hasDizziness': assessment.hasDizziness,
    'balanceLevel': assessment.balanceLevel.toString(),
    'hasFatigue': assessment.hasFatigue,
    'painPresent': assessment.painPresent,
    'painScore': assessment.painScore,
  };
}

/// Restore AssessmentModel from JSON
AssessmentModel _assessmentFromJson(Map<String, dynamic> json) {
  return AssessmentModel(
    standingCapacity: _parseMobilityAid(json['standingCapacity']),
    walkingCapacity: _parseMobilityAid(json['walkingCapacity']),
    hasDizziness: json['hasDizziness'] ?? false,
    balanceLevel: _parseBalanceLevel(json['balanceLevel']),
    hasFatigue: json['hasFatigue'] ?? false,
    painPresent: json['painPresent'] ?? false,
    painScore: json['painScore'] ?? 0,
  );
}

/// Convert AssessmentResultModel to JSON
Map<String, dynamic> _resultToJson(AssessmentResultModel result) {
  return {
    'level': result.level.toString(),
    'status': result.status,
    'description': result.description,
    'levelNumber': result.levelNumber,
  };
}

/// Restore AssessmentResultModel from JSON
AssessmentResultModel _resultFromJson(Map<String, dynamic> json) {
  return AssessmentResultModel(
    level: _parseAssessmentLevel(json['level']),
    status: json['status'],
    description: json['description'],
    levelNumber: json['levelNumber'],
  );
}

MobilityAid _parseMobilityAid(String value) {
  if (value.contains('withAid')) return MobilityAid.withAid;
  return MobilityAid.withoutAid;
}

BalanceLevel _parseBalanceLevel(String value) {
  if (value.contains('moderate')) return BalanceLevel.moderate;
  if (value.contains('unstable')) return BalanceLevel.unstable;
  return BalanceLevel.stable;
}

AssessmentLevel _parseAssessmentLevel(String value) {
  if (value.contains('level2')) return AssessmentLevel.level2;
  if (value.contains('level3')) return AssessmentLevel.level3;
  return AssessmentLevel.level1;
}

/// Provider for managing patient assessment history
class PatientAssessmentHistoryProvider extends ChangeNotifier {
  List<SavedAssessment> _assessments = [];
  static const String _storageKey = 'patient_assessments_history';

  List<SavedAssessment> get assessments => _assessments;

  /// Initialize and load assessments from storage
  Future<void> init() async {
    await _loadAssessments();
  }

  /// Load assessments from SharedPreferences
  Future<void> _loadAssessments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      
      if (jsonStr != null) {
        final List<dynamic> jsonList = jsonDecode(jsonStr);
        _assessments = jsonList
            .map((item) => SavedAssessment.fromJson(item as Map<String, dynamic>))
            .toList();
        _assessments.sort((a, b) => b.dateCompleted.compareTo(a.dateCompleted));
      }
    } catch (e) {
      debugPrint('Error loading assessments: $e');
    }
    notifyListeners();
  }

  /// Save a new assessment
  Future<void> saveAssessment({
    required String patientId,
    required String patientName,
    required AssessmentModel assessment,
    required AssessmentResultModel result,
  }) async {
    try {
      final id = 'assessment_${DateTime.now().millisecondsSinceEpoch}';
      final newAssessment = SavedAssessment(
        id: id,
        patientId: patientId,
        patientName: patientName,
        dateCompleted: DateTime.now(),
        assessmentData: assessment,
        result: result,
      );

      _assessments.insert(0, newAssessment);
      await _saveToPreferences();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving assessment: $e');
    }
  }

  /// Save to SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _assessments.map((a) => a.toJson()).toList();
      await prefs.setString(_storageKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving to preferences: $e');
    }
  }

  /// Get assessments by patient ID
  List<SavedAssessment> getAssessmentsByPatient(String patientId) {
    return _assessments.where((a) => a.patientId == patientId).toList();
  }

  /// Get assessments by level
  List<SavedAssessment> getAssessmentsByLevel(int levelNumber) {
    return _assessments.where((a) => a.levelNumber == levelNumber).toList();
  }

  /// Search assessments by patient name
  List<SavedAssessment> searchByPatientName(String query) {
    final lowerQuery = query.toLowerCase();
    return _assessments
        .where((a) => a.patientName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Get total number of assessments
  int get totalAssessments => _assessments.length;

  /// Get assessments completed today
  List<SavedAssessment> getAssessmentsFromToday() {
    final today = DateTime.now();
    return _assessments.where((a) {
      return a.dateCompleted.year == today.year &&
          a.dateCompleted.month == today.month &&
          a.dateCompleted.day == today.day;
    }).toList();
  }

  /// Delete an assessment
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      _assessments.removeWhere((a) => a.id == assessmentId);
      await _saveToPreferences();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting assessment: $e');
    }
  }

  /// Clear all assessments
  Future<void> clearAll() async {
    try {
      _assessments.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing assessments: $e');
    }
  }
}
