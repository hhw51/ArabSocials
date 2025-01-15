import 'package:get/get.dart';

class RegisterEventController extends GetxController {
  var events = <Map<String, dynamic>>[].obs; // Observable list to store event data
  var registeredUsers = <int, List<Map<String, dynamic>>>{}.obs; // Observable map to store registered users for each event
  var eventCreators = <int, Map<String, dynamic>>{}.obs; // Observable map to store creator details for each event

  // Function to set events from the backend response
  void setEvents(List<dynamic> eventData) {
    events.value = eventData.map((e) {
      final event = Map<String, dynamic>.from(e);

      // Save registered users for the event
      if (event.containsKey('registered_users') && event['registered_users'] is List) {
        registeredUsers[event['id']] = List<Map<String, dynamic>>.from(event['registered_users']);
      }

      // Save event creator details
      if (event.containsKey('user') && event['user'] is Map<String, dynamic>) {
        eventCreators[event['id']] = Map<String, dynamic>.from(event['user']);
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

  // Get creator details for a specific event
  Map<String, dynamic>? getEventCreatorByEventId(int eventId) {
    return eventCreators[eventId];
  }
}
