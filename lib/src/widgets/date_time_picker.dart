
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DatePickerFieldWidget extends StatelessWidget {
  final TextEditingController controller;
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
        hintStyle: TextStyle(color: Colors.grey[900]),
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
          controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
      validator: (value) =>
          value!.isEmpty ? 'Please enter your date of birth' : null,
    );
  }
}

class TimePickerFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const TimePickerFieldWidget({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  _TimePickerFieldWidgetState createState() => _TimePickerFieldWidgetState();
}

class _TimePickerFieldWidgetState extends State<TimePickerFieldWidget> {
  // Internal state for time and format
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _is24HourFormat = true;
  String _selectedPart = ''; // 'hour' or 'minute'

  @override
  void initState() {
    super.initState();
    // Initialize controller with current time in selected format after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.controller.text = _formatTime(_selectedTime);
      }
    });
  }

  // Helper method to format time based on the selected format
  String _formatTime(TimeOfDay time) {
    if (_is24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')} : ${time.minute.toString().padLeft(2, '0')}';
    } else {
      final period = time.period == DayPeriod.am ? 'AM' : 'PM';
      final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
      return '$hour : ${time.minute.toString().padLeft(2, '0')} $period';
    }
  }

  // Method to increment hour
  void _incrementHour() {
    setState(() {
      int newHour = _selectedTime.hour + 1;
      if (newHour >= 24) newHour = 0;
      _selectedTime = _selectedTime.replacing(hour: newHour);
      widget.controller.text = _formatTime(_selectedTime);
    });
  }

  // Method to decrement hour
  void _decrementHour() {
    setState(() {
      int newHour = _selectedTime.hour - 1;
      if (newHour < 0) newHour = 23;
      _selectedTime = _selectedTime.replacing(hour: newHour);
      widget.controller.text = _formatTime(_selectedTime);
    });
  }

  // Method to increment minute
  void _incrementMinute() {
    setState(() {
      int newMinute = _selectedTime.minute + 1;
      int carryOver = 0;
      if (newMinute >= 60) {
        newMinute = 0;
        carryOver = 1;
      }
      int newHour = (_selectedTime.hour + carryOver) % 24;
      _selectedTime = _selectedTime.replacing(hour: newHour, minute: newMinute);
      widget.controller.text = _formatTime(_selectedTime);
    });
  }

  // Method to decrement minute
  void _decrementMinute() {
    setState(() {
      int newMinute = _selectedTime.minute - 1;
      int borrow = 0;
      if (newMinute < 0) {
        newMinute = 59;
        borrow = 1;
      }
      int newHour = (_selectedTime.hour - borrow) % 24;
      if (newHour < 0) newHour += 24;
      _selectedTime = _selectedTime.replacing(hour: newHour, minute: newMinute);
      widget.controller.text = _formatTime(_selectedTime);
    });
  }

  // Method to toggle between 12-hour and 24-hour formats
  void _toggleFormat(bool is24Hour) {
    setState(() {
      _is24HourFormat = is24Hour;
      widget.controller.text = _formatTime(_selectedTime);
      // Deselect any selected part when toggling format
      _selectedPart = '';
    });
  }

  // Method to select or deselect a part
  void _selectPart(String part) {
    setState(() {
      if (_selectedPart == part) {
        _selectedPart = ''; // Deselect if already selected
      } else {
        _selectedPart = part; // Select the new part
      }
    });
  }

  // Method to toggle AM/PM in 12-hour format
  void _toggleAmPm() {
    setState(() {
      int newHour = _selectedTime.hour;
      if (_selectedTime.period == DayPeriod.am) {
        // Switch to PM
        if (_selectedTime.hour < 12) {
          newHour += 12;
        }
      } else {
        // Switch to AM
        if (_selectedTime.hour >= 12) {
          newHour -= 12;
        }
      }
      _selectedTime = _selectedTime.replacing(hour: newHour);
      widget.controller.text = _formatTime(_selectedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Decoration to mimic TextField
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12.r),
        color: const Color.fromARGB(255, 250, 244, 228),
      ),
      child: Row(
        children: [
          // Hour Section
          GestureDetector(
            onTap: () => _selectPart('hour'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Increment Button (visible only when hour is selected)
                if (_selectedPart == 'hour')
                  GestureDetector(
                    onTap: _incrementHour,
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
                // Hour Text
                Text(
                  _is24HourFormat
                      ? '${_selectedTime.hour.toString().padLeft(2, '0')}'
                      : '${(_selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight:
                    _selectedPart == 'hour' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                // Decrement Button (visible only when hour is selected)
                if (_selectedPart == 'hour')
                  GestureDetector(
                    onTap: _decrementHour,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ),
          // Increased Separator Spacing
          SizedBox(width: 16.w),
          // Separator
          Text(
            ':',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 16.w),
          // Minute Section
          GestureDetector(
            onTap: () => _selectPart('minute'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Increment Button (visible only when minute is selected)
                if (_selectedPart == 'minute')
                  GestureDetector(
                    onTap: _incrementMinute,
                    child: Icon(
                      Icons.arrow_drop_up,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
                // Minute Text
                Text(
                  '${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight:
                    _selectedPart == 'minute' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                // Decrement Button (visible only when minute is selected)
                if (_selectedPart == 'minute')
                  GestureDetector(
                    onTap: _decrementMinute,
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ),
          // AM/PM Toggle (Visible Only in 12-Hour Format and Positioned Next to Minutes)
          if (!_is24HourFormat)
            GestureDetector(
              onTap: _toggleAmPm,
              child: Container(
                margin: EdgeInsets.only(left: 16.w), // Adjust spacing as needed
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Color(0xff235e4d),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  _selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Spacer(),
          // 12/24-Hour Format Toggle
          Row(
            children: [
              Text(
                _is24HourFormat ? '24' : '12',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
              ),
              Switch(
                value: _is24HourFormat,
                onChanged: _toggleFormat,
                activeColor: const Color.fromARGB(255, 35, 94, 77),
                inactiveThumbColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

