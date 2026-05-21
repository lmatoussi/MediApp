// lib/core/constants/app_colors.dart

import 'package:flutter/material.dart';

/// App-wide color constants following Material Design + medical accessibility
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary & Neutral
  static const Color primary = Color(0xFF1565C0); // Medical blue
  static const Color background = Color(0xFFF8F9FA); // Light gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF212121); // Dark gray/black
  static const Color textSecondary = Color(0xFF757575); // Medium gray
  static const Color divider = Color(0xFFE0E0E0); // Light divider

  // Assessment Levels (Severity)
  static const Color levelCritical = Color(0xFFD32F2F); // Deep red - Level 1
  static const Color levelModerate = Color(0xFFF57C00); // Deep orange - Level 2
  static const Color levelGood = Color(0xFF388E3C); // Deep green - Level 3

  // Status & Feedback
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1565C0);

  // Form & Input
  static const Color inputBorder = Color(0xFFBDBDBD);
  static const Color inputFocusBorder = Color(0xFF1565C0);
  static const Color inputDisabled = Color(0xFFF5F5F5);
}
