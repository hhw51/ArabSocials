import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:arabsocials/src/controllers/userlogin_controller.dart';
import 'package:arabsocials/src/widgets/bottom_nav.dart';
import 'package:arabsocials/src/widgets/otp_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String name;
  final String password;
  final String? account_type;
  final String? phone;

  const OtpVerifyScreen({
    Key? key,
    required this.email,
    required this.name,
    this.account_type,
    required this.password,
    this.phone,
  }) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _pinController = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 300; // 5 minutes
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
      final otpResponse = await signUpController.verifyOtp(widget.email, enteredOtp);

      if (otpResponse['status'] == 'success') {
        if (widget.account_type != null && widget.phone != null) {
          final signupResponse = await signUpController.signUp(
            widget.name,
            widget.email,
            widget.password,
            widget.account_type!.toLowerCase(),
            widget.phone!,
          );

          // Debug print
          print('Full Signup Response: $signupResponse');

          // Check if signup was successful
          if (
          signupResponse['user'] != null &&
              signupResponse['token'] != null
          ) {
            Get.snackbar(
              "Success",
              "Account created successfully!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Add a small delay before navigation
            await Future.delayed(const Duration(milliseconds: 500));

            // Navigate to BottomNav
            Get.offAll(() => const BottomNav());
          } else {
            print('Signup failed. Response: $signupResponse');
            Get.snackbar(
              "Error",
              signupResponse['error'] ?? "Signup failed. Please try again.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Missing required signup information.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          otpResponse['error'] ?? "OTP Verification Failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      print('🚫 [handleVerifyOtp] Error: $error');
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
      _remainingSeconds = 300;
      _canResendOtp = false;
    });
    _startTimer();

    try {
      final signUpController = Get.find<SignUpController>();
      await signUpController.sendOtp(widget.email);

      Get.snackbar(
        "Success",
        "OTP has been resent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (error) {
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
          onPressed: () => Get.back(),
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
                  "We've sent you the verification code on ${widget.email}",
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
                if (_canResendOtp)
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
                if (!_canResendOtp)
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
            ),
          ],
        ),
      ),
    );
  }
}