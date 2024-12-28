import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatefulWidget {
  final String text;
  final IconData? icon; 
  final String? image; 

  const CustomContainer({
    Key? key,
    required this.text,
    this.icon, 
    this.image, 
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
            if (widget.icon != null)
              Icon(
                widget.icon,
                color: _isTapped ? Colors.white : Colors.green,
                size: 18,
              )
            else if (widget.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r), 
                child: Image.asset(
                  widget.image!,
                  height: 16.h,
                  width: 16.w,
                    color: _isTapped ? Colors.white : Colors.green,
                  fit: BoxFit.cover,
                ),
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
  final IconData? icon; 
  final String? image; 
  final Color color; 

  const Custombutton({
    Key? key,
    required this.text,
    this.icon, 
    this.image, 
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
 




class CustomIntrestsContainer extends StatefulWidget {
  final String text;
  final Color color;

  const CustomIntrestsContainer({
    Key? key,
    required this.text,
    required this.color,
  }) : super(key: key);

  @override
  State<CustomIntrestsContainer> createState() =>
      _CustomIntrestsContainerState();
}

class _CustomIntrestsContainerState extends State<CustomIntrestsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
     margin: const EdgeInsets.symmetric(horizontal: 3),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: widget.color, 
        borderRadius: BorderRadius.circular(10.r), 
      ),
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}