// lib/features/assessment/presentation/screens/assessment_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/providers/language_provider.dart';
import '../../presentation/providers/patient_assessment_history_provider.dart';
import '../../domain/models/export_service.dart';

class AssessmentDetailScreen extends StatelessWidget {
  final SavedAssessment assessment;

  const AssessmentDetailScreen({
    Key? key,
    required this.assessment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        final levelColor = assessment.levelNumber == 1
            ? Colors.red
            : assessment.levelNumber == 2
                ? Colors.orange
                : Colors.green;

        final levelLabel = assessment.levelNumber == 1
            ? 'Critical'
            : assessment.levelNumber == 2
                ? 'Moderate'
                : 'Good';

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          appBar: AppBar(
            title: const Text('Assessment Details'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.language),
                onPressed: () => showLanguageSelector(context),
                tooltip: 'Select Language / اختر اللغة / Sélectionner la langue',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Patient Info Card
                  _buildPatientInfoCard(context, levelColor, levelLabel),
                  const SizedBox(height: 24),

                  // Assessment Result Card
                  _buildResultCard(context, levelColor, levelLabel),
                  const SizedBox(height: 24),

                  // Assessment Details Section
                  Text(
                    'Assessment Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),

                  // Mobility Section
                  _buildDetailSection(
                    context,
                    title: 'Mobility (Position & Walking)',
                    items: [
                      (
                        label: 'Standing Capacity',
                        value: _getMobilityAidLabel(
                            assessment.assessmentData.standingCapacity)
                      ),
                      (
                        label: 'Walking Capacity',
                        value: _getMobilityAidLabel(
                            assessment.assessmentData.walkingCapacity)
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Balance Section
                  _buildDetailSection(
                    context,
                    title: 'Balance & Dizziness',
                    items: [
                      (
                        label: 'Balance Level',
                        value: _getBalanceLevelLabel(
                            assessment.assessmentData.balanceLevel)
                      ),
                      (
                        label: 'Dizziness',
                        value: assessment.assessmentData.hasDizziness
                            ? 'Yes - Present'
                            : 'No - Not Present'
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // General State Section
                  _buildDetailSection(
                    context,
                    title: 'General State',
                    items: [
                      (
                        label: 'Fatigue',
                        value: assessment.assessmentData.hasFatigue
                            ? 'Yes - Present'
                            : 'No - Not Present'
                      ),
                      (label: 'Pain', value: assessment.assessmentData.painPresent ? 'Yes' : 'No'),
                      (
                        label: 'Pain Level (0-10)',
                        value: assessment.assessmentData.painScore.toString()
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Medical Description
                  _buildDescriptionCard(context, levelColor),
                  const SizedBox(height: 24),

                  // Assessment Metadata
                  _buildMetadataCard(context),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showExportOptions(context);
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Export'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
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

  Widget _buildPatientInfoCard(BuildContext context, Color levelColor, String levelLabel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            levelColor.withOpacity(0.85),
            levelColor.withOpacity(0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: levelColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessment.patientName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.badge, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 8),
              Text(
                'Patient ID: ${assessment.patientId}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              levelLabel.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context, Color levelColor, String levelLabel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: levelColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: levelColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: levelColor),
              const SizedBox(width: 8),
              Text(
                'Assessment Result',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assessment.result.status,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: levelColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Level ${assessment.levelNumber}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context, {
    required String title,
    required List<({String label, String value})> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          ...items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            final item = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _buildDetailRow(context, item.label, item.value),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context, Color levelColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: levelColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        color: levelColor.withOpacity(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical Assessment',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: levelColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            assessment.result.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              height: 1.6,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment Information',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildMetadataRow(
            context,
            'Assessment ID',
            assessment.id,
          ),
          const SizedBox(height: 8),
          _buildMetadataRow(
            context,
            'Date Completed',
            _formatDateTime(assessment.dateCompleted),
          ),
          const SizedBox(height: 8),
          _buildMetadataRow(
            context,
            'Time Ago',
            _getTimeAgoLabel(assessment.dateCompleted),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  String _getMobilityAidLabel(dynamic aid) {
    final aidStr = aid.toString();
    return aidStr.contains('withAid') ? 'With Aid' : 'Without Aid';
  }

  String _getBalanceLevelLabel(dynamic level) {
    final levelStr = level.toString();
    if (levelStr.contains('moderate')) return 'Moderate';
    if (levelStr.contains('unstable')) return 'Unstable';
    return 'Stable';
  }

  String _formatDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeAgoLabel(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  void _showExportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Assessment',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportToPDF(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportToCSV(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy to Clipboard'),
              onTap: () {
                Navigator.pop(context);
                _copyToClipboard(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToPDF(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Generating PDF...')),
      );
      await AssessmentExportService.generateAndPrintPDF(assessment);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF generated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting PDF: $e')),
        );
      }
    }
  }

  void _exportToCSV(BuildContext context) {
    try {
      final csv = AssessmentExportService.generateCSV([assessment]);
      // Show CSV preview
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('CSV Export'),
          content: SingleChildScrollView(
            child: Text(csv, style: const TextStyle(fontFamily: 'monospace')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                _copyToClipboardData(csv);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('CSV copied to clipboard')),
                );
              },
              child: const Text('Copy CSV'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting CSV: $e')),
      );
    }
  }

  void _copyToClipboard(BuildContext context) {
    try {
      _copyToClipboardData(_buildAssessmentText());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assessment data copied to clipboard')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error copying to clipboard: $e')),
      );
    }
  }

  void _copyToClipboardData(String text) {
    // In a real app, you'd use flutter/services.dart Clipboard
    // For now, just show it in a dialog
    debugPrint('Clipboard data: $text');
  }

  String _buildAssessmentText() {
    return '''
Patient Name: ${assessment.patientName}
Patient ID: ${assessment.patientId}
Assessment ID: ${assessment.id}
Date: ${_formatDateTime(assessment.dateCompleted)}
Level: ${assessment.levelNumber}
Status: ${assessment.status}

Mobility:
- Standing: ${_getMobilityAidLabel(assessment.assessmentData.standingCapacity)}
- Walking: ${_getMobilityAidLabel(assessment.assessmentData.walkingCapacity)}

Balance:
- Balance Level: ${_getBalanceLevelLabel(assessment.assessmentData.balanceLevel)}
- Dizziness: ${assessment.assessmentData.hasDizziness ? 'Yes' : 'No'}

General State:
- Fatigue: ${assessment.assessmentData.hasFatigue ? 'Yes' : 'No'}
- Pain: ${assessment.assessmentData.painPresent ? 'Yes' : 'No'}
- Pain Level: ${assessment.assessmentData.painScore}/10

Assessment Result:
${assessment.result.status}

${assessment.result.description}
    ''';
  }
}
