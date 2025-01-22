// lib\src\widgets\textfomr_feild.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller; // **Added:** Controller parameter

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    this.controller, // **Added:** Initialize controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // Ensure consistent padding
      child: SizedBox(
        height: 48.h,
        width: 345.w,
        child: TextFormField(
          controller: controller, // **Added:** Assign controller to TextFormField
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xffBEDAA5),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 225, 173, 116),
            ),
            contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.green,
              ),
            ),
          ),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
