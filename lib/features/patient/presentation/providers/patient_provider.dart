// lib/features/patient/presentation/providers/patient_provider.dart

import 'package:flutter/material.dart';
import '../../domain/models/patient_model.dart';

/// State notifier for managing patient data during assessment
/// 
/// Handles patient identification information that persists across screens.
/// Uses Provider package for state management.
class PatientProvider extends ChangeNotifier {
  PatientModel? _patient;

  PatientModel? get patient => _patient;

  /// Update patient information
  void setPatient({
    required String name,
    required PatientSex sex,
    required int age,
    required String avcDate,
  }) {
    // Generate unique patient ID based on timestamp and name hash
    final id = 'patient_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode.abs()}';
    
    _patient = PatientModel(
      id: id,
      name: name,
      sex: sex,
      age: age,
      avcDate: avcDate,
    );
    notifyListeners();
  }

  /// Update individual patient field
  void updatePatient(PatientModel updatedPatient) {
    _patient = updatedPatient;
    notifyListeners();
  }

  /// Reset patient data
  void resetPatient() {
    _patient = null;
    notifyListeners();
  }

  /// Get current patient or throw if not set
  PatientModel getPatientOrThrow() {
    if (_patient == null) {
      throw Exception('Patient not initialized');
    }
    return _patient!;
  }

  /// Check if patient is initialized
  bool get isPatientSet => _patient != null;
}

