import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'auth_state.dart';
import '../../ui/home/home_page.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.initial;

  String? _errorMessage;
  String? _authToken;

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get authToken => _authToken;

  Future<void> login(BuildContext context, String username, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    final response = await _authService.login(username, password);

    if (response.success) {
      _state = AuthState.success;
      _authToken = response.authToken;
      notifyListeners();
      // Navigate to home page after successful login
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(authToken: _authToken)),
      );*/
    } else {
      _state = AuthState.error;
      _errorMessage = response.message;
      notifyListeners();
    }
  }
}