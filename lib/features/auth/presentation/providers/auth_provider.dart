// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for storing user credentials
class UserCredentials {
  final String email;
  final String password;

  UserCredentials({
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'UserCredentials(email: $email)';
}

/// Auth provider managing user registration and login
/// 
/// Handles:
/// - User registration (storing credentials persistently in SharedPreferences)
/// - User login validation
/// - Session management
class AuthProvider extends ChangeNotifier {
  final Map<String, UserCredentials> _registeredUsers = {
    'test@medilevel.com': UserCredentials(
      email: 'test@medilevel.com',
      password: 'password123',
    ),
  };

  String? _currentUserEmail;
  bool _isLoading = false;

  String? get currentUserEmail => _currentUserEmail;
  bool get isLoggedIn => _currentUserEmail != null;
  bool get isLoading => _isLoading;

  /// Initialize - Load users from SharedPreferences
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('current_user_email');
      if (savedEmail != null) {
        _currentUserEmail = savedEmail;
      }
    } catch (e) {
      debugPrint('Error loading auth state: $e');
    }
    notifyListeners();
  }

  /// Register a new user
  /// 
  /// Returns:
  /// - `null` if registration successful
  /// - Error message if registration fails
  Future<String?> registerUser({
    required String email,
    required String password,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      return 'Email invalide';
    }

    // Validate password length
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }

    // Check if user already exists
    if (_registeredUsers.containsKey(email)) {
      return 'Cet email est déjà enregistré';
    }

    // Register user
    _registeredUsers[email] = UserCredentials(
      email: email,
      password: password,
    );

    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      // Store user list as JSON for persistence
      final userList = _registeredUsers.entries
          .map((e) => '${e.key}|${e.value.password}')
          .join(';');
      await prefs.setString('registered_users', userList);
    } catch (e) {
      debugPrint('Error saving users: $e');
    }

    notifyListeners();
    return null; // Success
  }

  /// Authenticate user login
  /// 
  /// Returns:
  /// - `true` if credentials are correct
  /// - `false` if credentials are incorrect
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (!_registeredUsers.containsKey(email)) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final user = _registeredUsers[email]!;
      if (user.password != password) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _currentUserEmail = email;
      
      // Save login state to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user_email', email);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_email');
    } catch (e) {
      debugPrint('Error clearing login state: $e');
    }
    
    _currentUserEmail = null;
    notifyListeners();
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Get all registered users (for debugging)
  Map<String, UserCredentials> get registeredUsers => Map.unmodifiable(_registeredUsers);
}
