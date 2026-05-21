// lib/features/auth/presentation/providers/admin_auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:medical_app/core/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AdminAuthStatus { initial, authenticating, authenticated, unauthenticated, error }

/// Provider for managing admin authentication
class AdminAuthProvider extends ChangeNotifier {
  AdminAuthStatus _status = AdminAuthStatus.initial;
  String? _adminEmail;
  String? _adminName;
  String? _errorMessage;
  bool _isLoading = false;

  static const String adminRegistrationEmail = 'admin@medical.app';

  final DatabaseHelper _db = DatabaseHelper();

  // Getters
  AdminAuthStatus get status => _status;
  String? get adminEmail => _adminEmail;
  String? get adminName => _adminName;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AdminAuthStatus.authenticated;
  bool get isLoading => _isLoading;

  /// Initialize admin auth state from SharedPreferences
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('admin_email');
      
      if (savedEmail != null) {
        _adminEmail = savedEmail;
        _adminName = prefs.getString('admin_name');
        _status = AdminAuthStatus.authenticated;
      } else {
        _status = AdminAuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AdminAuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// Admin account is seeded in the database and cannot be registered here.
  Future<String?> registerAdmin({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail != adminRegistrationEmail) {
      return 'Use admin@medical.app for the admin account';
    }

    return 'Admin account is managed in the database and cannot be registered here';
  }

  /// Authenticate admin with email and password
  Future<bool> loginAdmin(String email, String password) async {
    _isLoading = true;
    _status = AdminAuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();

    try {
      final normalizedEmail = email.trim().toLowerCase();
      final normalizedPassword = password.trim();
      final admin = await _db.loginAdmin(normalizedEmail, normalizedPassword);

      if (admin == null) {
        _status = AdminAuthStatus.error;
        _errorMessage = 'Invalid admin credentials';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('admin_email', admin['email'] as String);
      await prefs.setString(
        'admin_name',
        (admin['full_name'] as String?) ?? 'Administrator',
      );

      _adminEmail = normalizedEmail;
      _adminName = (admin['full_name'] as String?) ?? 'Administrator';
      _status = AdminAuthStatus.authenticated;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AdminAuthStatus.error;
      _errorMessage = 'Authentication error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout admin
  Future<void> logoutAdmin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('admin_email');
      await prefs.remove('admin_name');

      _adminEmail = null;
      _adminName = null;
      _status = AdminAuthStatus.unauthenticated;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout error: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
