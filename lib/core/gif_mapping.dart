/// GIF mapping for exercises
/// Maps GIF filenames to exercise information

class ExerciseGifMapping {
  // Define all available GIFs with their properties
  static const Map<String, ExerciseGifInfo> gifMap = {
    // ARM EXERCISES (Bras)
    'seated_marching.gif': ExerciseGifInfo(
      name: 'Marche asise',
      difficulty: 'facile',
      category: 'bras',
      duration: 5,
      reps: 10,
      instructions:
          '1. Asseyez-vous confortablement\n'
          '2. Levez les bras en marchant sur place\n'
          '3. Continuez pendant 5 minutes\n'
          '4. Répétez 2-3 séries',
      muscleGroups: ['shoulders', 'arms'],
    ),

    // LEG EXERCISES (Jambes)
    'stick_figure_walking_cycle.gif': ExerciseGifInfo(
      name: 'Marche simple',
      difficulty: 'facile',
      category: 'jambe',
      duration: 10,
      reps: 1,
      instructions:
          '1. Tenez-vous debout\n'
          '2. Marchez lentement\n'
          '3. Maintenez l\'équilibre\n'
          '4. Continuez 10 minutes',
      muscleGroups: ['quadriceps', 'hamstrings', 'glutes'],
    ),

    'sit_to_stand.gif': ExerciseGifInfo(
      name: 'Se lever et s\'asseoir',
      difficulty: 'moyen',
      category: 'jambe',
      duration: 10,
      reps: 8,
      instructions:
          '1. Asseyez-vous sur une chaise\n'
          '2. Levez-vous lentement\n'
          '3. Rasseyez-vous\n'
          '4. Répétez 8-10 fois',
      muscleGroups: ['quadriceps', 'glutes', 'core'],
    ),

    'stair_climb_loop.gif': ExerciseGifInfo(
      name: 'Escaliers',
      difficulty: 'difficile',
      category: 'jambe',
      duration: 15,
      reps: 10,
      instructions:
          '1. Tenez-vous près des escaliers\n'
          '2. Montez lentement une à une\n'
          '3. Faites attention à l\'équilibre\n'
          '4. Continuez 10-15 minutes',
      muscleGroups: ['quadriceps', 'glutes', 'hamstrings'],
    ),

    'single_leg_balance_loop.gif': ExerciseGifInfo(
      name: 'Équilibre sur une jambe',
      difficulty: 'moyen',
      category: 'jambe',
      duration: 10,
      reps: 2,
      instructions:
          '1. Tenez-vous debout\n'
          '2. Levez une jambe\n'
          '3. Maintenez l\'équilibre 30 secondes\n'
          '4. Changez de jambe',
      muscleGroups: ['stabilizers', 'core', 'glutes'],
    ),

    'seated_leg_raise_loop.gif': ExerciseGifInfo(
      name: 'Levée de jambe asise',
      difficulty: 'facile',
      category: 'jambe',
      duration: 5,
      reps: 10,
      instructions:
          '1. Asseyez-vous confortablement\n'
          '2. Levez une jambe lentement\n'
          '3. Maintenez 2 secondes\n'
          '4. Abaissez et répétez',
      muscleGroups: ['quadriceps', 'hip_flexors'],
    ),

    // CORE EXERCISES (Tronc)
    'bed_mobility_exercise_loop.gif': ExerciseGifInfo(
      name: 'Mobilité au lit',
      difficulty: 'facile',
      category: 'tronc',
      duration: 5,
      reps: 10,
      instructions:
          '1. Allongez-vous sur le lit\n'
          '2. Bougez lentement\n'
          '3. Tournez le corps\n'
          '4. Continuez 5 minutes',
      muscleGroups: ['core', 'back'],
    ),

    // CARDIO/BALANCE EXERCISES (Cardio)
    'walker_stick_figure_loop.gif': ExerciseGifInfo(
      name: 'Marche avec support',
      difficulty: 'moyen',
      category: 'cardio',
      duration: 10,
      reps: 1,
      instructions:
          '1. Tenez le déambulateur\n'
          '2. Marchez lentement\n'
          '3. Maintenez l\'équilibre\n'
          '4. Continuez 10 minutes',
      muscleGroups: ['all'],
    ),

    'stick_balance_loop.gif': ExerciseGifInfo(
      name: 'Équilibre avec bâton',
      difficulty: 'moyen',
      category: 'cardio',
      duration: 10,
      reps: 2,
      instructions:
          '1. Tenez un bâton\n'
          '2. Tenez-vous debout\n'
          '3. Levez une jambe\n'
          '4. Maintenez 30 secondes',
      muscleGroups: ['stabilizers', 'core'],
    ),

    // STRETCHING EXERCISES (Tronc)
    'tai_chi_knee_bend_loop.gif': ExerciseGifInfo(
      name: 'Flexion genou Tai Chi',
      difficulty: 'facile',
      category: 'tronc',
      duration: 10,
      reps: 10,
      instructions:
          '1. Tenez-vous debout\n'
          '2. Fléchissez lentement les genoux\n'
          '3. Maintenez 2 secondes\n'
          '4. Revenez à la position initiale',
      muscleGroups: ['quadriceps', 'core'],
    ),

    'standing_stretch_loop.gif': ExerciseGifInfo(
      name: 'Étirement debout',
      difficulty: 'facile',
      category: 'tronc',
      duration: 5,
      reps: 10,
      instructions:
          '1. Tenez-vous debout\n'
          '2. Levez les bras\n'
          '3. Étirez-vous lentement\n'
          '4. Maintenez 10 secondes',
      muscleGroups: ['shoulders', 'back'],
    ),

    // ANKLE EXERCISES (Jambes)
    'ankle_circle_rotation.gif': ExerciseGifInfo(
      name: 'Rotation des chevilles',
      difficulty: 'facile',
      category: 'jambe',
      duration: 5,
      reps: 10,
      instructions:
          '1. Asseyez-vous ou allongez-vous\n'
          '2. Levez une jambe\n'
          '3. Faites des rotations de la cheville\n'
          '4. 10 rotations dans chaque direction',
      muscleGroups: ['ankle', 'calf'],
    ),
  };

  /// Get all GIFs for a specific difficulty
  static List<String> getGifsByDifficulty(String difficulty) {
    return gifMap.entries
        .where((entry) => entry.value.difficulty == difficulty)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all GIFs for a specific category
  static List<String> getGifsByCategory(String category) {
    return gifMap.entries
        .where((entry) => entry.value.category == category)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get GIF info by filename
  static ExerciseGifInfo? getGifInfo(String gifName) {
    return gifMap[gifName];
  }

  /// Get asset path for GIF
  static String getAssetPath(String gifName) {
    return 'assets/exercises/$gifName';
  }
}

/// GIF Information class
class ExerciseGifInfo {
  final String name;
  final String difficulty;
  final String category;
  final int duration;
  final int reps;
  final String instructions;
  final List<String> muscleGroups;

  const ExerciseGifInfo({
    required this.name,
    required this.difficulty,
    required this.category,
    required this.duration,
    required this.reps,
    required this.instructions,
    required this.muscleGroups,
  });
}
