// lib/features/exercise/presentation/screens/exercise_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../domain/models/exercise_model.dart';
import '../../logic/exercise_engine.dart';

/// Exercise recommendation screen
///
/// Displays personalized exercises based on assessment level
class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({
    Key? key,
    required this.levelNumber,
  }) : super(key: key);

  /// Assessment level (1, 2, or 3)
  final int levelNumber;

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        final recommendations = ExerciseEngine.getRecommendations(levelNumber);

        return Scaffold(
          appBar: AppBar(
            title: Text(AppTranslations.get(
                'exerciseTitle', languageProvider.currentLanguage)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () => showLanguageSelector(context),
                tooltip:
                    'Select Language / اختر اللغة / Sélectionner la langue',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // ============= PROGRAM HEADER =============
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendations.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          recommendations.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${AppTranslations.get('objective', languageProvider.currentLanguage)}: ${recommendations.weeklyGoal}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ============= EXERCISE SUMMARY =============
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${recommendations.exercises.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            Text(
                              AppTranslations.get('exercises', languageProvider.currentLanguage),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${recommendations.totalDuration}'",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                            Text(
                              AppTranslations.get('totalDuration', languageProvider.currentLanguage),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ============= EXERCISES LIST =============
                  ...List.generate(
                    recommendations.exercises.length,
                    (index) => _ExerciseCard(
                      exercise: recommendations.exercises[index],
                      index: index + 1,
                      totalExercises: recommendations.exercises.length,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ============= ACTION BUTTONS =============
                  PrimaryButton(
                    label: AppTranslations.get('startProgram', languageProvider.currentLanguage),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        '/workout_session',
                        arguments: {
                          'exercises': recommendations.exercises,
                          'levelNumber': levelNumber,
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppTranslations.get('back', languageProvider.currentLanguage)),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Individual exercise card widget
class _ExerciseCard extends StatefulWidget {
  const _ExerciseCard({
    required this.exercise,
    required this.index,
    required this.totalExercises,
  });

  final ExerciseModel exercise;
  final int index;
  final int totalExercises;

  @override
  State<_ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<_ExerciseCard> {
  bool _isExpanded = false;

  String _difficultyLabel(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.easy:
        return 'Facile';
      case ExerciseDifficulty.moderate:
        return 'Modéré';
      case ExerciseDifficulty.hard:
        return 'Difficile';
    }
  }

  Color _difficultyColor(ExerciseDifficulty difficulty) {
    switch (difficulty) {
      case ExerciseDifficulty.easy:
        return AppColors.levelGood;
      case ExerciseDifficulty.moderate:
        return AppColors.levelModerate;
      case ExerciseDifficulty.hard:
        return AppColors.levelCritical;
    }
  }

  String _categoryLabel(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.mobility:
        return 'Mobilité';
      case ExerciseCategory.balance:
        return 'Équilibre';
      case ExerciseCategory.strength:
        return 'Force';
      case ExerciseCategory.flexibility:
        return 'Flexibilité';
      case ExerciseCategory.endurance:
        return 'Endurance';
    }
  }

  IconData _categoryIcon(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.mobility:
        return Icons.directions_walk;
      case ExerciseCategory.balance:
        return Icons.balance;
      case ExerciseCategory.strength:
        return Icons.fitness_center;
      case ExerciseCategory.flexibility:
        return Icons.accessibility;
      case ExerciseCategory.endurance:
        return Icons.favorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() => _isExpanded = !_isExpanded);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isExpanded ? AppColors.primary : AppColors.divider,
              width: _isExpanded ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exercise number
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.index}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: AppColors.primary,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Exercise info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.exercise.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  // Category
                                  Chip(
                                    label: Text(_categoryLabel(
                                        widget.exercise.category)),
                                    avatar: Icon(
                                      _categoryIcon(widget.exercise.category),
                                      size: 16,
                                    ),
                                    backgroundColor:
                                        AppColors.primary.withOpacity(0.1),
                                    labelStyle:
                                        const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(width: 8),
                                  // Difficulty
                                  Chip(
                                    label: Text(_difficultyLabel(
                                        widget.exercise.difficulty)),
                                    backgroundColor: _difficultyColor(
                                            widget.exercise.difficulty)
                                        .withOpacity(0.2),
                                    labelStyle: TextStyle(
                                      fontSize: 12,
                                      color: _difficultyColor(
                                          widget.exercise.difficulty),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Expand icon
                        Icon(
                          _isExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Quick info
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.schedule,
                                  size: 16,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.exercise.duration} min',
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.repeat,
                                  size: 16,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.exercise.repetitions}x',
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                widget.exercise.frequency,
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Expanded details
              if (_isExpanded) ...[
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Instructions:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.exercise.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 16),

                      // Benefits
                      Text(
                        'Bénéfices:',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      ...widget.exercise.benefits.map(
                        (benefit) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: AppColors.levelGood,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  benefit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Precautions
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.warning.withOpacity(0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber,
                                  size: 18,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Précautions:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: AppColors.warning,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...widget.exercise.precautions.map(
                              (precaution) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '• ',
                                      style: TextStyle(
                                          color: AppColors.warning),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        precaution,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // View Full Details Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/exercise_detail',
                              arguments: {'exercise': widget.exercise},
                            );
                          },
                          icon: const Icon(Icons.videocam),
                          label:
                              const Text('Voir la Démonstration Vidéo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}