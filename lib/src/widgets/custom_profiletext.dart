import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomData extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool showSwitch; 
  final bool switchValue; 
  final ValueChanged<bool>? onSwitchChanged; 

  const CustomData({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showSwitch = false,
    required this.switchValue,
    this.onSwitchChanged,
  }) : super(key: key);

  @override
  State<CustomData> createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title and Subtitle
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 95.w,
                child: Text(
                  "${widget.title}: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
    
        // Switch
        if (widget.showSwitch)
          Transform.scale(
            scale: 0.7, 
            child: Switch(
              value: widget.switchValue,
              onChanged: widget.onSwitchChanged,
            ),
          ),
      ],
    );
  }
}
