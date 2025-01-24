import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arabsocials/src/controllers/userlogin_controller.dart';
import 'package:arabsocials/src/view/auth/sign_in/pages/sign_in_page.dart';
import 'package:arabsocials/src/widgets/otp_widget.dart';
import 'package:arabsocials/src/apis/reset_password.dart'; // Add this line

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController(); // Add this line
  final TextEditingController confirmPasswordController = TextEditingController(); // Add this line
  bool _isOtpSent = false;
  bool _isOtpVerified = false; // Add this line

  void _handleSendOtp() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final signUpController = Get.put(SignUpController());
      await signUpController.sendOtp(email);

      Get.snackbar(
        "Success",
        "OTP has been sent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      setState(() {
        _isOtpSent = true;
      });
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

  void _handleVerifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
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
      final signUpController = Get.put(SignUpController());
      final otpResponse = await signUpController.verifyOtp(emailController.text.trim(), otp);

      if (otpResponse['status'] == 'success') {
        Get.snackbar(
          "Success",
          "OTP verified successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        setState(() {
          _isOtpVerified = true; // Update this line
        });
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
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _handleResetPassword() async { // Add this method
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final authService = AuthService();
      await authService.resetPassword(
        email: emailController.text.trim(),
        newPassword: password,
      );

      Get.snackbar(
        "Success",
        "Password reset successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => Signinscreen());
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
          onPressed: () => Get.offAll(() => Signinscreen()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              _isOtpSent ? (_isOtpVerified ? "RESET PASSWORD" : "VERIFICATION") : "FORGET PASSWORD",
              style: GoogleFonts.playfairDisplaySc(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            if (!_isOtpSent) ...[
              SizedBox(
                height: 70.h,
                width: 230.w,
                child: Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Text(
                    "Enter your email address to receive an OTP code.",
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
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "abc@gmail.com",
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: _handleSendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  minimumSize: Size(double.infinity, 56.h),
                ),
                child: Text(
                  "Send OTP",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ] else if (!_isOtpVerified) ...[
              SizedBox(
                height: 70.h,
                width: 230.w,
                child: Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Text(
                    "We've sent you the verification code on ${emailController.text.trim()}",
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
              OtpWidget(
                controller: otpController,
                onCompleted: (pin) => _handleVerifyOtp(),
              ),
            ] else ...[
              SizedBox(
                height: 70.h,
                width: 230.w,
                child: Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Text(
                    "Enter your new password.",
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
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "New Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  minimumSize: Size(double.infinity, 56.h),
                ),
                child: Text(
                  "Reset Password",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
