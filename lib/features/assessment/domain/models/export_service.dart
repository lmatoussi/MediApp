// lib/features/assessment/domain/models/export_service.dart

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../presentation/providers/patient_assessment_history_provider.dart';

class AssessmentExportService {
  /// Generate PDF for a single assessment
  static Future<void> generateAndPrintPDF(SavedAssessment assessment) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          // Header
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ASSESSMENT REPORT',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Functional Assessment for Stroke Recovery',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Patient Information
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PATIENT INFORMATION',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              _buildPDFRow('Patient Name', assessment.patientName),
              _buildPDFRow('Patient ID', assessment.patientId),
              _buildPDFRow('Assessment ID', assessment.id),
              _buildPDFRow(
                'Date Completed',
                _formatPDFDateTime(assessment.dateCompleted),
              ),
              _buildPDFRow('Assessment Level', 'Level ${assessment.levelNumber}'),
              _buildPDFRow('Status', assessment.status),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Assessment Results
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ASSESSMENT RESULTS',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                assessment.result.status,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: _getLevelPDFColor(assessment.levelNumber),
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(assessment.result.description),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),

          // Assessment Details
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'DETAILED ASSESSMENT DATA',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              // Mobility Section
              pw.Text(
                'Mobility Assessment',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              _buildPDFRow(
                'Standing Capacity',
                _getMobilityAidLabel(assessment.assessmentData.standingCapacity),
              ),
              _buildPDFRow(
                'Walking Capacity',
                _getMobilityAidLabel(assessment.assessmentData.walkingCapacity),
              ),
              pw.SizedBox(height: 12),

              // Balance Section
              pw.Text(
                'Balance & Dizziness',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              _buildPDFRow(
                'Balance Level',
                _getBalanceLevelLabel(assessment.assessmentData.balanceLevel),
              ),
              _buildPDFRow(
                'Dizziness',
                assessment.assessmentData.hasDizziness ? 'Yes - Present' : 'No',
              ),
              pw.SizedBox(height: 12),

              // General State Section
              pw.Text(
                'General State',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 6),
              _buildPDFRow(
                'Fatigue',
                assessment.assessmentData.hasFatigue ? 'Yes' : 'No',
              ),
              _buildPDFRow(
                'Pain',
                assessment.assessmentData.painPresent ? 'Yes' : 'No',
              ),
              _buildPDFRow(
                'Pain Level (0-10)',
                assessment.assessmentData.painScore.toString(),
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          // Footer
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text(
            'Report generated on ${DateTime.now().toString().split('.')[0]}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate CSV for multiple assessments
  static String generateCSV(List<SavedAssessment> assessments) {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln('Assessment ID,Patient ID,Patient Name,Date Completed,Level,Status,'
        'Standing Capacity,Walking Capacity,Dizziness,Balance Level,Fatigue,Pain,Pain Level');

    // CSV Rows
    for (final assessment in assessments) {
      buffer.writeln(
        '"${assessment.id}",'
        '"${assessment.patientId}",'
        '"${assessment.patientName}",'
        '"${_formatCSVDateTime(assessment.dateCompleted)}",'
        '${assessment.levelNumber},'
        '"${assessment.status}",'
        '"${_getMobilityAidLabel(assessment.assessmentData.standingCapacity)}",'
        '"${_getMobilityAidLabel(assessment.assessmentData.walkingCapacity)}",'
        '${assessment.assessmentData.hasDizziness ? 'Yes' : 'No'},'
        '"${_getBalanceLevelLabel(assessment.assessmentData.balanceLevel)}",'
        '${assessment.assessmentData.hasFatigue ? 'Yes' : 'No'},'
        '${assessment.assessmentData.painPresent ? 'Yes' : 'No'},'
        '${assessment.assessmentData.painScore}',
      );
    }

    return buffer.toString();
  }

  // Helper methods
  static pw.Widget _buildPDFRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  static String _formatPDFDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _formatCSVDateTime(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
           '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String _getMobilityAidLabel(dynamic aid) {
    final aidStr = aid.toString();
    return aidStr.contains('withAid') ? 'With Aid' : 'Without Aid';
  }

  static String _getBalanceLevelLabel(dynamic level) {
    final levelStr = level.toString();
    if (levelStr.contains('moderate')) return 'Moderate';
    if (levelStr.contains('unstable')) return 'Unstable';
    return 'Stable';
  }

  static PdfColor _getLevelPDFColor(int level) {
    switch (level) {
      case 1:
        return PdfColors.red;
      case 2:
        return PdfColors.orange;
      default:
        return PdfColors.green;
    }
  }
}
