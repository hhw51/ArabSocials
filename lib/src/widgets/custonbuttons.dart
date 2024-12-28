import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatefulWidget {
  final String text;
  final IconData icon;

  const CustomContainer({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: _isTapped ? Colors.green[800] : Colors.green[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: _isTapped ? Colors.white : Colors.black,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              widget.text,
              style: TextStyle(
                color: _isTapped ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Custombutton extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color color; // Background color of the button

  const Custombutton({
    Key? key,
    required this.text,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped; // Toggle the state
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6), // Horizontal spacing between buttons
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Padding inside the button
        decoration: BoxDecoration(
          color: _isTapped ? Colors.grey[300] : widget.color, // Change color when tapped
          borderRadius: BorderRadius.circular(20), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: _isTapped ? Colors.black : Colors.white, // Icon color changes on tap
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              widget.text,
              style: TextStyle(
                color: _isTapped ? Colors.black : Colors.white, // Text color changes on tap
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}