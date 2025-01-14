import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/models/home_model1.dart';
import 'package:arab_socials/src/view/events/register_event.dart';
import 'package:arab_socials/src/view/homepage/notification_screen.dart';
import 'package:arab_socials/src/widgets/custom_container.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
      final NavigationController navigationController = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
      body: GestureDetector(
        onTap: () {
           FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 112.h,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 35, 94, 77),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.h, left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Icon(Icons.search,
                      size: 30.sp,
                    ),
                    SizedBox(width: 8.w),
                   Expanded(
          child: TextField(
            decoration: InputDecoration(
        hintText: "Enter events, members, or business...",
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Color.fromARGB(255, 190, 218, 165),
        ),
        border: InputBorder.none, // Remove border if needed
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            style: TextStyle(
        fontSize: 14.sp,
        color: Color.fromARGB(255, 190, 218, 165),
            ),
            onChanged: (value) {
        print("Input: $value");
            },
          ),
        ),
        
                    InkWell(
                      onTap: () {
                         navigationController.navigateToChild(Notificationscreen());
                      },
                      child: Image(
                        image: const AssetImage('assets/icons/homenotify.png'),
                        height: 36.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 14),
                     child: SectionHeader(
                       title: "UPCOMING EVENTS",
                       actionText: "See all",
                       onTap: () {
                         print("See all tapped!");
                       },
                     ),
                   ),
                    InkWell(
                         onTap: () {
                             navigationController.navigateToChild(RegisterEvent());
                            },
                      child: SizedBox(
                        height: 237.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount: homescreenModelList.length,
                          itemBuilder: (context, index) {
                            final model = homescreenModelList[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Container(
                                width: 218.w,
                                height: 237.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Color.fromARGB(255, 247, 247, 247),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:BorderRadius.circular(16.r),
                                            child: Image.asset(
                                              model.mainImage ?? '',
                                              fit: BoxFit.cover,
                                              height: 131.h,
                                              width: double.infinity,
                                            ),
                                          ),
                                         Positioned(
                                top: 8.h,
                                right: 8.w,
                                child: GestureDetector(
                                  onTap: () {
                                    model.isBookmarked = !model.isBookmarked;
                                    (context as Element).markNeedsBuild(); 
                                  },
                                  child: Container(
                                    height: 24.h,
                                    width: 23.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),
                                    child: Icon(
                                      model.isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_outline,
                                      color: Colors.green,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                                          Positioned(
                                            top: 8.h,
                                            left: 8.w,
                                            child: Container(
                                              height: 36.h,
                                              width: 36.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6.r),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    model.day ?? '',
                                                    style: GoogleFonts.playfairDisplaySc(
                                                      fontSize: 14.sp,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    model.month ?? '',
                                                    style: GoogleFonts.playfairDisplaySc(
                                                      fontSize: 8.sp,
                                                      color: Colors.green,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      // Title
                                      Text(model.title ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.playfairDisplaySc(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Container(
                                            height: 24.h,
                                            width: 56.w,
                                            child: Stack(
                                              children: [
                                                CircleAvatar(
                                                  radius: 10.r,
                                                  backgroundImage: AssetImage(model.image1 ?? ''),
                                                ),
                                                Positioned(
                                                  left: 10.w,
                                                  child: CircleAvatar(
                                                    radius: 10.r,
                                                    backgroundImage: AssetImage(
                                                        model.image2 ?? ''),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 25.w,
                                                  child: CircleAvatar(
                                                    radius: 10.r,
                                                    backgroundImage: AssetImage(model.image3 ?? ''),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            model.subtitle ?? '',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color:Color.fromARGB(255, 35, 94, 77),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                              
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Icon(model.locationIcon ?? Icons.location_on,
                                            size: 16.sp,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              model.locationText ?? '',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 86.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 190, 218, 165),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Promote events",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color.fromARGB(
                                                255, 35, 94, 77),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
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
                                            "PROMOTE",
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
                                  Image.asset('assets/logo/homepromote.png',
                                    height: 85.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ],
                              ),
                            ),
                          ),
                         SectionHeader(
                             title: "FEATURED BUSINESS",
                             actionText: "See all",
                             onTap: () {
                               print("See all tapped!");
                             },
                           ),
                          SizedBox(
                            height: 80.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homescreenlogoList.length * 2,
                              itemBuilder: (context, index) {
                                final logoModel = homescreenlogoList[
                                    index % homescreenlogoList.length];
                                final logoPaths = [
                                  logoModel.logoimage,
                                  logoModel.logoimage1,
                                  logoModel.logoimage2,
                                  logoModel.logoimage3,
                                ];
                                return Row(
                                  children: logoPaths.map((imagePath) {
                                    if (imagePath != null) {
                                      return CustomLogoContainer(imagePath: imagePath);
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Container(
                              height: 86.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 190, 218, 165),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    // Text and Promote button
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Invite your friends",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w700,
                                              color: const Color.fromARGB(
                                                  255, 35, 94, 77),
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:const Color.fromARGB(255, 35, 94, 77),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
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
                                    // Image Section
                                    Image.asset(
                                      'assets/logo/greensearch.png',
                                      height: 85.h,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SectionHeader(
                            title: "PEOPLE IM CONNECTED TO",
                            actionText: "See all",
                            onTap: () {
                              print("See all tapped!");
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 88.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 20,
                                itemBuilder: (context, index) {
                                  final model = homescreenfotterList[
                                      index % homescreenfotterList.length];
                                  return Padding(
                                    padding: EdgeInsets.only(right: 12.w),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: Image.asset(
                                            model.fotterimage ?? '',
                                            width: 58.w,
                                            height: 58.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Text(
                                          model.title ?? '',
                                          style: GoogleFonts.playfairDisplaySc(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        // Subtitle
                                        Text(
                                          model.subtitle ?? '',
                                          style: TextStyle(
                                            fontSize: 6.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
