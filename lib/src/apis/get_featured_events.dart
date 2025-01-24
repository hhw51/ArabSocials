// get_featured_events.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetFeaturedEvents {
  static const String _baseUrl = 'http://35.222.126.155:8000';
  static const String _featuredEventsUrl = '$_baseUrl/events/featured-events/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Retrieves the authentication token from secure storage.
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  /// Fetches featured events from the API.
  Future<List<dynamic>> getFeaturedEvents() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No authentication token found. Please log in.');
      }

      final response = await http
          .get(
        Uri.parse(_featuredEventsUrl),
        headers: {
          'Authorization': 'Bearer $token', // Ensure "Bearer" is included
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data as List<dynamic>;
      } else {
        throw Exception('❌ Error: ${response.statusCode} - ${response.body}');
      }
    } on SocketException catch (e) {
      throw Exception('🌐 No Internet connection');
    } on TimeoutException catch (e) {
      throw Exception('⏳ Request timed out');
    } catch (e) {
      throw Exception('⚠️ Unexpected error: $e');
    }
  }
}