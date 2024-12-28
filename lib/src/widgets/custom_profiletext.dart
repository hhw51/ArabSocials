import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomData extends StatefulWidget {
  final String title; 
  final String subtitle; 

  const CustomData({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  State<CustomData> createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h), 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.start,
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
          // Subtitle
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
    );
  }
}
