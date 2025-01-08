import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://192.168.0.8:8000';

  static const String _signUpUrl = '$_baseUrl/users/signup/';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  /// Generic signup API call
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
    };

    try {
  print('Connecting to $_signUpUrl');
  print('Connecting to $name');
  print('Connecting to $email');
  print('Connecting to $password');
  final response = await http.post(
    Uri.parse(_signUpUrl),
    headers: headers,
    body: jsonEncode(body),
  ).timeout(const Duration(seconds: 60));

  print('Response Status: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("✅ Signup successful: ${response.body}");
    return jsonDecode(response.body);
  } else {
    throw Exception('❌ Error: ${response.statusCode} - ${response.body}');
  }
} on SocketException catch (e) {
  print('🌐 No Internet connection: $e');
  throw Exception('🌐 No Internet connection');
} on TimeoutException catch (e) {
  print('⏳ Request timed out: $e');
  throw Exception('⏳ Request timed out');
} catch (e) {
  print('⚠️ Unexpected error: $e');
  throw Exception('⚠️ Unexpected error: $e');
}

  }
}
