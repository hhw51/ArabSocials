// get_saved_events.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetSavedEvents {
  static const String _baseUrl = 'http://35.222.126.155:8000'; // Update if needed
  static const String _savedEventsUrl = '$_baseUrl/events/get_saved_events/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Fetches saved events from the API.
  ///
  /// Returns a list of saved events as [List<dynamic>] if successful.
  /// Throws an [Exception] if the request fails.
  Future<List<dynamic>> getSavedEvents() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }

      print('Connecting to $_savedEventsUrl with token: $token');

      final response = await http
          .get(
        Uri.parse(_savedEventsUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // 'Cookie': 'csrftoken=your_csrf_token_here', // Uncomment if CSRF is required
        },
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the response is a JSON array of saved events
        return data as List<dynamic>;
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
