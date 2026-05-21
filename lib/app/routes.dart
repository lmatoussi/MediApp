// lib/app/routes.dart

import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/admin_dashboard_screen.dart';
import '../features/patient/presentation/screens/patient_id_screen.dart';
import '../features/assessment/presentation/screens/assessment_screen.dart';
import '../features/assessment/presentation/screens/assessment_list_screen.dart';
import '../features/result/presentation/screens/result_screen.dart';
import '../features/exercise/presentation/screens/exercise_screen.dart';
import '../features/exercise/presentation/screens/exercise_detail_screen.dart';
import '../features/exercise/presentation/screens/workout_session_screen.dart';

/// Named routes for the application
class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String adminDashboard = '/admin_dashboard';
  static const String assessmentList = '/assessment_list';
  static const String patientId = '/patient_id';
  static const String assessment = '/assessment';
  static const String result = '/result';
  static const String exercises = '/exercises';
  static const String exerciseDetail = '/exercise_detail';
  static const String workoutSession = '/workout_session';

  /// Generate routes based on route name
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case assessmentList:
        return MaterialPageRoute(builder: (_) => const AssessmentListScreen());
      case patientId:
        // Redirect directly to assessment screen
        return MaterialPageRoute(builder: (_) => const AssessmentScreen());
      case assessment:
        return MaterialPageRoute(builder: (_) => const AssessmentScreen());
      case result:
        return MaterialPageRoute(builder: (_) => const ResultScreen());
      case exercises:
        // Extract level number from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final levelNumber = args?['level'] as int? ?? 3;
        return MaterialPageRoute(
          builder: (_) => ExerciseScreen(levelNumber: levelNumber),
        );
      case exerciseDetail:
        // Extract exercise from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final exercise = args?['exercise'];
        if (exercise == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Exercice non trouvé')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ExerciseDetailScreen(exercise: exercise),
        );
      case workoutSession:
        // Extract exercises list from arguments
        final args = settings.arguments as Map<String, dynamic>?;
        final exercises = args?['exercises'] as List?;
        final levelNumber = args?['levelNumber'] as int? ?? 3;
        if (exercises == null || exercises.isEmpty) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Aucun exercice trouvé')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => WorkoutSessionScreen(
            exercises: exercises.cast(),
            levelNumber: levelNumber,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }

  /// Get initial route
  static const String initialRoute = login;
}
