
import 'package:arabsocials/src/controllers/userlogin_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';  

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
 void splash(){
  Future.delayed(Duration(seconds: 3),()async{
// Get.to(() => Stepscreen());
// await Get.find<SignUpController>().setLoginState();
Get.put(SignUpController());
await Get.find<SignUpController>().setLoginState();
  });
 }
  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // Initialize opacity animation
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Initialize scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start the animation
    _animationController.forward();
    splash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 35, 94, 77),
      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation, 
              child: ScaleTransition(
                scale: _scaleAnimation, 
                child: Image.asset(
                  'assets/logo/logo.png',
                  width: 240.w,
                  height: 104.h,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FadeTransition(
                    opacity: _opacityAnimation, 
                    child: Text(
                      "DISCOVER, CONNECT, GROW",
                      style: GoogleFonts.playfairDisplaySc(
                 fontSize: 18.sp,
              fontWeight: FontWeight.w700, color: const Color.fromARGB(255, 254, 235, 196),)
                    ),
                  ),
                  FadeTransition(
                    opacity: _opacityAnimation, 
                    child: Text(
                      "All in One Place!",
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
