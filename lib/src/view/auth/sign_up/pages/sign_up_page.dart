import 'package:arab_socials/src/controllers/password_visible.dart';
import 'package:arab_socials/src/controllers/userlogin_controller.dart';
import 'package:arab_socials/src/view/auth/otpverify/otp_screen.dart';
import 'package:arab_socials/src/view/auth/sign_in/pages/sign_in_page.dart';
import 'package:arab_socials/src/widgets/snack_bar_widget.dart';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController _signUpController = Get.put(SignUpController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
   final TextEditingController phoneController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =TextEditingController();
   final PasswordVisibilityController visibilityController =Get.put(PasswordVisibilityController());

  final RxBool rememberMe = false.obs;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_outlined, color: Color.fromARGB(255, 35, 94, 77),size: 30,),
                    onPressed: () => Get.back(),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "CREATE YOUR ACCOUNT",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  CustomTextField(
                    controller: nameController,
                   // labelText: "Full Name",
                    hintText: "Full name",
                    prefixIcon: Icons.person_outline,
                    isPassword: false,
                    obscureText: false,
                  ),
                  CustomTextField(
                    controller: emailController,
                   // labelText: "Email Address",
                    hintText: "abc@email.com",
                    prefixIcon: Icons.email_outlined,
                    isPassword: false,
                    obscureText: false,
                  ),
                   CustomTextField(
                    controller: phoneController,
                   // labelText: "Phone Number",
                    hintText: "Enter your Phone Number",
                    prefixIcon: Icons.phone_outlined,
                    isPassword: false,
                    obscureText: true,
                  ),
                  CustomDropdown(
                    controller: accountController,
                   // labelText: "Account Type",
                    hintText: "Account type",
                    prefixIcon: Icons.person_2_outlined,
                    items: const [
                      "Personal",
                      "Business",
                    ], 
                    onChanged: (value) {
                      print("Selected Account Type: $value");
                    },
                  ),
                  Obx(() => CustomTextField(
                        controller: passwordController,
                        hintText: "Your password",
                        isPassword: true,
                        obscureText: !visibilityController.isVisible('password'),
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            visibilityController.isVisible('password')
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () =>
                              visibilityController.toggleVisibility('password'),
                        ),
                      )),
                  Obx(() => CustomTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm password",
                        isPassword: true,
                        obscureText:
                            !visibilityController.isVisible('confirmPassword'),
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            visibilityController.isVisible('confirmPassword')
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () => visibilityController
                              .toggleVisibility('confirmPassword'),
                        ),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: rememberMe.value,
                                onChanged: (value) => rememberMe.value = value,
                              ),
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Colors.black,fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Obx(() {
                    return _signUpController.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          showErrorSnackbar('All fields are required');
                          return;
                        }

                        try {
                          // 1. Call signUp API
                          await _signUpController.signUp(name, email, password);

                          // 2. If sign-up is successful, call sendOtp
                          await _signUpController.sendOtp(email);

                          // 3. Finally, navigate to OTP Screen (assuming it’s named OTPScreen)
                          Get.to(() => OtpVerifyScreen(email: email));

                        } catch (error) {
                          // Handle any error from signUp or sendOtp
                         showErrorSnackbar(error.toString());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        minimumSize: Size(double.infinity, 56.h),
                      ),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),


                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey[200],
                          thickness: 1.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Text(
                          "or",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey[200],
                          thickness: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      minimumSize: Size(double.infinity, 52.h),
                    ),
                    icon: Image.asset(
                      'assets/icons/google.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                    label: Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      minimumSize: Size(double.infinity, 52.h),
                    ),
                    icon: Image.asset(
                      'assets/icons/facebook.png',
                      width: 20.w,
                      height: 20.h,
                    ),
                    label: Text(
                      "Continue with Facebook",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.grey[900],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                             Get.to(() => Signinscreen());
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 15.sp,
                             color: const Color.fromARGB(255, 63, 90, 227),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}