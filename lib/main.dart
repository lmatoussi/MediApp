// lib/main.dart

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app/app.dart';
import 'core/providers/language_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/providers/admin_auth_provider.dart';
import 'features/patient/presentation/providers/patient_provider.dart';
import 'features/assessment/presentation/providers/assessment_provider.dart';
import 'features/assessment/presentation/providers/patient_assessment_history_provider.dart';

void main() async {
  // Initialize database factory FIRST for desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    print('✅ Database factory initialized for desktop');
  }
  
  // Then initialize Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  final languageProvider = LanguageProvider();
  await languageProvider.init();
  
  final authProvider = AuthProvider();
  await authProvider.init();
  
  final adminAuthProvider = AdminAuthProvider();
  await adminAuthProvider.init();
  
  final historyProvider = PatientAssessmentHistoryProvider();
  await historyProvider.init();
  
  runApp(MediLevelRoot(
    languageProvider: languageProvider,
    authProvider: authProvider,
    adminAuthProvider: adminAuthProvider,
    historyProvider: historyProvider,
  ));
}

/// Root widget with multi-provider setup for state management
class MediLevelRoot extends StatelessWidget {
  final LanguageProvider languageProvider;
  final AuthProvider authProvider;
  final AdminAuthProvider adminAuthProvider;
  final PatientAssessmentHistoryProvider historyProvider;
  
  const MediLevelRoot({
    Key? key,
    required this.languageProvider,
    required this.authProvider,
    required this.adminAuthProvider,
    required this.historyProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: adminAuthProvider),
        ChangeNotifierProvider.value(value: historyProvider),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
      ],
      child: const MediLevelApp(),
    );
  }
}
