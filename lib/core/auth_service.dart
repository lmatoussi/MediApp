import 'package:medical_app/core/database_helper.dart';
import 'package:medical_app/core/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final DatabaseHelper _db = DatabaseHelper();
  late SharedPreferences _prefs;
  
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';
  static const String _tokenKey = 'auth_token';
  static const String _isAdminKey = 'is_admin';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // =============== LOGIN PATIENT ===============
  Future<bool> loginPatient(String email, String password) async {
    try {
      final user = await _db.loginPatient(email, password);
      
      if (user != null) {
        await _prefs.setInt(_userIdKey, user['id']);
        await _prefs.setString(_userEmailKey, user['email']);
        await _prefs.setString(_userRoleKey, 'patient');
        await _prefs.setBool(_isAdminKey, false);
        await _prefs.setString(_tokenKey, _generateToken());
        print('✅ Patient session saved');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error logging in patient: $e');
      return false;
    }
  }

  // =============== LOGIN ADMIN ===============
  Future<bool> loginAdmin(String email, String password) async {
    try {
      final admin = await _db.loginAdmin(email, password);
      
      if (admin != null) {
        print('🎉 ADMIN FOUND IN DATABASE!');
        await _prefs.setInt(_userIdKey, admin['id']);
        await _prefs.setString(_userEmailKey, admin['email']);
        await _prefs.setString(_userRoleKey, 'admin');
        await _prefs.setBool(_isAdminKey, true);
        await _prefs.setString(_tokenKey, _generateToken());
        print('✅ Admin session saved');
        return true;
      }
      print('❌ Admin not found in database');
      return false;
    } catch (e) {
      print('❌ Error logging in admin: $e');
      return false;
    }
  }

  // =============== REGISTER PATIENT ===============
  Future<bool> registerPatient({
    required String email,
    required String password,
    required String fullName,
    String? dateOfBirth,
    String? gender,
    String? phone,
    String? address,
    String? medicalHistory,
  }) async {
    try {
      final existingUsers = await _db.getAllPatients();
      if (existingUsers.any((u) => u['email'] == email)) {
        return false;
      }

      await _db.registerPatient({
        'email': email,
        'password': password,
        'full_name': fullName,
        'date_of_birth': dateOfBirth,
        'gender': gender,
        'phone': phone,
        'address': address,
        'medical_history': medicalHistory,
      });

      return await loginPatient(email, password);
    } catch (e) {
      print('Error registering patient: $e');
      return false;
    }
  }

  // =============== LOGOUT ===============
  Future<void> logout() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userRoleKey);
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_isAdminKey);
  }

  // =============== GETTERS ===============
  
  int? getCurrentUserId() => _prefs.getInt(_userIdKey);
  
  String? getCurrentEmail() => _prefs.getString(_userEmailKey);
  
  String? getCurrentRole() => _prefs.getString(_userRoleKey);
  
  String? getToken() => _prefs.getString(_tokenKey);
  
  bool isAdmin() => _prefs.getBool(_isAdminKey) ?? false;
  
  bool isLoggedIn() => _prefs.getString(_tokenKey) != null;

  // =============== HELPER METHODS ===============
  
  String _generateToken() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
