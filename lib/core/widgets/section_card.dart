// lib/core/widgets/section_card.dart

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Card wrapper for form sections with title and content
/// 
/// Used to group related form fields (e.g., "Mobilité", "Équilibre", "État général")
class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 12),
  });

  /// Section title (e.g., "Mobilité", "Équilibre")
  final String title;

  /// Content widget(s) inside the card
  final Widget child;

  /// Inner padding
  final EdgeInsets padding;

  /// Outer margin
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: padding,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Divider
          Divider(
            height: 0,
            thickness: 1,
            color: AppColors.divider,
          ),
          // Content
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
