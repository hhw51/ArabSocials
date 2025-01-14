
import 'package:arab_socials/src/controllers/userlogin_controller.dart';
import 'package:arab_socials/src/view/homepage/homescreen.dart';
import 'dart:async';
import 'package:arab_socials/src/controllers/user_controller.dart';

import 'package:arab_socials/src/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arab_socials/src/widgets/otp_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;

  OtpVerifyScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _pinController = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 300; // 5 minutes in seconds
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() {
          _canResendOtp = true;
          _timer.cancel();
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _handleVerifyOtp() async {
    final enteredOtp = _pinController.text.trim();

    if (enteredOtp.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter the OTP code",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final signUpController = Get.find<SignUpController>();
      final response = await signUpController.verifyOtp(widget.email, enteredOtp);

      if (response['statusCode'] == 200 || response['statusCode'] == 201) {
        // If successful, navigate to the BottomNav
        Get.snackbar(
          "Success",
          "OTP Verified!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => BottomNav());
      } else {
        // Handle non-successful status codes
        final errorMessage = response['body']['error'] ?? 'OTP Verification Failed';
        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      // Handle unexpected errors
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  void _handleResendOtp() async {
    setState(() {
      _remainingSeconds = 300; // Reset timer to 5 minutes
      _canResendOtp = false;
    });
    _startTimer();

    try {
      final signUpController = Get.find<SignUpController>();
      await signUpController.sendOtp(widget.email);

      // Show success message
      Get.snackbar(
        "OTP Resent",
        "We have resent the OTP to your email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
      // Show error message if sending OTP fails
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 35, 94, 77),
            size: 28,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "VERIFICATION",
              style: GoogleFonts.playfairDisplaySc(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 70.h,
              width: 230.w,
              child: Padding(
                padding: const EdgeInsets.only(right: 17),
                child: Text(
                  "We’ve sent you the verification code on ${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Column(
              children: [
                OtpWidget(
                  controller: _pinController,
                  onCompleted: (pin) => _handleVerifyOtp(),
                ),
                SizedBox(height: 30.h),
                if (_canResendOtp) ...[
                  ElevatedButton(
                    onPressed: _handleResendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      minimumSize: Size(double.infinity, 56.h),
                    ),
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                if (!_canResendOtp) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Re-send code in",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
