import 'package:flutter/material.dart';

void showCustomPopupMenu(BuildContext context) {
 
  final screenSize = MediaQuery.of(context).size;

  
  final centerOffset = Offset(screenSize.width / 2, screenSize.height / 2);

  // Show the menu
  showMenu(
    color: const Color.fromARGB(255, 255, 255, 255),
    context: context,
    position: RelativeRect.fromLTRB(
      centerOffset.dx - 27, 
      centerOffset.dy - 108,  
      centerOffset.dx + 100,
      centerOffset.dy + 50,
    ),
    items: [
      const PopupMenuItem(
        value: 'register',
        child: Row(
          children: [
            Icon(Icons.add, color: Color.fromARGB(255, 35, 94, 77)),
            SizedBox(width: 8.0),
            Text('Register'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'invite_friends',
        child: Row(
          children: [
            Icon(Icons.person_add, color: Color.fromARGB(255, 35, 94, 77)),
            SizedBox(width: 8.0),
            Text('Invite Friends'),
          ],
        ),
      ),
      const PopupMenuItem(
        value: 'view_attendees',
        child: Row(
          children: [
            Icon(Icons.list, color: Color.fromARGB(255, 35, 94, 77)),
            SizedBox(width: 8.0),
            Text('View Attendees'),
          ],
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      if (value == 'register') {
        print('Register selected');
      } else if (value == 'invite_friends') {
        print('Invite Friends selected');
      } else if (value == 'view_attendees') {
        print('View Attendees selected');
      }
    }
  });
}
