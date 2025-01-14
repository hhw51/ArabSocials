import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onCompleted;

  const OtpWidget({
    Key? key,
    required this.controller,
    required this.onCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: Pinput(
        length: 6,
        controller: controller,
        onCompleted: (pin) => onCompleted(pin),
        defaultPinTheme: PinTheme(
          width: 60.w,
          height: 56.h,
          textStyle: GoogleFonts.playfairDisplaySc(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 228, 223, 223)),
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 60.w,
          height: 56.h,
          textStyle: GoogleFonts.playfairDisplaySc(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 228, 223, 223)),
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
