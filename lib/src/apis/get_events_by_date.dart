import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/event_model.dart'; // Ensure the correct path to your UserEvent model

class GetEventsByDate {
  static const String _baseUrl = 'http://35.222.126.155:8000';
  static const String _getEventsByDateUrl = '$_baseUrl/events/date-range/';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Fetches events based on the provided date range
  ///
  /// [startDate] and [endDate] are the start and end dates in the format "YYYY-MM-DD"
  Future<List<UserEvent>> getEventsByDateRange(String startDate, String endDate) async {
    try {
      // Retrieve the authentication token
      final token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in first.');
      }

      print('Connecting to $_getEventsByDateUrl with token: $token');

      // Prepare headers
      Map<String, String> headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      // Prepare the JSON body
      Map<String, dynamic> body = {
        'start_date': startDate,
        'end_date': endDate,
      };

      // Make the POST request
      final response = await http
          .post(
        Uri.parse(_getEventsByDateUrl),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Handle the response
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<UserEvent> events = data.map((json) => UserEvent.fromJson(json)).toList();
        return events;
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
