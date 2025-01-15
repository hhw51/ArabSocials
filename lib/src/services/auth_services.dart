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
  static const String _addFavoriteBusinessUrl = '$_baseUrl/users/add-favorite-business/';
  static const String _removeFavoriteBusinessUrl = '$_baseUrl/users/remove-favorite-business/';
   static const String _getSavedEventsUrl = '$_baseUrl/events/get_saved_events/';
   static const String _getFavoriteUsersUrl = '$_baseUrl/users/get-favorite-users/';

  

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

        return {
          'statusCode': response.statusCode,
          'body': responseData,
        };
      } else {
        final errorBody = jsonDecode(response.body);
        return {
          'statusCode': response.statusCode,
          'body': errorBody,
        };
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
    required List<String> interests,

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
      request.fields['interests'] = jsonEncode(interests);

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

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  // Fetch other business users
  Future<List<dynamic>> getOtherBusinessUsers() async {
  try {
    final token = await getToken();
    if (token == null) {
      throw Exception('No token found.');
    }

    final response = await http.get(
      Uri.parse(_getOtherBusinessUsersUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print("Business API Response: ${response.body}");
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error in getOtherBusinessUsers: $e");
    rethrow;
  }
}

  // Fetch business users with the same location
  Future<List<dynamic>> getBusinessUsersWithSameLocation() async {
    return _fetchDataFromApi(_getBusinessUsersWithSameLocationUrl);
  }

  // Fetch favorite business users
  Future<List<dynamic>> getFavoriteBusinessUsers() async {
    return _fetchDataFromApi(_getFavoriteBusinessUsersUrl);
  }

  // Add a business to favorites
  Future<void> addFavoriteBusiness(int businessId) async {
    await _postDataToApi(_addFavoriteBusinessUrl, {'id': businessId});
  }

  // Remove a business from favorites
  Future<void> removeFavoriteBusiness(int businessId) async {
    await _postDataToApi(_removeFavoriteBusinessUrl, {'id': businessId});
  }

  // Generic method for GET requests
  Future<List<dynamic>> _fetchDataFromApi(String url) async {
    try {
      final String? token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Generic method for POST requests
  Future<void> _postDataToApi(String url, Map<String, dynamic> body) async {
    try {
      final String? token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

Future<List<dynamic>> getSavedEvents() async {

  try {
    final String? token = await _secureStorage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }
    final response = await http.get(
      Uri.parse(_getSavedEventsUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
      },
    );
    // Handle the response
    if (response.statusCode == 200) {
      print("✅ Saved Events Response: ${response.body}");
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('❌ Failed to fetch saved events. Status: ${response.statusCode} - ${response.body}');
    }
  } on SocketException {
    throw Exception('🌐 No Internet connection');
  } catch (e) {
    throw Exception('⚠️ Unexpected error: $e');
  }
}

Future<List<dynamic>> getFavoriteUsers() async {
  try {
    // Retrieve the token from secure storage
    final String? token = await _secureStorage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }

    // Make the API call
    final response = await http.get(
      Uri.parse(_getFavoriteUsersUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=bRjlF9yxqGNkiqJlXEn4uhicNnDv4BYW',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      print("✅ Favorite Users Response: ${response.body}");
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('❌ Failed to fetch favorite users. Status: ${response.statusCode} - ${response.body}');
    }
  } on SocketException {
    throw Exception('🌐 No Internet connection');
  } catch (e) {
    throw Exception('⚠️ Unexpected error: $e');
  }
}

}