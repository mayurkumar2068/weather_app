import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _sessionKey = "supabase_session";
  static const String _userNameKey = "user_name";

  /// Save session
  static Future<void> saveSession(String sessionJson) async {
    await _storage.write(key: _sessionKey, value: sessionJson);
  }

  /// Read session
  static Future<String?> getSession() async {
    return await _storage.read(key: _sessionKey);
  }

  static Future<void> saveString(String userName) async {
    await _storage.write(key: _userNameKey, value: userName);
  }

  /// Read session
  static Future<String?> getString() async {
    return await _storage.read(key: _userNameKey);
  }

  /// Delete session
  static Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }
}
