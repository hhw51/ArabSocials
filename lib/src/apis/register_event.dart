// register_event.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterEvents {
  static const String _baseUrl = 'http://35.222.126.155:8000';
  static const String _registerEventsUrl = '$_baseUrl/events/register-event/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Registers or unregisters for an event by sending a POST request to the API.
  ///
  /// - [eventId]: The ID of the event.
  /// - [status]: "registered" to register and "cancelled" to unregister.
  ///
  /// Returns the response data as a [Map<String, dynamic>] if successful.
  /// Throws an [Exception] if the request fails.
  Future<Map<String, dynamic>> registerForEvent(int eventId, String status) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_registerEventsUrl');

      final response = await http
          .post(
        Uri.parse(_registerEventsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'event_id': eventId,
          'status': status,
        }),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // Check for 'id' and 'status' OR 'message' to confirm successful operation
        if ((data.containsKey('id') && data.containsKey('status')) ||
            data.containsKey('message')) {
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
}