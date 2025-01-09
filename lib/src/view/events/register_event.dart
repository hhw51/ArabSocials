import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterEvent extends StatefulWidget {
  const RegisterEvent({super.key});

  @override
  State<RegisterEvent> createState() => _RegisterEventState();
}

class _RegisterEventState extends State<RegisterEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 300.h, 
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Header Image
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                  child: Image.asset(
                    "assets/logo/homegrid.png",
                    fit: BoxFit.cover,
                    height: 261.h,
                    width: double.infinity,
                  ),
                ),
                  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 35.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final NavigationController navigationController = Get.find();
                         navigationController.navigateBack();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Explore Events",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),]),
    
                // White Container
                Positioned(
                  bottom: 1.h, // Partially overlapping the image
                  left: 16.w,
                  right: 16.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Overlapping Circular Avatars
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundImage:
                                  AssetImage("assets/logo/image1.png"),
                            ),
                            Positioned(
                              left: 24.w,
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundImage:
                                    AssetImage("assets/logo/image2.png"),
                              ),
                            ),
                            Positioned(
                              left: 48.w,
                              child: CircleAvatar(
                                radius: 18.r,
                                backgroundImage:
                                    AssetImage("assets/logo/image3.png"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 60.w), 
                        Text(
                          "+20 Going",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color.fromARGB(255, 35, 94, 77),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:BorderRadius.circular(8.r),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        ),
                                        child: Text(
                                          "INVITE",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color.fromARGB(
                                                255, 250, 244, 228),
                                          ),
                                        ),
                                      ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    
          Padding(
            padding: EdgeInsets.only(left: 16,right: 16,top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
             Text(
      "INTERNATIONAL BAND MUSIC CONCERT",
      style: GoogleFonts.playfairDisplaySc(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
    SizedBox(height: 12.h),

    ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.calendar_today_outlined,
        size: 16.sp,
        color: Colors.grey,
      ),
      title: Text(
        "14 December, 2021",
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        "Tuesday, 4:00PM - 9:00PM",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
        ),
      ),
    ),
    ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.location_on_outlined,
        size: 16.sp,
        color: Colors.grey,
      ),
      title: Text(
        "Gala Convention Center",
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        "36 Guild Street London, UK",
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey,
        ),
      ),
    ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundImage: AssetImage("assets/logo/image1.png"),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ashfak Sayem",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Organizer",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                    "ABOUT",
                   style: GoogleFonts.playfairDisplaySc(
                       fontSize: 14.sp,
                        color: const Color.fromARGB(255, 35, 94, 77),
                       fontWeight: FontWeight.w700,
                    ),
                  ),
                   SizedBox(height: 10.h),
                   Text(
                "Enjoy your favorite dish and a lovely time with your friends and family. Food from local food trucks will be available for purchase. Read More",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 143, 146, 137),
                ),
              ),
               SizedBox(height: 15.h),
              ElevatedButton(
                      onPressed: (){
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        minimumSize: Size(double.infinity, 56.h),
                      ),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
