import 'package:get/get.dart';

class UIHelper {
  static void showError(String title, String message) {
    Get.snackbar(title, message);
  }

  static void showSuccess(String title, String message) {
    Get.snackbar(title, message);
  }

  static bool validateEmailPassword(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      showError("Validation Error", "Email and password are required");
      return false;
    }
    return true;
  }

  static bool validateSignup(String email, String pass, String confirm) {
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      showError("Validation Error", "Please fill all fields");
      return false;
    }
    if (pass != confirm) {
      showError("Password Error", "Passwords do not match");
      return false;
    }
    return true;
  }
}
