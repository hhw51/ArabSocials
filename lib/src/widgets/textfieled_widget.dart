import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool obscureText;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword ? obscureText : false, // Handle password visibility
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey)
                : null,
            suffixIcon: suffixIcon, // Dynamic suffixIcon
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          validator: validator,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}









class CustomDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final List<String> items;
  final void Function(String?)? onChanged;

  const CustomDropdown({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.items,
    this.prefixIcon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  Container(
  width: 350,  // Set the width of the dropdown menu here
  child: DropdownButtonFormField<String>(
    value: controller.text.isEmpty ? null : controller.text,
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelStyle: TextStyle(
        color: Colors.grey[700],
        fontSize: 14,
      ),
      hintText: null,
      filled: true,
      fillColor: const Color.fromARGB(255, 250, 244, 228),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: Colors.grey)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 228, 223, 223),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 13, 13, 13),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    ),
    isExpanded: true,
    icon: const Icon(
      Icons.keyboard_arrow_down_sharp,
      color: Color.fromARGB(255, 35, 94, 77),
    ),
    hint: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        hintText,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    ),
    items: items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Container(
          width: 200, 
          child: Text(
            item,
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis, 
          ),
       
        ),
      );
    }).toList(),
    onChanged: (String? value) {
      if (value != null) {
        controller.text = value;
      }
    },
    dropdownColor: const Color.fromARGB(255, 250, 244, 228),
  ),
),
        SizedBox(height: 10.h),
      ],
    );
  }
}
