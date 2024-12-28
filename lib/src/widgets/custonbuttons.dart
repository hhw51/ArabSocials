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
  final IconData? icon; // Optional icon
  final String? image; // Optional image
  final Color color; // Background color

  const Custombutton({
    Key? key,
    required this.text,
    this.icon, // Allow either an icon
    this.image, // Or an image
    required this.color,
  }) : super(key: key);

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) 
            Icon(
              widget.icon,
              color: Colors.white,
              size: 20,
            )
          else if (widget.image != null) 
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.image!,
                height: 18,
                width: 18,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
