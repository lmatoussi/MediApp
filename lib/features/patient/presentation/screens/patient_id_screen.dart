// lib/features/patient/presentation/screens/patient_id_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/providers/language_provider.dart';

class PatientIdScreen extends StatefulWidget {
  const PatientIdScreen({Key? key}) : super(key: key);

  @override
  State<PatientIdScreen> createState() => _PatientIdScreenState();
}

class _PatientIdScreenState extends State<PatientIdScreen>
    with SingleTickerProviderStateMixin {
  final _patientIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _patientIdController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate validation - in production, verify patient ID with backend
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      final patientId = _patientIdController.text.trim();
      
      // Simple validation: patient ID should be numeric
      if (int.tryParse(patientId) == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Identifiant patient invalide';
        });
        return;
      }

      setState(() {
        _isLoading = false;
      });

      // Navigate to assessment screen with patient ID
      Navigator.of(context).pushNamed(
        '/assessment',
        arguments: {'patientId': patientId},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient ID'),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: LanguageSelector(),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Title
                    Text(
                      'Identification Patient',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Entrez votre identifiant patient pour accéder à votre évaluation fonctionnelle.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                    const SizedBox(height: 48),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Patient ID Field
                          Text(
                            'Identifiant Patient',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _patientIdController,
                            decoration: InputDecoration(
                              hintText: 'Ex: 12345',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorText: _errorMessage,
                            ),
                            keyboardType: TextInputType.number,
                            enabled: !_isLoading,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre identifiant patient';
                              }
                              if (value.length < 3) {
                                return 'L\'identifiant doit contenir au moins 3 caractères';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _handleSubmit(),
                          ),
                          const SizedBox(height: 32),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              onPressed: _isLoading ? () {} : _handleSubmit,
                              isLoading: _isLoading,
                              label: 'Continuer',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Si vous n\'avez pas d\'identifiant, veuillez contacter votre établissement médical.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
