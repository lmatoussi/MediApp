class PatientExercise {
  final int? id;
  final int userId;
  final String exerciseName;
  final String? description;
  final int? duration;
  final int? sets;
  final int? reps;
  final DateTime assignedDate;
  final bool completed;
  final DateTime? completedDate;
  final String? notes;
  final DateTime? createdAt;
  
  // New fields for exercise guides
  final String? difficulty;      // 'facile', 'moyen', 'difficile'
  final String? category;        // 'bras', 'jambe', 'tronc', 'cardio'
  final String? videoUrl;        // URL to video guide
  final String? gifUrl;          // URL to animated GIF
  final String? imagePath;       // Path to guide image
  final List<String>? muscleGroups; // Targeted muscles
  final String? instructions;    // Step-by-step instructions
  final int? painLevel;          // 0-10 scale after exercise
  final String? aiFeedback;      // AI-generated feedback

  PatientExercise({
    this.id,
    required this.userId,
    required this.exerciseName,
    this.description,
    this.duration,
    this.sets,
    this.reps,
    required this.assignedDate,
    this.completed = false,
    this.completedDate,
    this.notes,
    this.createdAt,
    this.difficulty = 'moyen',
    this.category,
    this.videoUrl,
    this.gifUrl,
    this.imagePath,
    this.muscleGroups,
    this.instructions,
    this.painLevel,
    this.aiFeedback,
  });

  /// Get difficulty display with stars
  String getDifficultyDisplay() {
    switch (difficulty) {
      case 'facile':
        return '⭐ Facile';
      case 'moyen':
        return '⭐⭐ Moyen';
      case 'difficile':
        return '⭐⭐⭐ Difficile';
      default:
        return difficulty ?? 'Moyen';
    }
  }

  /// Get difficulty color
  String getDifficultyColor() {
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

  /// Get category display with emoji
  String getCategoryDisplay() {
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
        return category ?? 'Exercice';
    }
  }

  /// Check if exercise has video guide
  bool hasVideoGuide() => videoUrl != null && videoUrl!.isNotEmpty;

  /// Check if exercise has GIF guide
  bool hasGifGuide() => gifUrl != null && gifUrl!.isNotEmpty;

  /// Check if exercise has any visual guide
  bool hasVisualGuide() => hasVideoGuide() || hasGifGuide();

  /// Get pain level description
  String getPainLevelDescription() {
    if (painLevel == null) return 'Non enregistré';
    if (painLevel! <= 2) return '✅ Pas de douleur';
    if (painLevel! <= 5) return '⚠️ Léger inconfort';
    if (painLevel! <= 7) return '🔴 Douleur modérée';
    return '🚨 Douleur intense';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_name': exerciseName,
      'description': description,
      'duration': duration,
      'sets': sets,
      'reps': reps,
      'assigned_date': assignedDate.toIso8601String(),
      'completed': completed ? 1 : 0,
      'completed_date': completedDate?.toIso8601String(),
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'difficulty': difficulty,
      'category': category,
      'video_url': videoUrl,
      'gif_url': gifUrl,
      'image_path': imagePath,
      'muscle_groups': muscleGroups?.join(','),
      'instructions': instructions,
      'pain_level': painLevel,
      'ai_feedback': aiFeedback,
    };
  }

  factory PatientExercise.fromMap(Map<String, dynamic> map) {
    return PatientExercise(
      id: map['id'],
      userId: map['user_id'],
      exerciseName: map['exercise_name'],
      description: map['description'],
      duration: map['duration'],
      sets: map['sets'],
      reps: map['reps'],
      assignedDate: DateTime.parse(map['assigned_date']),
      completed: (map['completed'] ?? 0) == 1,
      completedDate: map['completed_date'] != null ? DateTime.parse(map['completed_date']) : null,
      notes: map['notes'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      difficulty: map['difficulty'] ?? 'moyen',
      category: map['category'],
      videoUrl: map['video_url'],
      gifUrl: map['gif_url'],
      imagePath: map['image_path'],
      muscleGroups: (map['muscle_groups'] as String?)?.split(','),
      instructions: map['instructions'],
      painLevel: map['pain_level'],
      aiFeedback: map['ai_feedback'],
    );
  }

  /// Create a copy with some fields updated
  PatientExercise copyWith({
    int? id,
    int? userId,
    String? exerciseName,
    String? description,
    int? duration,
    int? sets,
    int? reps,
    DateTime? assignedDate,
    bool? completed,
    DateTime? completedDate,
    String? notes,
    DateTime? createdAt,
    String? difficulty,
    String? category,
    String? videoUrl,
    String? gifUrl,
    String? imagePath,
    List<String>? muscleGroups,
    String? instructions,
    int? painLevel,
    String? aiFeedback,
  }) {
    return PatientExercise(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      exerciseName: exerciseName ?? this.exerciseName,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      assignedDate: assignedDate ?? this.assignedDate,
      completed: completed ?? this.completed,
      completedDate: completedDate ?? this.completedDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      difficulty: difficulty ?? this.difficulty,
      category: category ?? this.category,
      videoUrl: videoUrl ?? this.videoUrl,
      gifUrl: gifUrl ?? this.gifUrl,
      imagePath: imagePath ?? this.imagePath,
      muscleGroups: muscleGroups ?? this.muscleGroups,
      instructions: instructions ?? this.instructions,
      painLevel: painLevel ?? this.painLevel,
      aiFeedback: aiFeedback ?? this.aiFeedback,
    );
  }

  @override
  String toString() => 'PatientExercise(id: $id, name: $exerciseName, difficulty: $difficulty)';
}
