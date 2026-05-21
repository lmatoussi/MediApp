import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medical_app/main.dart';
import 'package:medical_app/core/providers/language_provider.dart';
import 'package:medical_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:medical_app/features/auth/presentation/providers/admin_auth_provider.dart';
import 'package:medical_app/features/assessment/presentation/providers/patient_assessment_history_provider.dart';

void main() {
  testWidgets('MediLevel app smoke test', (WidgetTester tester) async {
    // Initialize providers
    final languageProvider = LanguageProvider();
    await languageProvider.init();
    
    final authProvider = AuthProvider();
    await authProvider.init();
    
    final adminAuthProvider = AdminAuthProvider();
    await adminAuthProvider.init();
    
    final historyProvider = PatientAssessmentHistoryProvider();
    await historyProvider.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MediLevelRoot(
        languageProvider: languageProvider,
        authProvider: authProvider,
        adminAuthProvider: adminAuthProvider,
        historyProvider: historyProvider,
      ),
    );

    // Verify that the login screen loads
    expect(find.byType(Scaffold), findsWidgets);
  });
}
