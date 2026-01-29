import 'package:supabase_flutter/supabase_flutter.dart';

import '../../database/storage.dart';

class SessionService {
  static Future<bool> hasSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) return false;
      final user = session.user;
      final name =
          user.userMetadata?['name'] ??
              user.email?.split("@").first ??
              "User";

      print("User name: $name");
      await SecureStorage.saveString(name);

      return true;
    } catch (e) {
      print("Session error: $e");
      return false;
    }
  }
}
