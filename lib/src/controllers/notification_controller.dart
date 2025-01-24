import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../apis/get_notifications.dart';

class NotificationController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final RxList<UserNotification> notifications = <UserNotification>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final fetchedNotifications =
          await GetNotifications().getUserNotifications();
      notifications.assignAll(fetchedNotifications);
      await _saveNotificationsToStorage(fetchedNotifications);
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveNotificationsToStorage(
      List<UserNotification> notifications) async {
    final List<Map<String, dynamic>> notificationList =
        notifications.map((notification) => notification.toJson()).toList();
    await _secureStorage.write(
        key: 'notifications', value: notificationList.toString());
  }

  Future<void> loadNotificationsFromStorage() async {
    final String? storedNotifications =
        await _secureStorage.read(key: 'notifications');
    if (storedNotifications != null) {
      final List<dynamic> notificationList = jsonDecode(storedNotifications);
      final List<UserNotification> loadedNotifications = notificationList
          .map((json) => UserNotification.fromJson(json))
          .toList();
      notifications.assignAll(loadedNotifications);
    }
  }
}
