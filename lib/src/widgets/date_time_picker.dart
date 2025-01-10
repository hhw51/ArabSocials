
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerFieldWidget extends StatelessWidget {
  final TextEditingController controller;
   final TextEditingController dateofbirthController = TextEditingController();

  final String hintText;

   DatePickerFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
       fillColor: const Color.fromARGB(255, 250, 244, 228),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
         focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          
        );
        if (pickedDate != null) {
          controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
        }
      },
      validator: (value) =>
      value!.isEmpty ? 'Please enter your date of birth' : null,
    );
    
    
  }
  
}



class TimePickerFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const TimePickerFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 250, 244, 228),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          final hours = pickedTime.hourOfPeriod == 0 ? 12 : pickedTime.hourOfPeriod;
          final minutes = pickedTime.minute.toString().padLeft(2, '0');
          final period = pickedTime.period == DayPeriod.am ? "AM" : "PM";

          controller.text = "$hours:$minutes $period";
        }
      },
      validator: (value) =>
          value!.isEmpty ? 'Please select a time' : null,
    );
  }
}