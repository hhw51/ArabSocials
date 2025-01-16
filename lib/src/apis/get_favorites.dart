import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:arabsocials/src/models/other_user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetFavorites {

  static const String _baseUrl = 'http://35.222.126.155:8000';

  static const String _favoritesUrl = '$_baseUrl/users/get-favorite-users/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();


  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<List<User>> getFavoriteUsers() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('No token found. Please log in first.');
      }

      print('Connecting to $_favoritesUrl with token: $token');

      final response = await http
          .get(
        Uri.parse(_favoritesUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 60));

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

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