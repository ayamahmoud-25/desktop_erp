import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_response.dart';

class AuthService {
  Future<AuthResponse> login(String username, String password) async {
    final String apiUrl = 'YOUR_LOGIN_API_ENDPOINT_HERE'; // Replace with your API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(jsonDecode(response.body));
      } else {
        return AuthResponse(success: false, message: 'Login failed: ${response.statusCode}');
      }
    } catch (error) {
      return AuthResponse(success: false, message: 'Network error: $error');
    }
  }
}

