import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../controllers/registerEventController.dart';

class ApprovedEvents {

  static const String _baseUrl = 'http://35.222.126.155:8000';

  static const String _approvedEventsUrl = '$_baseUrl/events/approved-events/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<List<dynamic>> getApprovedEvents() async {
    final controller = Get.find<RegisterEventController>();
    try {
      print('Connecting to $_approvedEventsUrl');
      final token = await getToken();

      final response = await http
          .get(
        Uri.parse(_approvedEventsUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        controller.setEvents(data);
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