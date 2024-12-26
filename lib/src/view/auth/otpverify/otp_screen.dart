import 'package:arab_socials/src/view/auth/sign_up/pages/sign_up_page.dart';
import 'package:arab_socials/src/view/homepage/homescreen.dart';
import 'package:arab_socials/src/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arab_socials/src/widgets/otp_widget.dart'; 

class OtpVerifyScreen extends StatelessWidget {
  final TextEditingController _pinController = TextEditingController();

  OtpVerifyScreen({super.key});

  void _handleVerifyOtp() {
    final enteredOtp = _pinController.text;
    if (enteredOtp == "123456") {
      Get.snackbar(
        "Success",
        "OTP Verified!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Invalid OTP. Please try again.",
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
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 35, 94, 77),size: 28,),
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
            Container(
              height: 50.h,
              width: 230.w,
              child: Padding(
                padding: const EdgeInsets.only(right: 17),
                child: Text(
                  "We’ve sent you the verification code on +1 2620 0323 7631",
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
                  onPressed: () {
                    Get.to(() => BottomNav());
                  },
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
