import 'package:flutter/material.dart';

void showCustomPopupMenu(BuildContext context, Offset offset) {
  showMenu(
    color: const Color.fromARGB(255, 255, 255, 255),
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
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
    // Handle menu item selection
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
