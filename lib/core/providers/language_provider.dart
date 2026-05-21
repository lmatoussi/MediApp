import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, french, arabic }

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  
  AppLanguage _currentLanguage = AppLanguage.english;
  SharedPreferences? _prefs;

  AppLanguage get currentLanguage => _currentLanguage;

  Locale get locale {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return const Locale('en');
      case AppLanguage.french:
        return const Locale('fr');
      case AppLanguage.arabic:
        return const Locale('ar');
    }
  }

  TextDirection get textDirection {
    return _currentLanguage == AppLanguage.arabic
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  String get languageName {
    switch (_currentLanguage) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.french:
        return 'Français';
      case AppLanguage.arabic:
        return 'العربية';
    }
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLanguage = _prefs?.getString(_languageKey);
    
    if (savedLanguage != null) {
      switch (savedLanguage) {
        case 'en':
          _currentLanguage = AppLanguage.english;
          break;
        case 'fr':
          _currentLanguage = AppLanguage.french;
          break;
        case 'ar':
          _currentLanguage = AppLanguage.arabic;
          break;
        default:
          _currentLanguage = AppLanguage.english;
      }
    }
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _currentLanguage = language;
    
    final languageCode = switch (language) {
      AppLanguage.english => 'en',
      AppLanguage.french => 'fr',
      AppLanguage.arabic => 'ar',
    };
    
    await _prefs?.setString(_languageKey, languageCode);
    notifyListeners();
  }
}
