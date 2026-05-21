import 'package:crypto/crypto.dart';

class PasswordHelper {
  static String hashPassword(String password) {
    // Utiliser UTF8 pour plus de compatibilité
    return sha256.convert(password.codeUnits).toString();
  }

  static bool verifyPassword(String password, String hash) {
    return hashPassword(password) == hash;
  }

  static String debugHash(String password) {
    String hash = hashPassword(password);
    print('🔐 Password: "$password" → Hash: $hash');
    return hash;
  }
}
