// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/language_provider.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/admin_auth_provider.dart';
import 'routes.dart';

/// Main MaterialApp widget for MediLevel with role-based routing
class MediLevelApp extends StatelessWidget {
  const MediLevelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<LanguageProvider, AuthProvider, AdminAuthProvider>(
      builder: (context, languageProvider, authProvider, adminAuthProvider, _) {
        // Determine initial route based on login state
        String getInitialRoute() {
          // If admin is logged in, go to admin dashboard
          if (adminAuthProvider.isAuthenticated) {
            return '/admin_dashboard';
          }
          // If user is logged in, go directly to assessment
          if (authProvider.isLoggedIn) {
            return '/assessment';
          }
          // Default to login screen
          return '/';
        }

        return Directionality(
          textDirection: languageProvider.textDirection,
          child: MaterialApp(
            title: 'MediLevel',
            theme: AppTheme.lightTheme,
            locale: languageProvider.locale,
            initialRoute: getInitialRoute(),
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
