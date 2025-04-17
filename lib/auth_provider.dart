import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isLoggedIn = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    notifyListeners();
  }

  bool login() {
    // Simple authentication for demo
    if (usernameController.text == 'admin' && passwordController.text == 'password1') {
      isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}