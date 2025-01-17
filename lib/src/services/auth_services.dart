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

  // Business API Endpoints
  static const String _getOtherBusinessUsersUrl = '$_baseUrl/users/get-other-business-users/';
  static const String _getBusinessUsersWithSameLocationUrl = '$_baseUrl/users/get-business-users-with-same-location/';
  static const String _getFavoriteBusinessUsersUrl = '$_baseUrl/users/get-favorite-bussiness-users/';
  static const String _getSavedEventsUrl = '$_baseUrl/events/get_saved_events/';
  static const String _getFavoriteUsersUrl = '$_baseUrl/users/get-favorite-users/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Login Method
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    print('🔍 [login] Method called with email: $email');
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };

    try {
      print('🔗 [login] Connecting to $_loginUrl');
      print('🔗 [login] Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(_loginUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('📬 [login] Response Status: ${response.statusCode}');
      print('📬 [login] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ [login] Login successful: ${response.body}");

        final responseData = jsonDecode(response.body);
        if (responseData['token'] != null) {
          await _secureStorage.write(
              key: 'token', value: responseData['token']);
          print(
              '🔐 [login] Token saved to secure storage: ${responseData['token']}');
        }

        if (responseData['user'] != null &&
            responseData['user']['id'] != null) {
          await _secureStorage.write(
              key: 'id', value: responseData['user']['id'].toString());
          print(
              '🔐 [login] User ID saved to secure storage: ${responseData['user']['id']}');
        } else {
          print('❌ [login] user_id not found in the response.');
          throw Exception('❌ user_id not found in the response.');
        }

        return responseData;
      } else {
        print('❌ [login] Error: ${response.statusCode} - ${response.body}');
        throw Exception('❌ Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      print('🌐 [login] No Internet connection: $e');
      throw Exception('🌐 No Internet connection');
    } on TimeoutException catch (e) {
      print('⏳ [login] Request timed out: $e');
      throw Exception('⏳ Request timed out');
    } catch (e) {
      print('⚠️ [login] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [login] Method execution completed.');
    }
  }

  Future<int?> getUserId() async {
    try {
      final userIdString = await _secureStorage.read(key: 'id');
      if (userIdString != null && userIdString.isNotEmpty) {
        return int.parse(userIdString);
      }
      return null;
    } catch (e) {
      print('⚠️ [getUserId] Unexpected error: $e');
      return null;
    }
  }

  /// Generic signup API call
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String email,
    required String password,
    String? account_type,
    String? phone,
  }) async {
    print('🔍 [signUp] Method called with name: $name, email: $email');
    final Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
      'account_type': account_type,
      'phone': phone,
    };

    try {
      print('🔗 [signUp] Connecting to $_signUpUrl');
      print('🔗 [signUp] Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(_signUpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('📬 [signUp] Response Status: ${response.statusCode}');
      print('📬 [signUp] Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ [signUp] Signup successful: ${response.body}");
        final responseData = jsonDecode(response.body);

        if (responseData['token'] != null) {
          await _secureStorage.write(
              key: 'token', value: responseData['token']);
          print(
              '🔐 [signUp] Token saved to secure storage: ${responseData['token']}');
        }

        if (responseData['user'] != null &&
            responseData['user']['id'] != null) {
          await _secureStorage.write(
              key: 'id', value: responseData['user']['id'].toString());
          print(
              '🔐 [signUp] User ID saved to secure storage: ${responseData['user']['id']}');
        } else {
          print('❌ [signUp] user_id not found in the response.');
          throw Exception('❌ user_id not found in the response.');
        }

        // **Return only the response data directly**
        return responseData;
      } else {
        final errorBody = jsonDecode(response.body);
        print('❌ [signUp] Error: ${response.statusCode} - ${response.body}');
        // **Return only the error message**
        return {'error': errorBody['error'] ?? 'Signup failed'};
      }
    } on SocketException catch (e) {
      print('🌐 [signUp] No Internet connection: $e');
      throw Exception('🌐 No Internet connection');
    } on TimeoutException catch (e) {
      print('⏳ [signUp] Request timed out: $e');
      throw Exception('⏳ Request timed out');
    } catch (e) {
      print('⚠️ [signUp] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [signUp] Method execution completed.');
    }
  }
  /// Send OTP API call
  Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    print('🔍 [sendOtp] Method called with email: $email');
    final Map<String, dynamic> body = {
      'email': email,
    };

    try {
      print('🔗 [sendOtp] Connecting to $_sendOtpUrl');
      print('🔗 [sendOtp] Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(_sendOtpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('📬 [sendOtp] Response Status: ${response.statusCode}');
      print('📬 [sendOtp] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ [sendOtp] OTP request successful: ${response.body}");
        return jsonDecode(response.body);
      } else {
        print('❌ [sendOtp] Error: ${response.statusCode} - ${response.body}');
        throw Exception('❌ Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      print('🌐 [sendOtp] No Internet connection: $e');
      throw Exception('🌐 No Internet connection');
    } on TimeoutException catch (e) {
      print('⏳ [sendOtp] Request timed out: $e');
      throw Exception('⏳ Request timed out');
    } catch (e) {
      print('⚠️ [sendOtp] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [sendOtp] Method execution completed.');
    }
  }

  /// Verify OTP API call
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    print('🔍 [verifyOtp] Method called with email: $email, otp: $otp');
    final Map<String, dynamic> body = {
      'email': email,
      'otp': otp,
    };

    try {
      print('🔗 [verifyOtp] Connecting to $_verifyOtpUrl');
      print('🔗 [verifyOtp] Request Body: ${jsonEncode(body)}');

      final response = await http
          .post(
        Uri.parse(_verifyOtpUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('📬 [verifyOtp] Response Status: ${response.statusCode}');
      print('📬 [verifyOtp] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ [verifyOtp] OTP verification successful: ${response.body}");
        final responseData = jsonDecode(response.body);
        if (responseData['token'] != null) {
          await _secureStorage.write(
              key: 'token', value: responseData['token']);
          print(
              '🔐 [verifyOtp] Token saved to secure storage: ${responseData['token']}');
        }

        return responseData;
      } else {
        print('❌ [verifyOtp] Error: ${response.statusCode} - ${response.body}');
        throw Exception('❌ Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      print('🌐 [verifyOtp] No Internet connection: $e');
      throw Exception('🌐 No Internet connection');
    } on TimeoutException catch (e) {
      print('⏳ [verifyOtp] Request timed out: $e');
      throw Exception('⏳ Request timed out');
    } catch (e) {
      print('⚠️ [verifyOtp] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [verifyOtp] Method execution completed.');
    }
  }

  // Update Profile Method
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
    required List<String> interests,
    required String profession, required String token,
  }) async {
    print(
        '🔍 [updateProfile] Method called with name: $name, phone: $phone, location: $location');
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('❌ [updateProfile] No token found. Please log in again.');
        throw Exception('No token found. Please log in again.');
      }
      print('🔐 [updateProfile] Retrieved token: $token');

      var request = http.MultipartRequest('PUT', Uri.parse(_updateUserUrl));

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
      });
      print('🔗 [updateProfile] Headers added to request.');

      // Add fields
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['location'] = location;
      request.fields['nationality'] = nationality;
      request.fields['gender'] = gender;
      request.fields['dob'] = dob;
      request.fields['about_me'] = aboutMe;
      request.fields['marital_status'] = maritalStatus;
      request.fields['interests'] = jsonEncode(interests);
      request.fields['profession'] = profession;
      print('🔗 [updateProfile] Fields added to request.');

      // Add file if available
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
        print('📁 [updateProfile] Image file added to request: ${image.path}');
      } else {
        print('📁 [updateProfile] No image file provided.');
      }

      // Send request
      print('🔗 [updateProfile] Sending multipart request to $_updateUserUrl');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('📬 [updateProfile] Response Status: ${response.statusCode}');
      print('📬 [updateProfile] Response Body: $responseBody');

      if (response.statusCode == 200) {
        print("✅ [updateProfile] Profile updated successfully: $responseBody");
        await getUserInfo(token: token);
        return jsonDecode(responseBody);
      } else {
        print(
            '❌ [updateProfile] Error: ${response.statusCode} - $responseBody');
        throw Exception('❌ Error: ${response.statusCode} - $responseBody');
      }
    } on SocketException {
      print('🌐 [updateProfile] No Internet connection');
      throw Exception('No Internet connection');
    } catch (e) {
      print('⚠️ [updateProfile] Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      print('🔍 [updateProfile] Method execution completed.');
    }
  }

  // Get User Info Method
  Future<Map<String, dynamic>> getUserInfo({required String token}) async {
    print('🔍 [getUserInfo] Method called.');
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('❌ [getUserInfo] No token found. Please log in again.');
        throw Exception('No token found. Please log in again.');
      }
      print('🔐 [getUserInfo] Retrieved token: $token');

      print('🔗 [getUserInfo] Sending GET request to $_getUserInfoUrl');
      final response = await http.get(
        Uri.parse(_getUserInfoUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📬 [getUserInfo] Response Status: ${response.statusCode}');
      print('📬 [getUserInfo] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ [getUserInfo] User info fetched successfully.");
        return jsonDecode(response.body);
      } else {
        print(
            '❌ [getUserInfo] Error: ${response.statusCode} - ${response.body}');
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      print('🌐 [getUserInfo] No Internet connection');
      throw Exception('No Internet connection');
    } catch (e) {
      print('⚠️ [getUserInfo] Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      print('🔍 [getUserInfo] Method execution completed.');
    }
  }

  // Get Token Method
  Future<String?> getToken() async {
    print('🔍 [getToken] Method called.');
    try {
      final token = await _secureStorage.read(key: 'token');
      print('🔐 [getToken] Retrieved token: $token');
      return token;
    } catch (e) {
      print('⚠️ [getToken] Unexpected error: $e');
      return null;
    } finally {
      print('🔍 [getToken] Method execution completed.');
    }
  }

  // Fetch other business users
  Future<List<dynamic>> getOtherBusinessUsers() async {
    print('🔍 [getOtherBusinessUsers] Method called.');
    try {
      final token = await getToken();
      if (token == null) {
        print('❌ [getOtherBusinessUsers] No token found.');
        throw Exception('No token found.');
      }

      print(
          '🔗 [getOtherBusinessUsers] Connecting to $_getOtherBusinessUsersUrl with token.');
      final response = await http.get(
        Uri.parse(_getOtherBusinessUsersUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          '📬 [getOtherBusinessUsers] Response Status: ${response.statusCode}');
      print('📬 [getOtherBusinessUsers] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ [getOtherBusinessUsers] Business API Response received.");
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print('❌ [getOtherBusinessUsers] Error: ${response
            .statusCode} - ${response.body}');
        throw Exception("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("⚠️ [getOtherBusinessUsers] Error: $e");
      rethrow;
    } finally {
      print('🔍 [getOtherBusinessUsers] Method execution completed.');
    }
  }

  // Fetch business users with the same location
  Future<List<dynamic>> getBusinessUsersWithSameLocation() async {
    print('🔍 [getBusinessUsersWithSameLocation] Method called.');
    return _fetchDataFromApi(_getBusinessUsersWithSameLocationUrl,
        'getBusinessUsersWithSameLocation');
  }

  // Fetch favorite business users
  Future<List<dynamic>> getFavoriteBusinessUsers() async {
    print('🔍 [getFavoriteBusinessUsers] Method called.');
    return _fetchDataFromApi(
        _getFavoriteBusinessUsersUrl, 'getFavoriteBusinessUsers');
  }

  // Generic method for GET requests
  Future<List<dynamic>> _fetchDataFromApi(String url, String methodName) async {
    print('🔍 [_fetchDataFromApi] Method called from $methodName.');
    try {
      final String? token = await getToken();
      if (token == null) {
        print('❌ [_fetchDataFromApi] No token found. Please log in again.');
        throw Exception('No token found. Please log in again.');
      }

      print('🔗 [_fetchDataFromApi] Sending GET request to $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('📬 [_fetchDataFromApi] Response Status: ${response.statusCode}');
      print('📬 [_fetchDataFromApi] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print(
            "✅ [_fetchDataFromApi] Data fetched successfully from $methodName.");
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print('❌ [_fetchDataFromApi] Error: ${response.statusCode} - ${response
            .body}');
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      print('🌐 [_fetchDataFromApi] No Internet connection');
      throw Exception('No Internet connection');
    } catch (e) {
      print('⚠️ [_fetchDataFromApi] Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    } finally {
      print(
          '🔍 [_fetchDataFromApi] Method execution completed for $methodName.');
    }
  }

  // Get Saved Events Method
  Future<List<dynamic>> getSavedEvents() async {
    print('🔍 [getSavedEvents] Method called.');
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('❌ [getSavedEvents] No token found. Please log in again.');
        throw Exception('No token found. Please log in again.');
      }
      print('🔐 [getSavedEvents] Retrieved token: $token');

      print('🔗 [getSavedEvents] Sending GET request to $_getSavedEventsUrl');
      final response = await http.get(
        Uri.parse(_getSavedEventsUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
        },
      );

      print('📬 [getSavedEvents] Response Status: ${response.statusCode}');
      print('📬 [getSavedEvents] Response Body: ${response.body}');

      // Handle the response
      if (response.statusCode == 200) {
        print("✅ [getSavedEvents] Saved Events Response received.");
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            '❌ [getSavedEvents] Failed to fetch saved events. Status: ${response
                .statusCode} - ${response.body}');
        throw Exception('❌ Failed to fetch saved events. Status: ${response
            .statusCode} - ${response.body}');
      }
    } on SocketException {
      print('🌐 [getSavedEvents] No Internet connection');
      throw Exception('🌐 No Internet connection');
    } catch (e) {
      print('⚠️ [getSavedEvents] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [getSavedEvents] Method execution completed.');
    }
  }

  // Get Favorite Users Method
  Future<List<dynamic>> getFavoriteUsers() async {
    print('🔍 [getFavoriteUsers] Method called.');
    try {
      // Retrieve the token from secure storage
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        print('❌ [getFavoriteUsers] No token found. Please log in again.');
        throw Exception('No token found. Please log in again.');
      }
      print('🔐 [getFavoriteUsers] Retrieved token: $token');

      // Make the API call
      print(
          '🔗 [getFavoriteUsers] Sending GET request to $_getFavoriteUsersUrl');
      final response = await http.get(
        Uri.parse(_getFavoriteUsersUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
        },
      );

      print('📬 [getFavoriteUsers] Response Status: ${response.statusCode}');
      print('📬 [getFavoriteUsers] Response Body: ${response.body}');

      // Handle the response
      if (response.statusCode == 200) {
        print("✅ [getFavoriteUsers] Favorite Users Response received.");
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print(
            '❌ [getFavoriteUsers] Failed to fetch favorite users. Status: ${response
                .statusCode} - ${response.body}');
        throw Exception('❌ Failed to fetch favorite users. Status: ${response
            .statusCode} - ${response.body}');
      }
    } on SocketException {
      print('🌐 [getFavoriteUsers] No Internet connection');
      throw Exception('🌐 No Internet connection');
    } catch (e) {
      print('⚠️ [getFavoriteUsers] Unexpected error: $e');
      throw Exception('⚠️ Unexpected error: $e');
    } finally {
      print('🔍 [getFavoriteUsers] Method execution completed.');
    }
  }
}
