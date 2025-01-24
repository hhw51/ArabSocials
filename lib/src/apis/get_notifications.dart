import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart'; // Ensure the correct path to your UserNotification model

class GetNotifications {
  static const String _baseUrl = 'http://35.222.126.155:8000';
  static const String _getNotificationsUrl = '$_baseUrl/notifications/get-user-notifications/';
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<List<UserNotification>> getUserNotifications() async { // Changed return type to List<UserNotification>
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in first.');
      }

      print('Connecting to $_getNotificationsUrl with token: $token');

      final response = await http
          .get(
        Uri.parse(_getNotificationsUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming the response body is a JSON array of notifications
        final List<dynamic> data = jsonDecode(response.body);
        // Convert each JSON object into a UserNotification instance
        List<UserNotification> notifications = data.map((json) => UserNotification.fromJson(json)).toList();
        return notifications;
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
