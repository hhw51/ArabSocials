import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/view/events/register_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomPopupMenu(BuildContext context, Offset position) {
  final NavigationController navigationController = Get.put(NavigationController());

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
           navigationController.navigateToChild(RegisterEvent());
                    Navigator.of(context).pop(); 
               
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
            print('Invite Friends selected');
            // Navigator.of(context).pop(); // Dismiss the popup
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
            print('View Attendees selected');
            // Navigator.of(context).pop(); // Dismiss the popup
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
