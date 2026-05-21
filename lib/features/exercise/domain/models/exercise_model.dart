// lib/features/exercise/domain/models/exercise_model.dart

/// Exercise difficulty level
enum ExerciseDifficulty {
  easy,      // Facile
  moderate,  // Modéré
  hard,      // Difficile
}

/// Exercise category for organization
enum ExerciseCategory {
  mobility,      // Mobilité
  balance,       // Équilibre
  strength,      // Force
  flexibility,   // Flexibilité
  endurance,     // Endurance
}

/// Exercise recommendation model
/// 
/// Contains detailed exercise information with medical context
class ExerciseModel {
  const ExerciseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.duration, // in minutes
    required this.repetitions,
    required this.frequency, // e.g., "3 fois par jour"
    required this.precautions,
    required this.benefits,
    required this.imageUrl,
    required this.videoUrl,
    this.gifUrl,
    this.videoDuration = 120, // default 2 minutes
  });

  /// Unique exercise identifier
  final String id;

  /// Exercise name (French)
  final String name;

  /// Detailed description and instructions
  final String description;

  /// Exercise category (Mobilité, Équilibre, etc.)
  final ExerciseCategory category;

  /// Difficulty level
  final ExerciseDifficulty difficulty;

  /// Duration in minutes
  final int duration;

  /// Number of repetitions
  final int repetitions;

  /// How often to do this exercise
  final String frequency;

  /// Safety precautions and warnings
  final List<String> precautions;

  /// Benefits of this exercise
  final List<String> benefits;

  /// URL to exercise image
  final String imageUrl;

  /// URL to exercise video tutorial (YouTube or similar)
  final String videoUrl;

  /// Alternative GIF URL for quick preview
  final String? gifUrl;

  /// Video duration in seconds
  final int videoDuration;

  /// Whether this is a video or GIF
  bool get hasVideo => videoUrl.isNotEmpty;

  @override
  String toString() => 'ExerciseModel(id: $id, name: $name, category: $category)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Exercise recommendation set for a specific level
class ExerciseRecommendationSet {
  const ExerciseRecommendationSet({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.exercises,
    required this.weeklyGoal,
  });

  /// Assessment level (1, 2, or 3)
  final int levelNumber;

  /// Title (e.g., "Programme de Réadaptation - Niveau Critique")
  final String title;

  /// Program description
  final String description;

  /// List of recommended exercises
  final List<ExerciseModel> exercises;

  /// Weekly exercise goal
  final String weeklyGoal;

  /// Total duration if all exercises done
  int get totalDuration => exercises.fold(0, (sum, ex) => sum + ex.duration);

  @override
  String toString() =>
      'ExerciseRecommendationSet(level: $levelNumber, exercises: ${exercises.length})';
}
