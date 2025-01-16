import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/controllers/registerEventController.dart';
import 'package:arab_socials/src/view/auth/splash_steps/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  Get.put(RegisterEventController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812), 
      builder: (context, child) {
        return GetMaterialApp(  
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 250, 244, 228),
            fontFamily: 'PlayfairDisplaySC',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData( color: Color.fromARGB(255, 225, 173, 116),),
             switchTheme: SwitchThemeData(
           thumbColor: WidgetStateProperty.all(Colors.white),
            trackColor: WidgetStateProperty.all(const Color.fromARGB(255, 35, 94, 77)),
           overlayColor: WidgetStateProperty.all(const Color.fromARGB(255, 35, 94, 77).withOpacity(0.3)),
      ),
            useMaterial3: true,
          ),
          home:  const Splashscreen(),
        );
      },
    );
  }
}
