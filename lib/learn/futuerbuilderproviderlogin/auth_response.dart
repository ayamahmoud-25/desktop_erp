import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthResponse {
  final bool success;
  final String? message;
  final String? authToken; // Example: you might receive an authentication token

  AuthResponse({required this.success, this.message, this.authToken});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'],
      authToken: json['token'], // Adjust key based on your API response
    );
  }
}

Future<AuthResponse> loginUser(String username, String password) async {
  final String apiUrl = 'YOUR_LOGIN_API_ENDPOINT_HERE'; // Replace with your actual login API endpoint

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