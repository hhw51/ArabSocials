import 'package:arab_socials/src/controllers/password_visible.dart';
import 'package:arab_socials/src/controllers/user_controller.dart'; // <-- Make sure this is your SignUpController path
import 'package:arab_socials/src/view/auth/sign_up/pages/sign_up_page.dart';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../widgets/bottom_nav.dart';

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


  /// For Google sign-in
  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the Google credentials
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // We get or create our SignUpController instance:


    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
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
                    prefixIcon: Icons.email_outlined,
                    isPassword: false,
                   obscureText: false,
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
                onPressed: () => visibilityController.toggleVisibility('password'),
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
                              value: true,
                              onChanged: (value) {},
                              activeColor: Colors.white,
                              activeTrackColor:
                              const Color.fromARGB(255, 35, 94, 77),
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
                          // Forgot Password Action
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
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar('Error', 'Please fill in all fields');
                        return;
                      }

                      // Call login in the SignUpController
                      _signUpController.login(email, password);

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

                  /// **GOOGLE LOGIN**
                  ElevatedButton.icon(
                    onPressed: () async {
                      User? user = await _signInWithGoogle();
                      if (user != null) {
                        // Successfully signed in
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Welcome ${user.displayName}')),
                        );
                      } else {
                        // Sign-in failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Google sign-in failed')),
                        );
                      }
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
    );
  }
}
