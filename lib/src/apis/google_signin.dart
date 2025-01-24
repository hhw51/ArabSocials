import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GoogleSigninService {
  static const String _baseUrl = 'http://35.222.126.155:8000'; // Use HTTPS
  static const String _googleSignInUrl = '$_baseUrl/users/google-signin/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Stores the JWT token securely.
  Future<void> Token(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  /// Retrieves the JWT token from secure storage.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, dynamic>> googleSignIn(String firebaseId, String email) async {
    try {
      print('Connecting to $_googleSignInUrl');

      final response = await http.post(
        Uri.parse(_googleSignInUrl),
        headers: {
          'Content-Type': 'application/json',
          // No need to include a token for initial sign-in
        },
        body: jsonEncode({
          'firebase_id': firebaseId,
          'email': email,
        }),
      ).timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Expected response structure with JWT token
        if (data.containsKey('token') && data.containsKey('message')) {
          final String token = data['token'];
          final String message = data['message'];

          // Store the JWT token securely
          await Token(token);

          return data as Map<String, dynamic>;
        } else {
          throw Exception('Invalid response structure.');
        }
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

  /// Example method to make an authenticated request using JWT
  Future<http.Response> makeAuthenticatedRequest(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('JWT token not found.');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    return response;
  }
}
