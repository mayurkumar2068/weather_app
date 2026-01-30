import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../database/storage.dart';

class SessionService {
  static Future<bool> hasSession() async {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) return false;
      final user = session.user;
      final name =
          user.userMetadata?['name'] ?? user.email?.split("@").first ?? "User";

      if (kDebugMode) {
        debugPrint("User name: $name");
      }
      await SecureStorage.saveString(name);

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Session error: $e");
      }
      return false;
    }
  }
}
