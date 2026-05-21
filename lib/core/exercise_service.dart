import 'package:medical_app/core/database_helper.dart';
import 'package:medical_app/core/patient_exercise_model.dart';

class ExerciseService {
  final DatabaseHelper _db = DatabaseHelper();

  /// Get all exercises
  Future<List<PatientExercise>> getAllExercises() async {
    return await _db.getAllExercises();
  }

  /// Get exercises by difficulty level
  Future<List<PatientExercise>> getExercisesByDifficulty(String difficulty) async {
    return await _db.getExercisesByDifficulty(difficulty);
  }

  /// Get exercises by category
  Future<List<PatientExercise>> getExercisesByCategory(String category) async {
    return await _db.getExercisesByCategory(category);
  }

  /// Get all available difficulty levels
  List<String> getDifficultyLevels() => ['facile', 'moyen', 'difficile'];

  /// Get all available categories
  List<String> getCategories() => ['bras', 'jambe', 'tronc', 'cardio'];

  /// Record exercise completion
  Future<bool> completeExercise({
    required int userId,
    required int exerciseId,
    required int repsCompleted,
    required int durationSeconds,
    required int painLevel,
  }) async {
    try {
      final feedback = _generateAIFeedback(repsCompleted, painLevel);
      
      await _db.recordExerciseProgress(
        userId: userId,
        exerciseId: exerciseId,
        repsCompleted: repsCompleted,
        durationSeconds: durationSeconds,
        painLevel: painLevel,
        aiFeedback: feedback,
      );
      
      return true;
    } catch (e) {
      print('❌ Error completing exercise: $e');
      return false;
    }
  }

  /// Generate AI feedback based on performance
  String _generateAIFeedback(int repsCompleted, int painLevel) {
    if (painLevel > 7) {
      return '⚠️ Niveau de douleur trop élevé. Réduisez l\'intensité lors de la prochaine séance.';
    }
    
    if (painLevel >= 5 && painLevel <= 7) {
      return '🟡 Douleur modérée ressentie. Continuez doucement et arrêtez si la douleur augmente.';
    }
    
    if (repsCompleted < 5) {
      return '💪 Essayez d\'augmenter le nombre de répétitions progressivement. Vous êtes sur le bon chemin!';
    }
    
    if (repsCompleted >= 5 && repsCompleted <= 10) {
      return '✅ Excellent travail! Progression régulière. Continuez à ce rythme.';
    }
    
    if (repsCompleted > 10) {
      return '🎉 Superbe performance! Vous progressez bien. Prêt(e) pour le niveau suivant?';
    }
    
    return '✅ Bien fait! Continuez l\'entraînement régulièrement.';
  }

  /// Get pain level description
  String getPainLevelDescription(int painLevel) {
    if (painLevel <= 2) return '✅ Pas de douleur';
    if (painLevel <= 4) return '🟢 Légère gêne';
    if (painLevel <= 6) return '🟡 Douleur modérée';
    if (painLevel <= 8) return '🔴 Douleur importante';
    return '🚨 Douleur intense - Arrêtez';
  }

  /// Get difficulty color (hex)
  String getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'facile':
        return '#4CAF50'; // Green
      case 'moyen':
        return '#FF9800'; // Orange
      case 'difficile':
        return '#F44336'; // Red
      default:
        return '#9E9E9E';
    }
  }

  /// Get difficulty display with stars
  String getDifficultyDisplay(String difficulty) {
    switch (difficulty) {
      case 'facile':
        return '⭐ Facile';
      case 'moyen':
        return '⭐⭐ Moyen';
      case 'difficile':
        return '⭐⭐⭐ Difficile';
      default:
        return 'Moyen';
    }
  }

  /// Get category display with emoji
  String getCategoryDisplay(String? category) {
    switch (category) {
      case 'bras':
        return '💪 Bras';
      case 'jambe':
        return '🦵 Jambe';
      case 'tronc':
        return '🫀 Tronc';
      case 'cardio':
        return '❤️ Cardio';
      default:
        return '🏋️ Exercice';
    }
  }

  /// Calculate exercise progression percentage
  double getProgressionPercentage(int repsCompleted, int targetReps) {
    if (targetReps == 0) return 0.0;
    return ((repsCompleted / targetReps) * 100).clamp(0.0, 100.0);
  }
}
