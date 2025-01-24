import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventInviteService {
  static const String baseUrl = 'http://35.222.126.155:8000';
  static const String sendEventInvitesUrl = '$baseUrl/notifications/send-event-invites/';

  static final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<Map<String, dynamic>> sendEventInvites({
    required List<int> userIds,
    required int eventId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $sendEventInvitesUrl');

      // Prepare request body
      final requestBody = {
        'user_ids': userIds,
        'event_id': eventId,
      };

      // Send HTTP request
      final response = await http.post(
        Uri.parse(sendEventInvitesUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
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
