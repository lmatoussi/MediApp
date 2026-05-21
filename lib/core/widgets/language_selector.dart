import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../constants/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LanguageButton(
                label: 'العربية',
                flag: '🇸🇦',
                isSelected: languageProvider.currentLanguage == AppLanguage.arabic,
                onPressed: () {
                  languageProvider.setLanguage(AppLanguage.arabic);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _LanguageButton(
                label: 'Français',
                flag: '🇫🇷',
                isSelected: languageProvider.currentLanguage == AppLanguage.french,
                onPressed: () {
                  languageProvider.setLanguage(AppLanguage.french);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 12),
              _LanguageButton(
                label: 'English',
                flag: '🇬🇧',
                isSelected: languageProvider.currentLanguage == AppLanguage.english,
                onPressed: () {
                  languageProvider.setLanguage(AppLanguage.english);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final String flag;
  final bool isSelected;
  final VoidCallback onPressed;

  const _LanguageButton({
    required this.label,
    required this.flag,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.15) : Colors.grey[100],
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void showLanguageSelector(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Select Language',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const LanguageSelector(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

/// Reusable language button widget with badge indicator
class LanguageBadgeButton extends StatelessWidget {
  final bool showBadge;

  const LanguageBadgeButton({Key? key, this.showBadge = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: () => showLanguageSelector(context),
              tooltip: 'Select Language / اختر اللغة / Sélectionner la langue',
            ),
            if (showBadge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    languageProvider.currentLanguage == AppLanguage.english
                        ? 'EN'
                        : languageProvider.currentLanguage == AppLanguage.french
                            ? 'FR'
                            : 'AR',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
