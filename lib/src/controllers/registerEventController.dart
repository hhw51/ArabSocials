import 'package:get/get.dart';

class RegisterEventController extends GetxController {
  var events = <Map<String, dynamic>>[].obs; // Observable list to store event data
  var registeredUsers = <int, List<Map<String, dynamic>>>{}.obs; // Observable map to store registered users for each event

  // Function to set events from the backend response
  void setEvents(List<dynamic> eventData) {
    events.value = eventData.map((e) {
      final event = Map<String, dynamic>.from(e);

      // Save registered users for the event
      if (event.containsKey('registered_users') && event['registered_users'] is List) {
        registeredUsers[event['id']] = List<Map<String, dynamic>>.from(event['registered_users']);
      }

      return event;
    }).toList();
  }

  // Get specific event by ID
  Map<String, dynamic>? getEventById(int id) {
    return events.firstWhereOrNull((event) => event['id'] == id);
  }

  // Get registered users for a specific event
  List<Map<String, dynamic>>? getRegisteredUsersByEventId(int eventId) {
    return registeredUsers[eventId];
  }
}
