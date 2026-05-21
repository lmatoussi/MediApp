import 'package:flutter/material.dart';
import 'package:medical_app/core/exercise_service.dart';
import 'package:medical_app/core/patient_exercise_model.dart';
import 'package:medical_app/core/widgets/exercise_gif_player.dart';

/// Exercise Execution Screen with GIF Display
/// Shows exercise with animated GIF, timing, and rep counter
class ExerciseExecutionScreenWithGif extends StatefulWidget {
  final PatientExercise exercise;
  final int userId;

  const ExerciseExecutionScreenWithGif({
    Key? key,
    required this.exercise,
    required this.userId,
  }) : super(key: key);

  @override
  State<ExerciseExecutionScreenWithGif> createState() =>
      _ExerciseExecutionScreenWithGifState();
}

class _ExerciseExecutionScreenWithGifState
    extends State<ExerciseExecutionScreenWithGif> {
  final ExerciseService _exerciseService = ExerciseService();

  late int _repsCompleted;
  late int _painLevel;
  late int _elapsedSeconds;
  late int _totalDurationSeconds;
  int _currentStep = 1;

  @override
  void initState() {
    super.initState();
    _repsCompleted = 0;
    _painLevel = 0;
    _elapsedSeconds = 0;
    _totalDurationSeconds = (widget.exercise.duration ?? 5) * 60;

    // Start timer
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
        if (_elapsedSeconds < _totalDurationSeconds) {
          _startTimer();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final instructions = widget.exercise.instructions?.split('\n') ?? [];
    final targetReps = widget.exercise.reps ?? 10;

    return WillPopScope(
      onWillPop: () async {
        // Show confirmation dialog before exiting
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Arrêter l\'exercice?'),
            content: const Text('Êtes-vous sûr? Les données ne seront pas enregistrées.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Continuer'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Arrêter'),
              ),
            ],
          ),
        ) ??
            false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.exercise.exerciseName),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '${((_repsCompleted / targetReps) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // GIF Player
            Expanded(
              flex: 2,
              child: ExerciseGifPlayer(
                exercise: widget.exercise,
                elapsedSeconds: _elapsedSeconds,
                totalDurationSeconds: _totalDurationSeconds,
                onComplete: () {},
              ),
            ),

            // Controls Section
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Step
                      if (instructions.isNotEmpty && _currentStep <= instructions.length)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '$_currentStep',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  instructions[_currentStep - 1],
                                  style: TextStyle(color: Colors.blue[900]),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Reps Counter
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Répétitions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                iconSize: 40,
                                color: Colors.red,
                                onPressed: () {
                                  if (_repsCompleted > 0) {
                                    setState(() => _repsCompleted--);
                                  }
                                },
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Text(
                                  '$_repsCompleted / $targetReps',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                iconSize: 40,
                                color: Colors.green,
                                onPressed: () {
                                  if (_repsCompleted < targetReps) {
                                    setState(() => _repsCompleted++);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Pain Level
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Niveau de douleur',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$_painLevel/10',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _getPainColor(_painLevel),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: _painLevel.toDouble(),
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: '$_painLevel',
                            onChanged: (value) {
                              setState(() => _painLevel = value.toInt());
                            },
                          ),
                          Text(
                            _exerciseService.getPainLevelDescription(_painLevel),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Arrêter?'),
                                    content: const Text(
                                        'L\'exercice ne sera pas enregistré.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text('Continuer'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Arrêter'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Annuler'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  _repsCompleted > 0 ? _completeExercise : null,
                              child: const Text('Terminer'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _completeExercise() async {
    // Record exercise
    final success = await _exerciseService.completeExercise(
      userId: widget.userId,
      exerciseId: widget.exercise.id ?? 0,
      repsCompleted: _repsCompleted,
      durationSeconds: _elapsedSeconds,
      painLevel: _painLevel,
    );

    if (success && mounted) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Exercice terminé!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCompletionStat(
                  '💪 Répétitions',
                  '$_repsCompleted/${widget.exercise.reps ?? 10}',
                ),
                _buildCompletionStat(
                  '⏱️ Durée',
                  '${(_elapsedSeconds / 60).toStringAsFixed(1)} min',
                ),
                _buildCompletionStat(
                  '😟 Douleur',
                  '$_painLevel/10 - ${_exerciseService.getPainLevelDescription(_painLevel)}',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Retour'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCompletionStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPainColor(int pain) {
    if (pain <= 2) return Colors.green;
    if (pain <= 5) return Colors.orange;
    return Colors.red;
  }
}
