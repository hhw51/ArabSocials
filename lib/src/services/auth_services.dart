import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // <-- Added import
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://192.168.137.1:8000';

  static const String _signUpUrl = '$_baseUrl/users/signup/';
  static const String _loginUrl = '$_baseUrl/users/login/';
  static const String _sendOtpUrl = '$_baseUrl/users/send-otp/';
  static const String _verifyOtpUrl = '$_baseUrl/users/verify-otp/';

  // In-memory + Secure Storage
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    try {
      print('Connecting to $_loginUrl');
      print('Email: $email');
      print('Password: $password');

      final response = await http
          .post(
        Uri.parse(_loginUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ Login successful: ${response.body}");

        final responseData = jsonDecode(response.body);

        // If the server returns a token, store it using secure storage
        if (responseData['token'] != null) {
          await _secureStorage.write(key: 'token', value: responseData['token']);
          print('Token saved to secure storage: ${responseData['token']}');
        }

        return responseData;
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

      final response = await http
          .post(
        Uri.parse(_signUpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Signup successful: ${response.body}");

        // Parse response and store token if present
        final responseData = jsonDecode(response.body);
        if (responseData['token'] != null) {
          await _secureStorage.write(key: 'token', value: responseData['token']);
          print('Token saved to secure storage: ${responseData['token']}');
        }

        return responseData;
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

  /// Send OTP API call
  Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
    };

    try {
      print('Connecting to $_sendOtpUrl');
      print('Email: $email');

      final response = await http
          .post(
        Uri.parse(_sendOtpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ OTP request successful: ${response.body}");
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

  /// Verify OTP API call
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final Map<String, dynamic> body = {
      'email': email,
      'otp': otp,
    };

    try {
      print('Connecting to $_verifyOtpUrl');
      print('Email: $email, OTP: $otp');

      final response = await http
          .post(
        Uri.parse(_verifyOtpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ OTP verification successful: ${response.body}");

        // Parse response and store token if present
        final responseData = jsonDecode(response.body);
        if (responseData['token'] != null) {
          await _secureStorage.write(key: 'token', value: responseData['token']);
          print('Token saved to secure storage: ${responseData['token']}');
        }

        return responseData;
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
