// lib/features/exercise/presentation/screens/workout_session_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../domain/models/exercise_model.dart';

/// Active workout session screen
///
/// Shows current exercise with timer and progress tracking
class WorkoutSessionScreen extends StatefulWidget {
  const WorkoutSessionScreen({
    Key? key,
    required this.exercises,
    required this.levelNumber,
  }) : super(key: key);

  final List<ExerciseModel> exercises;
  final int levelNumber;

  @override
  State<WorkoutSessionScreen> createState() => _WorkoutSessionScreenState();
}

class _WorkoutSessionScreenState extends State<WorkoutSessionScreen> {
  int _currentExerciseIndex = 0;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  List<bool> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    _completedExercises = List.filled(widget.exercises.length, false);
    _startExercise();
  }

  void _startExercise() {
    final exercise = widget.exercises[_currentExerciseIndex];
    setState(() {
      _secondsRemaining = exercise.duration * 60;
      _isRunning = true;
    });
    _runTimer();
  }

  void _runTimer() async {
    while (_isRunning && _secondsRemaining > 0) {
      await Future.delayed(const Duration(seconds: 1));
      if (_isRunning) {
        setState(() => _secondsRemaining--);
      }
    }

    if (_isRunning && _secondsRemaining == 0) {
      _exerciseCompleted();
    }
  }

  void _exerciseCompleted() {
    final languageProvider = context.read<LanguageProvider>();
    setState(() {
      _completedExercises[_currentExerciseIndex] = true;
      _isRunning = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exercice Terminé! 🎉'),
        content: Text(
          'Bien joué! Vous avez complété:\n${widget.exercises[_currentExerciseIndex].name}',
        ),
        actions: [
          if (_currentExerciseIndex < widget.exercises.length - 1)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _currentExerciseIndex++);
                _startExercise();
              },
              child: Text(AppTranslations.get('next', languageProvider.currentLanguage)),
            )
          else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppTranslations.get('finish', languageProvider.currentLanguage)),
            ),
        ],
      ),
    );
  }

  void _togglePause() {
    setState(() => _isRunning = !_isRunning);
    if (_isRunning) {
      _runTimer();
    }
  }

  void _skipExercise() {
    setState(() => _isRunning = false);
    if (_currentExerciseIndex < widget.exercises.length - 1) {
      setState(() => _currentExerciseIndex++);
      _startExercise();
    } else {
      Navigator.pop(context);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        final currentExercise = widget.exercises[_currentExerciseIndex];
        final progress = (_currentExerciseIndex + 1) / widget.exercises.length;

        return Scaffold(
          backgroundColor: AppColors.textPrimary,
          appBar: AppBar(
            backgroundColor: AppColors.textPrimary,
            iconTheme: const IconThemeData(color: AppColors.surface),
            title: Text(
              '${AppTranslations.get('exercise', languageProvider.currentLanguage)} ${_currentExerciseIndex + 1}/${widget.exercises.length}',
              style: const TextStyle(color: AppColors.surface),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.language, color: AppColors.surface),
                onPressed: () => showLanguageSelector(context),
                tooltip:
                    'Select Language / اختر اللغة / Sélectionner la langue',
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Progress bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslations.get('progression', languageProvider.currentLanguage),
                        style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: AppColors.surface,
                                ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor:
                              AppColors.surface.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Exercise Card
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Exercise Image/GIF Display
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Center(
                              child: currentExercise.gifUrl != null && currentExercise.gifUrl!.isNotEmpty
                                  ? Image.asset(
                                      currentExercise.gifUrl!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          _getCategoryIcon(currentExercise.category),
                                          size: 80,
                                          color: AppColors.primary,
                                        );
                                      },
                                    )
                                  : Icon(
                                      _getCategoryIcon(currentExercise.category),
                                      size: 80,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Exercise name
                                Text(
                                  currentExercise.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),

                                // Timer
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          _formatTime(_secondsRemaining),
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          AppTranslations.get('timeRemaining', languageProvider.currentLanguage),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color:
                                                    AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Reps info
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Icon(Icons.repeat,
                                              color: AppColors.primary),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${currentExercise.repetitions}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                          Text(
                                            AppTranslations.get('repetitions', languageProvider.currentLanguage),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.schedule,
                                              color: AppColors.primary),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${currentExercise.duration}'",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                          Text(
                                            'Durée',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              color: AppColors.primary),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentExercise.frequency
                                                .split(' ')[0],
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  color: AppColors.primary,
                                                ),
                                          ),
                                          Text(
                                            AppTranslations.get('frequency', languageProvider.currentLanguage),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Instructions
                                Text(
                                  AppTranslations.get('instructions', languageProvider.currentLanguage),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentExercise.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Control buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Play/Pause button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: _togglePause,
                          icon: Icon(
                              _isRunning ? Icons.pause : Icons.play_arrow),
                          label:
                              Text(_isRunning ? AppTranslations.get('pause', languageProvider.currentLanguage) : AppTranslations.get('start', languageProvider.currentLanguage)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.surface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Skip button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _skipExercise,
                          icon: const Icon(Icons.skip_next),
                          label: Text(AppTranslations.get('skip', languageProvider.currentLanguage)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Exit button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.exit_to_app),
                          label: Text(AppTranslations.get('exit', languageProvider.currentLanguage)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(ExerciseCategory category) {
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
  void dispose() {
    _isRunning = false;
    super.dispose();
  }
}