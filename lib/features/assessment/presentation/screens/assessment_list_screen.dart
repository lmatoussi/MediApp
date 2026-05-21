// lib/features/assessment/presentation/screens/assessment_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../core/providers/language_provider.dart';
import '../../presentation/providers/patient_assessment_history_provider.dart';
import 'assessment_detail_screen.dart';

class AssessmentListScreen extends StatefulWidget {
  const AssessmentListScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentListScreen> createState() => _AssessmentListScreenState();
}

class _AssessmentListScreenState extends State<AssessmentListScreen> {
  String _searchQuery = '';
  int? _filterLevel;

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, PatientAssessmentHistoryProvider>(
      builder: (context, languageProvider, historyProvider, _) {
        // Filter assessments based on search and filter
        var filteredAssessments = historyProvider.assessments;
        
        if (_searchQuery.isNotEmpty) {
          filteredAssessments = filteredAssessments
              .where((a) => a.patientName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
        }
        
        if (_filterLevel != null) {
          filteredAssessments = filteredAssessments
              .where((a) => a.levelNumber == _filterLevel)
              .toList();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patient Assessments'),
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
                  // Search and Filter Bar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search by patient name...',
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          onSelected: (value) {
                            setState(() {
                              _filterLevel = value == 'all' ? null : int.parse(value);
                            });
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'all',
                              child: Text('All'),
                            ),
                            const PopupMenuItem(
                              value: '1',
                              child: Text('Level 1 - Critical'),
                            ),
                            const PopupMenuItem(
                              value: '2',
                              child: Text('Level 2 - Moderate'),
                            ),
                            const PopupMenuItem(
                              value: '3',
                              child: Text('Level 3 - Good'),
                            ),
                          ],
                          icon: const Icon(Icons.filter_list),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Statistics
                  _buildStatsRow(context, historyProvider),
                  const SizedBox(height: 20),

                  // Recent Assessments Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Assessments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        '${filteredAssessments.length} found',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Assessment Cards
                  if (filteredAssessments.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              'No assessments found',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ...filteredAssessments.map((assessment) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildAssessmentCard(context, assessment),
                      );
                    }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context, PatientAssessmentHistoryProvider historyProvider) {
    final level1 = historyProvider.getAssessmentsByLevel(1).length;
    final level2 = historyProvider.getAssessmentsByLevel(2).length;
    final level3 = historyProvider.getAssessmentsByLevel(3).length;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Critical',
            level1.toString(),
            Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Moderate',
            level2.toString(),
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Good',
            level3.toString(),
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(BuildContext context, SavedAssessment assessment) {
    final levelColor = assessment.levelNumber == 1
        ? Colors.red
        : assessment.levelNumber == 2
            ? Colors.orange
            : Colors.green;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AssessmentDetailScreen(assessment: assessment),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Name and ID
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assessment.patientName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${assessment.patientId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Level Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: levelColor.withOpacity(0.1),
                    border: Border.all(color: levelColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'L${assessment.levelNumber}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: levelColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Assessment Score and Status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        assessment.status,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: levelColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getLevelLabel(assessment.levelNumber),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: levelColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${_formatDate(assessment.dateCompleted)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLevelLabel(int level) {
    switch (level) {
      case 1: return 'CRITICAL';
      case 2: return 'MODERATE';
      default: return 'GOOD';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
