import 'package:arab_socials/src/controllers/userlogin_controller.dart';
import 'package:arab_socials/src/view/homepage/homescreen.dart';
import 'package:arab_socials/src/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arab_socials/src/widgets/otp_widget.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String email; // <-- add email here
  final TextEditingController _pinController = TextEditingController();

  OtpVerifyScreen({Key? key, required this.email}) : super(key: key);

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
      await signUpController.verifyOtp(email, enteredOtp);

      // If successful
      Get.snackbar(
        "Success",
        "OTP Verified!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.to(() => BottomNav());

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
                  "We’ve sent you the verification code on $email",
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
                ElevatedButton(
                  onPressed: _handleVerifyOtp, // verify OTP on backend
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    minimumSize: Size(double.infinity, 56.h),
                  ),
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
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
                      "0:20",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
