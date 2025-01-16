import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/view/events/register_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/registerEventController.dart'; // Import the controller for accessing registered users

void showCustomPopupMenu(BuildContext context, Offset position, Map<String, dynamic> event) {
  final NavigationController navigationController = Get.put(NavigationController());
  final eventController = Get.find<RegisterEventController>(); // Access the controller

  // Show the menu at the tap position
  showMenu(
    color: const Color.fromARGB(255, 255, 255, 255),
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx - 175,
      position.dy - 90,
      position.dx + 1,
      position.dy + 1,
    ),
    items: [
      PopupMenuItem(
        value: 'register',
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the menu
            navigationController.navigateToChild(RegisterEvent(eventId: event['id'])); // Pass event
          },
          child: const Row(
            children: [
              Icon(Icons.add, color: Color.fromARGB(255, 35, 94, 77)),
              SizedBox(width: 8.0),
              Text('Register Event'),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: 'invite_friends',
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the menu
            print('Invite Friends selected');
          },
          child: const Row(
            children: [
              Icon(Icons.person_add, color: Color.fromARGB(255, 35, 94, 77)),
              SizedBox(width: 8.0),
              Text('Invite Friends'),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: 'view_attendees',
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the menu
            _showAttendeesPopup(context, event['id'], eventController); // Show the attendees popup
          },
          child: const Row(
            children: [
              Icon(Icons.list, color: Color.fromARGB(255, 35, 94, 77)),
              SizedBox(width: 8.0),
              Text('View Attendees'),
            ],
          ),
        ),
      ),
    ],
  );
}

void _showAttendeesPopup(
    BuildContext context, int eventId, RegisterEventController eventController) {
  final attendees = eventController.getRegisteredUsersByEventId(eventId); // Fetch registered users

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Attendees',
          style: TextStyle(color: Colors.black),
        ),
        content: attendees != null && attendees.isNotEmpty
            ? SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: attendees.length,
            itemBuilder: (context, index) {
              final attendee = attendees[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: attendee['image'] != null
                      ? NetworkImage('http://35.222.126.155:8000${attendee['image']}')
                      : const AssetImage('assets/logo/default_avatar.png') as ImageProvider,
                ),
                title: Text(
                  attendee['name'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  attendee['email'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            },
          ),
        )
            : const Text(
          'No attendees registered for this event.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}
