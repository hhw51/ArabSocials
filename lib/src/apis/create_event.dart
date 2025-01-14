import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // For extracting filename

class CreateEventService {
  static const String _baseUrl = 'http://35.222.126.155:8000';

  static const String _createEventUrl = '$_baseUrl/events/create-event/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, dynamic>> createEvent({
    required String title,
    required String eventType,
    required String location,
    required String description,
    required String eventDate,
    required String ticketLink,
    required String promoCode,
    required String user,
    required String startTime,
    required String endTime,
    required File flyer, // Flyer file
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_createEventUrl');

      final request = http.MultipartRequest('POST', Uri.parse(_createEventUrl))
        ..headers['Authorization'] = 'Bearer $token' // Add authorization header
        ..fields['title'] = title
        ..fields['event_type'] = eventType
        ..fields['location'] = location
        ..fields['description'] = description
        ..fields['event_date'] = eventDate
        ..fields['ticket_link'] = ticketLink
        ..fields['promo_code'] = promoCode
        ..fields['user'] = user
        ..fields['start_time'] = startTime
        ..fields['end_time'] = endTime;

      // Attach flyer file
      request.files.add(await http.MultipartFile.fromPath(
        'flyer',
        flyer.path,
        filename: basename(flyer.path), // Extract filename from path
      ));

      final response = await request.send(); // Send the request

      print('Response Status: ${response.statusCode}');
      final responseBody = await response.stream.bytesToString();
      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        return data as Map<String, dynamic>;
      } else {
        throw Exception('❌ Error: ${response.statusCode} - $responseBody');
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
