// registerEventController.dart
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterEventController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Observable list to store event data
  var events = <Map<String, dynamic>>[].obs;

  // Observable map to store registered users for each event
  var registeredUsers = <int, List<Map<String, dynamic>>>{}.obs;

  // Observable map to store creator details for each event
  var eventCreators = <int, Map<String, dynamic>>{}.obs;

  // A set to store event IDs the user has registered for
  final RxSet<int> registeredEventIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEventIds();
  }

  /// Loads registered event IDs from secure storage.
  Future<void> _loadRegisteredEventIds() async {
    try {
      final registeredIdsString = await _secureStorage.read(key: 'registeredEventIds');
      if (registeredIdsString != null && registeredIdsString.isNotEmpty) {
        registeredEventIds.value = registeredIdsString
            .split(',')
            .map((id) => int.parse(id))
            .toSet();
        print('Registered Event IDs loaded: ${registeredEventIds.value}');
      } else {
        registeredEventIds.value = {};
        print('No registered Event IDs found.');
      }
    } catch (e) {
      print('Error loading registered event IDs: $e');
    }
  }

  /// Saves the current set of registered event IDs to secure storage.
  Future<void> _saveRegisteredEventIds() async {
    try {
      final registeredIdsString = registeredEventIds.join(',');
      await _secureStorage.write(key: 'registeredEventIds', value: registeredIdsString);
      print('Registered Event IDs saved: ${registeredEventIds.value}');
    } catch (e) {
      print('Error saving registered event IDs: $e');
    }
  }

  /// Function to set events from the backend response
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

  /// Get specific event by ID
  Map<String, dynamic>? getEventById(int id) {
    return events.firstWhereOrNull((event) => event['id'] == id);
  }

  /// Get registered users for a specific event
  List<Map<String, dynamic>>? getRegisteredUsersByEventId(int eventId) {
    return registeredUsers[eventId];
  }

  /// Get creator details for a specific event
  Map<String, dynamic>? getEventCreatorByEventId(int eventId) {
    return eventCreators[eventId];
  }

  /// Updates the registration status and persists it.
  Future<void> updateRegistrationStatus(int eventId, bool isRegistered) async {
    if (isRegistered) {
      registeredEventIds.add(eventId);
    } else {
      registeredEventIds.remove(eventId);
    }
    await _saveRegisteredEventIds();
  }
}
