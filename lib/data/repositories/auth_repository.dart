import '../../core/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = Provider<AuthViewModel>((ref) {
  return AuthViewModel();
});

class AuthViewModel {
  final _service = AuthService();

  Future<void> login(String email, String password) {
    return _service.login(email, password);
  }

  Future<void> signup(String email, String password) {
    return _service.signup(email, password);
  }

  Future<void> logout() {
    return _service.logout();
  }
}
