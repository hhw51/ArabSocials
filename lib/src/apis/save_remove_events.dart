// event_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventService {
  static const String _baseUrl = 'http://35.222.126.155:8000'; // Update if needed
  static const String _saveEventUrl = '$_baseUrl/events/events-save/';
  static const String _removeEventUrl = '$_baseUrl/events/events-save/'; // Assuming same endpoint with different payload

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Saves an event by sending a POST request to the API.
  ///
  /// Returns the response data as a [Map<String, dynamic>] if successful.
  /// Throws an [Exception] if the request fails.
  Future<Map<String, dynamic>> saveEvent({
    required int eventId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_saveEventUrl');

      final response = await http.post(
        Uri.parse(_saveEventUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // 'Cookie': 'csrftoken=your_csrf_token_here', // Uncomment and set if CSRF is required
        },
        body: jsonEncode({
          'event_id': eventId,
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data as Map<String, dynamic>;
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

  /// Removes an event by sending a POST request with a removal flag to the API.
  ///
  /// Returns the response data as a [Map<String, dynamic>] if successful.
  /// Throws an [Exception] if the request fails.
  Future<Map<String, dynamic>> removeEvent({
    required int eventId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_removeEventUrl');

      final response = await http.post(
        Uri.parse(_removeEventUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          // 'Cookie': 'csrftoken=your_csrf_token_here', // Uncomment and set if CSRF is required
        },
        body: jsonEncode({
          'event_id': eventId,
          'remove': true, // Indicate that this is a removal request
        }),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data as Map<String, dynamic>;
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
