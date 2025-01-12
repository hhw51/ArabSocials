import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; 
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://35.222.126.155:8000';

  static const String _signUpUrl = '$_baseUrl/users/signup/';
  static const String _loginUrl = '$_baseUrl/users/login/';
  static const String _sendOtpUrl = '$_baseUrl/users/send-otp/';
  static const String _verifyOtpUrl = '$_baseUrl/users/verify-otp/';
  static const String _updateUserUrl = '$_baseUrl/users/update-user/';
  static const String _getUserInfoUrl = '$_baseUrl/users/get-user-info/';

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
Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String location,
    File? image,
    required String nationality,
    required String gender,
    required String dob,
    required String aboutMe,
    required String maritalStatus,
    required String interests,
    required String profession,
  }) async {
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      var request = http.MultipartRequest('PUT', Uri.parse(_updateUserUrl));

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
      });

      // Add fields
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['location'] = location;
      request.fields['nationality'] = nationality;
      request.fields['gender'] = gender;
      request.fields['dob'] = dob;
      request.fields['about_me'] = aboutMe;
      request.fields['marital_status'] = maritalStatus;
      request.fields['interests'] = interests;
      request.fields['profession'] = profession;

      // Add file if available
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
      }

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Profile updated successfully: $responseBody");
        getUserInfo();
        return jsonDecode(responseBody);

      } else {
        throw Exception('❌ Error: ${response.statusCode} - $responseBody');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse(_getUserInfoUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

}
