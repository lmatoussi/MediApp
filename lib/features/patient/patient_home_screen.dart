import 'package:flutter/material.dart';
import 'package:medical_app/core/auth_service.dart';
import 'package:medical_app/core/database_helper.dart';
import 'package:medical_app/core/patient_exercise_model.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final _authService = AuthService();
  final _db = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _authService.init();
    _loadExercises();
  }

  void _loadExercises() {
    _exercisesFuture =
        _db.getPatientExercises(_authService.getCurrentUserId() ?? 0);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Espace Patient'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadExercises();
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenue! 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Continuez vos exercices de réhabilitation pour une meilleure récupération.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Statistics
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Exercices',
                      subtitle: 'à faire',
                      icon: Icons.fitness_center,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Complétés',
                      subtitle: 'cette semaine',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // My Exercises Section
              const Text(
                'Mes Exercices Assignés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: _exercisesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erreur: ${snapshot.error}'),
                    );
                  }

                  final exercises = snapshot.data ?? [];

                  if (exercises.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.assignment_turned_in,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text('Aucun exercice assigné'),
                            const SizedBox(height: 8),
                            Text(
                              'Votre administrateur vous assignera bientôt des exercices.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Separate exercises by completion status
                  final pendingExercises = exercises
                      .where((e) => (e['completed'] ?? 0) == 0)
                      .toList();
                  final completedExercises = exercises
                      .where((e) => (e['completed'] ?? 0) == 1)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pending Exercises
                      if (pendingExercises.isNotEmpty) ...[
                        const Text(
                          'À faire',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...pendingExercises.map((exercise) =>
                            _buildExerciseCard(exercise, context)),
                        const SizedBox(height: 20),
                      ],

                      // Completed Exercises
                      if (completedExercises.isNotEmpty) ...[
                        const Text(
                          'Complétés ✓',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...completedExercises.map((exercise) =>
                            _buildExerciseCard(exercise, context, completed: true)),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    Map<String, dynamic> exercise,
    BuildContext context, {
    bool completed = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: completed ? Colors.green : Colors.blue.shade50,
          child: Icon(
            completed ? Icons.check : Icons.fitness_center,
            color: completed ? Colors.white : Colors.blue,
          ),
        ),
        title: Text(
          exercise['exercise_name'],
          style: TextStyle(
            decoration:
                completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise['description'] != null &&
                (exercise['description'] as String).isNotEmpty)
              Text(exercise['description']),
            const SizedBox(height: 4),
            Row(
              children: [
                if (exercise['duration'] != null)
                  Chip(
                    label: Text('${exercise['duration']} min'),
                    avatar: const Icon(Icons.schedule, size: 16),
                    labelStyle: const TextStyle(fontSize: 11),
                  ),
                const SizedBox(width: 8),
                if (exercise['assigned_date'] != null)
                  Text(
                    exercise['assigned_date'],
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
              ],
            ),
          ],
        ),
        trailing: !completed
            ? IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () async {
                  await _db.markExerciseCompleted(exercise['id']);
                  if (mounted) {
                    setState(() {
                      _loadExercises();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('✓ Exercice marqué comme complété!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              )
            : const Icon(Icons.done_all, color: Colors.green),
        isThreeLine: true,
      ),
    );
  }
}
