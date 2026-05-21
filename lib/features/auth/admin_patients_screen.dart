import 'package:flutter/material.dart';
import 'package:medical_app/core/database_helper.dart';
import 'package:medical_app/core/user_model.dart';

class AdminPatientsScreen extends StatefulWidget {
  const AdminPatientsScreen({Key? key}) : super(key: key);

  @override
  State<AdminPatientsScreen> createState() => _AdminPatientsScreenState();
}

class _AdminPatientsScreenState extends State<AdminPatientsScreen> {
  final _db = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() {
    _patientsFuture = _db.getAllPatients();
  }

  void _refreshPatients() {
    setState(() {
      _loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Patients'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshPatients,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erreur: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshPatients,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final patients = snapshot.data ?? [];

          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text('Aucun patient enregistré'),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final user = User.fromMap(patient);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : 'P',
                    ),
                  ),
                  title: Text(user.fullName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email),
                      if (user.phone != null && user.phone!.isNotEmpty)
                        Text(
                          user.phone!,
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PatientDetailsScreen(patient: user),
                        ),
                      );
                    },
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PatientDetailsScreen extends StatefulWidget {
  final User patient;

  const PatientDetailsScreen({
    Key? key,
    required this.patient,
  }) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final _db = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> _medicalRecordsFuture;
  late Future<List<Map<String, dynamic>>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _medicalRecordsFuture = _db.getMedicalRecords(widget.patient.id!);
    _exercisesFuture = _db.getPatientExercises(widget.patient.id!);
  }

  void _showAddExerciseDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un exercice'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'exercice',
                  hintText: 'Ex: Flexions des genoux',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Détails de l\'exercice',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Durée (minutes)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Veuillez entrer un nom')),
                );
                return;
              }

              await _db.assignExercise(
                widget.patient.id!,
                {
                  'exercise_name': nameController.text,
                  'description': descriptionController.text,
                  'duration': int.tryParse(durationController.text),
                },
              );

              if (mounted) {
                setState(() {
                  _exercisesFuture =
                      _db.getPatientExercises(widget.patient.id!);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Exercice ajouté avec succès'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.fullName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations Personnelles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Email', widget.patient.email),
                    if (widget.patient.phone != null &&
                        widget.patient.phone!.isNotEmpty)
                      _buildInfoRow('Téléphone', widget.patient.phone!),
                    if (widget.patient.dateOfBirth != null)
                      _buildInfoRow('Date de naissance',
                          widget.patient.dateOfBirth!),
                    if (widget.patient.gender != null)
                      _buildInfoRow('Sexe',
                          widget.patient.gender == 'M' ? 'Masculin' : 'Féminin'),
                    if (widget.patient.address != null &&
                        widget.patient.address!.isNotEmpty)
                      _buildInfoRow('Adresse', widget.patient.address!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Medical History
            if (widget.patient.medicalHistory != null &&
                widget.patient.medicalHistory!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Antécédents Médicaux',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(widget.patient.medicalHistory!),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),

            // Medical Records Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dossiers Médicaux',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement add medical record
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _medicalRecordsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final records = snapshot.data ?? [];
                if (records.isEmpty) {
                  return const Text('Aucun dossier médical');
                }

                return Column(
                  children: records
                      .map((record) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(record['diagnosis'] ?? 'Sans diagnostic'),
                              subtitle: Text(record['record_date']),
                              trailing: const Icon(Icons.file_present),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),

            // Exercises Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exercices Assignés',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddExerciseDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _exercisesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final exercises = snapshot.data ?? [];
                if (exercises.isEmpty) {
                  return const Text('Aucun exercice assigné');
                }

                return Column(
                  children: exercises
                      .map((exercise) => Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(exercise['exercise_name']),
                              subtitle: Text(
                                'Assigné le ${exercise['assigned_date']}',
                              ),
                              trailing: Checkbox(
                                value: (exercise['completed'] ?? 0) == 1,
                                onChanged: (value) async {
                                  if (value ?? false) {
                                    await _db
                                        .markExerciseCompleted(exercise['id']);
                                    if (mounted) {
                                      setState(() {
                                        _exercisesFuture = _db
                                            .getPatientExercises(
                                                widget.patient.id!);
                                      });
                                    }
                                  }
                                },
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
