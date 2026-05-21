// lib/features/assessment/presentation/screens/assessment_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_translations.dart';
import '../../../../core/providers/language_provider.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../domain/models/assessment_model.dart';
import '../providers/assessment_provider.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssessmentProvider>().initializeAssessment();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    context.read<AssessmentProvider>().calculateResult();
    Navigator.of(context).pushNamed('/result');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Stack(
            children: [
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0A7E6E), Color(0xFF0FA08C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
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
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white, size: 20),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const Expanded(
                              child: Text(
                                'Évaluation Fonctionnelle',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.language,
                                  color: Colors.white, size: 22),
                              onPressed: () => showLanguageSelector(context),
                            ),
                          ],
                        ),
                      ),

                      // Step indicator
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _StepDot(active: false, done: true, label: '1'),
                            _StepLine(),
                            _StepDot(active: true, done: false, label: '2'),
                            _StepLine(),
                            _StepDot(active: false, done: false, label: '3'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      Expanded(
                        child: Consumer<AssessmentProvider>(
                          builder: (context, assessmentProvider, _) {
                            if (!assessmentProvider.isAssessmentSet) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.primary));
                            }
                            final assessment = assessmentProvider.assessment!;

                            return SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                              child: Column(
                                children: [
                                  // ── Section 1: Mobilité ──────────────
                                  _AssessmentCard(
                                    icon: Icons.directions_walk_rounded,
                                    title: AppTranslations.get('mobilitySection', languageProvider.currentLanguage),
                                    color: const Color(0xFF3B82F6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _QuestionLabel(AppTranslations.get('canStand', languageProvider.currentLanguage)),
                                        const SizedBox(height: 10),
                                        _ChoiceGroup<MobilityAid>(
                                          selected: assessment.standingCapacity,
                                          options: [
                                            _Choice(MobilityAid.withoutAid, AppTranslations.get('withoutAid', languageProvider.currentLanguage), Icons.person_rounded),
                                            _Choice(MobilityAid.withAid, AppTranslations.get('withAid', languageProvider.currentLanguage), Icons.accessible_forward_rounded),
                                            _Choice(MobilityAid.impossible, AppTranslations.get('impossible', languageProvider.currentLanguage), Icons.block_rounded),
                                          ],
                                          onSelect: assessmentProvider.setStandingCapacity,
                                        ),
                                        const SizedBox(height: 20),
                                        _QuestionLabel(AppTranslations.get('canWalk', languageProvider.currentLanguage)),
                                        const SizedBox(height: 10),
                                        _ChoiceGroup<MobilityAid>(
                                          selected: assessment.walkingCapacity,
                                          options: [
                                            _Choice(MobilityAid.withoutAid, AppTranslations.get('withoutAid', languageProvider.currentLanguage), Icons.person_rounded),
                                            _Choice(MobilityAid.withAid, AppTranslations.get('withAid', languageProvider.currentLanguage), Icons.accessible_forward_rounded),
                                            _Choice(MobilityAid.impossible, AppTranslations.get('impossible', languageProvider.currentLanguage), Icons.block_rounded),
                                          ],
                                          onSelect: assessmentProvider.setWalkingCapacity,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Section 2: Équilibre ─────────────
                                  _AssessmentCard(
                                    icon: Icons.balance_rounded,
                                    title: AppTranslations.get('balanceSection', languageProvider.currentLanguage),
                                    color: const Color(0xFF8B5CF6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _ToggleRow(
                                          label: AppTranslations.get('hasDizziness', languageProvider.currentLanguage),
                                          value: assessment.hasDizziness,
                                          onChanged: assessmentProvider.setHasDizziness,
                                        ),
                                        const SizedBox(height: 20),
                                        _QuestionLabel(AppTranslations.get('balanceLevel', languageProvider.currentLanguage)),
                                        const SizedBox(height: 10),
                                        _ChoiceGroup<BalanceLevel>(
                                          selected: assessment.balanceLevel,
                                          options: [
                                            _Choice(BalanceLevel.stable, AppTranslations.get('stable', languageProvider.currentLanguage), Icons.check_circle_outline_rounded),
                                            _Choice(BalanceLevel.moderate, AppTranslations.get('moderate', languageProvider.currentLanguage), Icons.remove_circle_outline_rounded),
                                            _Choice(BalanceLevel.unstable, AppTranslations.get('unstable', languageProvider.currentLanguage), Icons.warning_amber_rounded),
                                          ],
                                          onSelect: assessmentProvider.setBalanceLevel,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // ── Section 3: État Général ──────────
                                  _AssessmentCard(
                                    icon: Icons.favorite_outline_rounded,
                                    title: AppTranslations.get('generalStateSection', languageProvider.currentLanguage),
                                    color: const Color(0xFFEF4444),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _ToggleRow(
                                          label: AppTranslations.get('hasFatigue', languageProvider.currentLanguage),
                                          value: assessment.hasFatigue,
                                          onChanged: assessmentProvider.setHasFatigue,
                                        ),
                                        const SizedBox(height: 16),
                                        _ToggleRow(
                                          label: AppTranslations.get('painPresent', languageProvider.currentLanguage),
                                          value: assessment.painPresent,
                                          onChanged: assessmentProvider.setPainPresent,
                                        ),
                                        const SizedBox(height: 20),
                                        _QuestionLabel(AppTranslations.get('painScore', languageProvider.currentLanguage)),
                                        const SizedBox(height: 12),
                                        _PainSlider(
                                          value: assessment.painScore,
                                          onChanged: assessmentProvider.setPainScore,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Submit button
                                  _GradientButton(
                                    label: AppStrings.submit,
                                    onPressed: () => _handleSubmit(context),
                                    trailingIcon: Icons.arrow_forward_ios_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Pain slider ───────────────────────────────────────────────────────────────
class _PainSlider extends StatelessWidget {
  const _PainSlider({required this.value, required this.onChanged});
  final int value;
  final void Function(int) onChanged;

  Color get _color {
    if (value <= 3) return const Color(0xFF22C55E);
    if (value <= 6) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: _color,
                  inactiveTrackColor: _color.withOpacity(0.2),
                  thumbColor: _color,
                  overlayColor: _color.withOpacity(0.15),
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                ),
                child: Slider(
                  value: value.toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (v) => onChanged(v.toInt()),
                ),
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _color.withOpacity(0.4)),
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _color,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('0 – Aucune', style: TextStyle(fontSize: 11, color: const Color(0xFF22C55E))),
              Text('10 – Max', style: TextStyle(fontSize: 11, color: const Color(0xFFEF4444))),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Assessment section card ───────────────────────────────────────────────────
class _AssessmentCard extends StatelessWidget {
  const _AssessmentCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Color color;
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
          // header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ── Choice group ──────────────────────────────────────────────────────────────
class _Choice<T> {
  const _Choice(this.value, this.label, this.icon);
  final T value;
  final String label;
  final IconData icon;
}

class _ChoiceGroup<T> extends StatelessWidget {
  const _ChoiceGroup({
    required this.selected,
    required this.options,
    required this.onSelect,
  });
  final T selected;
  final List<_Choice<T>> options;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.map((opt) {
        final isSelected = opt.value == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(opt.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                  right: opt == options.last ? 0 : 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : const Color(0xFFE4EBF5),
                  width: isSelected ? 2 : 1.5,
                ),
              ),
              child: Column(
                children: [
                  Icon(opt.icon,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFABBDCF),
                      size: 22),
                  const SizedBox(height: 4),
                  Text(
                    opt.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF8FA3BF),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Toggle row ────────────────────────────────────────────────────────────────
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF3D5470),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: value
                        ? AppColors.primary.withOpacity(0.1)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: value
                          ? AppColors.primary
                          : const Color(0xFFE4EBF5),
                      width: value ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: value ? AppColors.primary : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Oui',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: value ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: !value
                        ? const Color(0xFFEF4444).withOpacity(0.1)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !value
                          ? const Color(0xFFEF4444)
                          : const Color(0xFFE4EBF5),
                      width: !value ? 2 : 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.close_rounded,
                        color: !value ? const Color(0xFFEF4444) : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Non',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: !value ? const Color(0xFFEF4444) : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _QuestionLabel extends StatelessWidget {
  const _QuestionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF3D5470),
          fontWeight: FontWeight.w600,
        ),
      );
}

class _StepDot extends StatelessWidget {
  const _StepDot(
      {required this.active, required this.done, required this.label});
  final bool active;
  final bool done;
  final String label;

  @override
  Widget build(BuildContext context) {
    final bg = done
        ? AppColors.primary
        : active
            ? Colors.white
            : Colors.white.withOpacity(0.35);
    final textColor = done
        ? Colors.white
        : active
            ? AppColors.primary
            : Colors.white;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 32 : 24,
      height: active ? 32 : 24,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: active || done
            ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)]
            : [],
      ),
      child: Center(
        child: done
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
            : Text(label,
                style: TextStyle(
                    fontSize: active ? 14 : 12,
                    fontWeight: FontWeight.w700,
                    color: textColor)),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 2,
        color: Colors.white.withOpacity(0.4),
        margin: const EdgeInsets.symmetric(horizontal: 6),
      );
}

class _GradientButton extends StatelessWidget {
  const _GradientButton(
      {required this.label, required this.onPressed, this.trailingIcon});
  final String label;
  final VoidCallback onPressed;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF0A7E6E), Color(0xFF0DC9A8)]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6)),
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
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5)),
              if (trailingIcon != null) ...[
                const SizedBox(width: 8),
                Icon(trailingIcon, color: Colors.white, size: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}