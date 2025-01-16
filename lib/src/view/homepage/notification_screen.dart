import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          navigationController.navigateBack();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color.fromARGB(255, 35, 94, 77),
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "NOTIFICATIONS",
                style: GoogleFonts.playfairDisplaySc(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Clear",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 1, 
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: const Color.fromARGB(255, 200, 230, 201),
                            backgroundImage: AssetImage("assets/logo/image1.png"),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigationController.updateIndex(4);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Please complete your profile",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "5 minutes ago",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}