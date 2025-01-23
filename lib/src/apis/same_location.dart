import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:arabsocials/src/models/other_user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SameLocation {
  // Update the base URL to match the new API endpoint
  static const String _baseUrl = 'http://35.222.126.155:8000';

  // New endpoint for fetching users by locations
  static const String _getUsersByLocationsUrl = '$_baseUrl/users/get-users-by-locations/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Fetches users based on the provided list of locations
  ///
  /// [locations] is a list of location names (e.g., ["New York", "Los Angeles", "Chicago"])
  Future<List<User>> getUsersByLocations(List<String> locations) async {
    try {
      // Retrieve the authentication token
      final token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in first.');
      }

      // Retrieve the CSRF token if your backend requires it

      print('Connecting to $_getUsersByLocationsUrl with token: $token');

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };


      // Prepare the JSON body
      Map<String, dynamic> body = {
        'locations': locations,
      };

      // Make the POST request
      final response = await http
          .post(
        Uri.parse(_getUsersByLocationsUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Handle the response
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<User> users = data.map((json) => User.fromJson(json)).toList();
        return users;
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
