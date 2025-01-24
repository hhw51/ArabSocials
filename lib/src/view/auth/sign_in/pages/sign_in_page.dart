import 'package:arabsocials/src/controllers/password_visible.dart';
import 'package:arabsocials/src/controllers/userlogin_controller.dart';
import 'package:arabsocials/src/view/auth/sign_up/pages/sign_up_page.dart';
import 'package:arabsocials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../forget_password/forget_password.dart'; // Add this line
 

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final SignUpController _signUpController = Get.put(SignUpController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PasswordVisibilityController visibilityController =
      Get.put(PasswordVisibilityController());
  bool _isRememberMe = true; // Add this line
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(); // Add this line

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Add this line
  }

  Future<void> _loadCredentials() async { // Add this method
    String? email = await _secureStorage.read(key: 'email');
    String? password = await _secureStorage.read(key: 'password');
    if (email != null && password != null) {
      emailController.text = email;
      passwordController.text = password;
      _signUpController.login(email, password);
    }
  }

  Future<void> _saveCredentials(String email, String password) async { // Add this method
    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
  }

  Future<void> _deleteCredentials() async { // Add this method
    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'password');
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      'assets/logo/logo.png',
                      width: 210.w,
                      height: 96.h,
                      color: const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SIGN IN",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 15.h),
                    CustomTextField(
                      controller: emailController,
                      hintText: "abc@gmail.com",
                      prefixIcon: Icons.email_outlined, obscureText: false,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: _isRememberMe, // Update this line
                                onChanged: (value) {
                                  setState(() {
                                    _isRememberMe = value;
                                  });
                                },
                                activeColor: Colors.white,
                                activeTrackColor:
                                const Color.fromARGB(255, 35, 94, 77),
                                inactiveTrackColor: Colors.grey[500], // Update this line
                              ),
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.offAll(() => ForgetPasswordScreen());
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
          
                    /// **SIGN IN BUTTON** (Calls `login`)
                    ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
          
                        if (email.isEmpty || password.isEmpty) {
                          Get.snackbar('Error', 'Please fill in all fields');
                          return;
                        }

                        if (_isRememberMe) {
                          await _saveCredentials(email, password); // Add this line
                        } else {
                          await _deleteCredentials(); // Add this line
                        }
          
                        _signUpController.login(email, password);
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
                      onPressed: () {
                        _signUpController.signInWithGoogle();
                      },
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
                        "Login with Google",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
          
                    SizedBox(height: 10.h),
          
                    /// **FACEBOOK LOGIN**
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement Facebook login
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                        "Login with Facebook",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
          
                    SizedBox(height: 20.h),
          
                    /// **Sign Up Navigation**
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => SignUpScreen());
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: const Color.fromARGB(255, 63, 90, 227),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
