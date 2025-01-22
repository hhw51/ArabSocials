// lib/controllers/users_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../apis/get_other_users.dart';
import '../models/other_user_model.dart';

class UsersController extends GetxController {
  final GetOtherUsers _getOtherUsersService = GetOtherUsers();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Observable list to store User objects
  var users = <User>[].obs;

  // Observable for loading state
  var isLoading = false.obs;

  // Observable for error messages
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetches users from the backend and updates the users list
  Future<void> fetchUsers() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<User> fetchedUsers = await _getOtherUsersService.getOtherUsers();
      users.assignAll(fetchedUsers);
      print('Users fetched successfully: ${users.length}');
      // Optionally, you can persist the users locally
      await _persistUsers(fetchedUsers);
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Retrieves a user by their ID
  User? getUserById(int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      print('User with ID $id not found.');
      return null;
    }
  }

  /// Optionally, persist users data to secure storage or local storage
  Future<void> _persistUsers(List<User> users) async {
    try {
      List<String> usersJson =
      users.map((user) => jsonEncode(user.toJson())).toList();
      await _secureStorage.write(key: 'users', value: jsonEncode(usersJson));
      print('Users persisted to secure storage.');
    } catch (e) {
      print('Error persisting users: $e');
    }
  }

  /// Optionally, load persisted users from storage
  Future<void> loadPersistedUsers() async {
    try {
      String? usersString = await _secureStorage.read(key: 'users');
      if (usersString != null && usersString.isNotEmpty) {
        List<dynamic> usersJson = jsonDecode(usersString);
        List<User> persistedUsers =
        usersJson.map((json) => User.fromJson(json)).toList();
        users.assignAll(persistedUsers);
        print('Users loaded from secure storage.');
      } else {
        print('No persisted users found.');
      }
    } catch (e) {
      print('Error loading persisted users: $e');
    }
  }
}
