// lib/core/widgets/level_badge.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Colored badge displaying assessment level (1/2/3) with status text
/// 
/// Shows the severity level with color coding:
/// - Level 1: Red (CRITIQUE)
/// - Level 2: Orange (MODÉRÉ)
/// - Level 3: Green (BON)
class LevelBadge extends StatelessWidget {
  const LevelBadge({
    required this.level,
    required this.status,
    this.size = BadgeSize.large,
  });

  /// Assessment level (1, 2, or 3)
  final int level;

  /// Status text (CRITIQUE, MODÉRÉ, BON)
  final String status;

  /// Badge size
  final BadgeSize size;

  Color get _badgeColor {
    switch (level) {
      case 1:
        return AppColors.levelCritical;
      case 2:
        return AppColors.levelModerate;
      case 3:
        return AppColors.levelGood;
      default:
        return AppColors.textSecondary;
    }
  }

  double get _fontSize {
    switch (size) {
      case BadgeSize.small:
        return 12;
      case BadgeSize.medium:
        return 16;
      case BadgeSize.large:
        return 24;
    }
  }

  double get _statusFontSize {
    switch (size) {
      case BadgeSize.small:
        return 10;
      case BadgeSize.medium:
        return 12;
      case BadgeSize.large:
        return 14;
    }
  }

  double get _containerSize {
    switch (size) {
      case BadgeSize.small:
        return 60;
      case BadgeSize.medium:
        return 80;
      case BadgeSize.large:
        return 120;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Level circle badge
        Container(
          width: _containerSize,
          height: _containerSize,
          decoration: BoxDecoration(
            color: _badgeColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _badgeColor.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'N$level',
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.surface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Status text
        Text(
          status,
          style: TextStyle(
            fontSize: _statusFontSize,
            fontWeight: FontWeight.w600,
            color: _badgeColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Badge size variants
enum BadgeSize {
  small,
  medium,
  large,
}
