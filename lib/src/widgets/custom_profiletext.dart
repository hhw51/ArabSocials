import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomData extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showSwitch;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged; 

  const CustomData({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showSwitch = false,
    this.switchValue, 
    this.onSwitchChanged, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 95.w,
                child: Text(
                  "$title: ",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  subtitle,
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
        if (showSwitch)
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: switchValue ?? false, 
              onChanged: onSwitchChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
      ],
    );
  }
}
