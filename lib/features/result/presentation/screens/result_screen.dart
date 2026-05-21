// lib/features/result/presentation/screens/result_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../assessment/domain/models/assessment_model.dart';
import '../../../assessment/presentation/providers/assessment_provider.dart';
import '../../../assessment/presentation/providers/patient_assessment_history_provider.dart';
import '../../../patient/domain/models/patient_model.dart';
import '../../../patient/presentation/providers/patient_provider.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleIn;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleIn = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    
    // Save assessment to history after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveAssessment();
    });
  }

  void _saveAssessment() async {
    final assessmentProvider = context.read<AssessmentProvider>();
    final patientProvider = context.read<PatientProvider>();
    final historyProvider = context.read<PatientAssessmentHistoryProvider>();

    if (assessmentProvider.hasResult && patientProvider.patient != null) {
      final patient = patientProvider.patient!;
      final assessment = assessmentProvider.getAssessmentOrThrow();
      final result = assessmentProvider.getResultOrThrow();

      await historyProvider.saveAssessment(
        patientId: patient.id,
        patientName: patient.name,
        assessment: assessment,
        result: result,
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleNewAssessment(BuildContext context) {
    context.read<PatientProvider>().resetPatient();
    context.read<AssessmentProvider>().reset();
    Navigator.of(context).pushReplacementNamed('/patient_id');
  }

  void _handleBackToHome(BuildContext context) {
    context.read<PatientProvider>().resetPatient();
    context.read<AssessmentProvider>().reset();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Color _levelColor(int level) {
    switch (level) {
      case 1: return const Color(0xFFEF4444);
      case 2: return const Color(0xFFF59E0B);
      default: return const Color(0xFF22C55E);
    }
  }

  String _levelEmoji(int level) {
    switch (level) {
      case 1: return '🔴';
      case 2: return '🟡';
      default: return '🟢';
    }
  }

  String _levelLabel(int level) {
    switch (level) {
      case 1: return 'Niveau Critique';
      case 2: return 'Niveau Modéré';
      default: return 'Bon État';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Consumer2<AssessmentProvider, PatientProvider>(
            builder: (context, assessmentProvider, patientProvider, _) {
              if (!assessmentProvider.hasResult) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary));
              }

              final result = assessmentProvider.getResultOrThrow();
              final assessment = assessmentProvider.getAssessmentOrThrow();
              final patient = patientProvider.patient;
              final lvlColor = _levelColor(result.levelNumber);

              return Stack(
                children: [
                  // Header gradient
                  Positioned(
                    top: 0, left: 0, right: 0,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            lvlColor.withOpacity(0.85),
                            lvlColor.withOpacity(0.55),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                      ),
                    ),
                  ),

                  SafeArea(
                    child: FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          // AppBar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Row(
                              children: [
                                const SizedBox(width: 48),
                                Expanded(
                                  child: Text(
                                    AppTranslations.get('resultTitle', languageProvider.currentLanguage),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.language,
                                      color: Colors.white, size: 22),
                                  onPressed: () =>
                                      showLanguageSelector(context),
                                ),
                              ],
                            ),
                          ),

                          // Level badge hero
                          ScaleTransition(
                            scale: _scaleIn,
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: lvlColor.withOpacity(0.3),
                                    blurRadius: 28,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _levelEmoji(result.levelNumber),
                                      style: const TextStyle(fontSize: 32),
                                    ),
                                    Text(
                                      'Niv. ${result.levelNumber}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: lvlColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 4),
                            child: Text(
                              _levelLabel(result.levelNumber),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          // Cards
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                              child: Column(
                                children: [
                                  // Interpretation
                                  _ResultCard(
                                    icon: Icons.lightbulb_outline_rounded,
                                    iconColor: const Color(0xFFF59E0B),
                                    title: AppTranslations.get('interpretation', languageProvider.currentLanguage),
                                    child: Text(
                                      result.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF3D5470),
                                        height: 1.6,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  const SizedBox(height: 14),

                                  // Patient info
                                  if (patient != null) ...[
                                    _ResultCard(
                                      icon: Icons.person_outline_rounded,
                                      iconColor: AppColors.primary,
                                      title: AppTranslations.get('patientInfo', languageProvider.currentLanguage),
                                      child: Column(
                                        children: [
                                          _InfoRow(AppTranslations.get('patientNameLabel', languageProvider.currentLanguage), patient.name),
                                          _InfoRow(
                                            AppTranslations.get('patientSexLabel', languageProvider.currentLanguage),
                                            patient.sex == PatientSex.male ? 'Homme' : 'Femme',
                                          ),
                                          _InfoRow(AppTranslations.get('patientAgeLabel', languageProvider.currentLanguage), '${patient.age} ans'),
                                          _InfoRow(AppTranslations.get('patientDateLabel', languageProvider.currentLanguage), patient.avcDate),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                  ],

                                  // Assessment summary
                                  _ResultCard(
                                    icon: Icons.assignment_outlined,
                                    iconColor: const Color(0xFF8B5CF6),
                                    title: AppStrings.assessmentSummary,
                                    child: Column(
                                      children: [
                                        _SummaryRow('Position debout', _mobilityAidToString(assessment.standingCapacity, languageProvider.currentLanguage)),
                                        _SummaryRow('Marche', _mobilityAidToString(assessment.walkingCapacity, languageProvider.currentLanguage)),
                                        const Divider(height: 20, color: Color(0xFFEBF0F7)),
                                        _SummaryRow('Vertiges', assessment.hasDizziness ? 'Oui' : 'Non'),
                                        _SummaryRow('Équilibre', _balanceLevelToString(assessment.balanceLevel, languageProvider.currentLanguage)),
                                        const Divider(height: 20, color: Color(0xFFEBF0F7)),
                                        _SummaryRow('Fatigue', assessment.hasFatigue ? 'Oui' : 'Non'),
                                        _SummaryRow('Douleur', assessment.painPresent ? 'Oui' : 'Non'),
                                        _SummaryRow('Intensité douleur', '${assessment.painScore}/10'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Action buttons
                                  _GradientButton(
                                    label: 'Voir Programme d\'Exercices',
                                    icon: Icons.fitness_center_rounded,
                                    colors: [AppColors.primary, const Color(0xFF0DC9A8)],
                                    onPressed: () => Navigator.of(context).pushNamed(
                                      '/exercises',
                                      arguments: {'level': result.levelNumber},
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _GradientButton(
                                    label: AppTranslations.get('newAssessment', languageProvider.currentLanguage),
                                    icon: Icons.refresh_rounded,
                                    colors: [const Color(0xFF3B82F6), const Color(0xFF60A5FA)],
                                    onPressed: () => _handleNewAssessment(context),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () => _handleBackToHome(context),
                                    icon: const Icon(Icons.home_outlined),
                                    label: Text(AppTranslations.get('backToHome', languageProvider.currentLanguage)),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      foregroundColor: const Color(0xFF8FA3BF),
                                      side: const BorderSide(
                                          color: Color(0xFFDDE4EF), width: 1.5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _mobilityAidToString(MobilityAid aid, AppLanguage language) {
    switch (aid) {
      case MobilityAid.withoutAid: return AppTranslations.get('withoutAid', language);
      case MobilityAid.withAid: return AppTranslations.get('withAid', language);
      case MobilityAid.impossible: return AppTranslations.get('impossible', language);
    }
  }

  String _balanceLevelToString(BalanceLevel level, AppLanguage language) {
    switch (level) {
      case BalanceLevel.stable: return AppTranslations.get('stable', language);
      case BalanceLevel.moderate: return AppTranslations.get('moderate', language);
      case BalanceLevel.unstable: return AppTranslations.get('unstable', language);
    }
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2B4A),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, color: Color(0xFFEBF0F7)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8FA3BF),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF1A2B4A),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3D5470),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.colors,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}