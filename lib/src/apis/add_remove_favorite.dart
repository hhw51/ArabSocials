import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FavoritesService {
  static const String _baseUrl = 'http://35.222.126.155:8000';
  static const String _addFavoriteUrl = '$_baseUrl/users/favorites/';
  static const String _removeFavoriteUrl = '$_baseUrl/users/remove_favorite/';

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _favoriteBusinessKey = 'favoriteBusinessIds';

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Map<String, dynamic>> addFavorite({
    required int userId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_addFavoriteUrl');

      final response = await http.post(
        Uri.parse(_addFavoriteUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
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


  Future<Map<String, dynamic>> removeFavorite({
    required int userId,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('Authentication token not found.');
      }

      print('Connecting to $_removeFavoriteUrl');

      final response = await http.post(
        Uri.parse(_removeFavoriteUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
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

  Future<void> saveFavoriteBusinessIds(Set<int> favoriteIds) async {
    try {
      await _secureStorage.write(
        key: _favoriteBusinessKey,
        value: favoriteIds.join(','), // Store as comma-separated string
      );
    } catch (e) {
      print('Error saving favorite businesses: $e');
    }
  }

  Future<Set<int>> loadFavoriteBusinessIds() async {
    try {
      final favoriteIdsString = await _secureStorage.read(
          key: _favoriteBusinessKey);
      if (favoriteIdsString != null && favoriteIdsString.isNotEmpty) {
        return favoriteIdsString.split(',').map((id) => int.parse(id)).toSet();
      }
      return {};
    } catch (e) {
      print('Error loading favorite businesses: $e');
      return {};
    }
  }
}
