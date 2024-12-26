import 'package:arab_socials/src/view/auth/splash_steps/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
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
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)),
            useMaterial3: true,
          ),
          home:  const Splashscreen(),
        );
      },
    );
  }
}
