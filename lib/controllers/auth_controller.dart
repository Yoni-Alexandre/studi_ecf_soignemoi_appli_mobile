import 'package:flutter/material.dart';
import 'package:studi_ecf_soignemoi_appli_mobile/services/api_service.dart';

class AuthController with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    _isLoggedIn = await ApiService.login(email, password);
    print('isLoggedIn: $_isLoggedIn'); // Debugging statement
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
