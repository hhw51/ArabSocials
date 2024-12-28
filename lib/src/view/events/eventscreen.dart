import 'package:arab_socials/src/models/event_model.dart';
import 'package:arab_socials/src/widgets/custonbuttons.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Eventscreen extends StatelessWidget {
  const Eventscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Row(
                children: [
                  const SizedBox(
                    child: Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 35, 94, 77),
                      size: 24,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(child: SizedBox()),
                  SizedBox(
                    width: 5.w,
                  ),
                  const CustomContainer(
                    text: "Saved",
                    icon: Icons.bookmark_border,
                  ),
                  const CustomContainer(
                    text: "Location",
                    icon: Icons.location_on_outlined,
                  ),
                  const CustomContainer(
                    text: "Date",
                    image: "assets/icons/calculator.png",
                  ),
                  const CustomContainer(
                    text: "Type",
                    icon: Icons.filter_alt_outlined,
                  ),
                ],
              ),
            ),

            // Custom Buttons Row
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Custombutton(
                          text: "Sports",
                          icon: Icons.sports_basketball,
                          color: const Color.fromARGB(255, 240, 99, 90),
                        ),
                        Custombutton(
                          text: "Music",
                          image: "assets/icons/musicicon.png",
                          color: const Color.fromARGB(255, 245, 151, 98),
                        ),
                        Custombutton(
                          text: "Food",
                          image: "assets/icons/foodicon.png",
                          color: const Color.fromARGB(255, 41, 214, 151),
                        ),
                        Custombutton(
                          text: "Drawing",
                          image: "assets/icons/painticon.png",
                          color: const Color.fromARGB(255, 70, 205, 251),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            // Section Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "EXPLORE EVENTS",
                style: GoogleFonts.playfairDisplaySc(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: const CustomTextFormField(
                hintText: "Search events",
              ),
            ),

            // Expanded ListView for Events
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                height: 535.h,
                child: ListView.builder(
                  itemCount: eventModelList.length,
                  itemBuilder: (context, index) {
                    final model = eventModelList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: 233.h,
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
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      model.mainImage ?? '',
                                      fit: BoxFit.cover,
                                      height: 131.h,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.h,
                                    left: 8.w,
                                    child: Container(
                                      height: 34.h,
                                      width: 36.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            model.day ?? '',
                                            style: GoogleFonts
                                                .playfairDisplaySc(
                                              fontSize: 14.sp,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            model.month ?? '',
                                            style: GoogleFonts
                                                .playfairDisplaySc(
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
                                  Positioned(
                                    top: 10.h,
                                    right: 12.w,
                                    child: Container(
                                      height: 32.h,
                                      width: 32.w,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Icon(
                                        model.bookmarkIcon ?? Icons.bookmark,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    child: Row(
                                      children: [
                                        Text(
                                          model.title ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.playfairDisplaySc(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          height: 20.h,
                                          width: 20.h,
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 35, 94, 77),
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Icon(
                                            Icons.more_vert,
                                            size: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 24.h,
                                        width: 56.w,
                                        child: Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 10.r,
                                              backgroundImage: AssetImage(
                                                  model.image1 ?? ''),
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
                                                backgroundImage: AssetImage(
                                                    model.image3 ?? ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        model.subtitle ?? '',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Color.fromARGB(
                                              255, 35, 94, 77),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          model.locationIcon ??
                                              Icons.location_on,
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
          ],
        ),
      floatingActionButton: Padding(
  padding: EdgeInsets.only(bottom: 10.h, right: 10.w), 
  child: Container(
    height: 40.h, 
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 35, 94, 77), 
      borderRadius: BorderRadius.circular(15.r), 
    ),
    child: TextButton(
      onPressed: () {
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w), 
      ),
      child: Text(
        "PROMOTE",
        style: TextStyle(
          fontSize: 14.sp, 
          fontWeight: FontWeight.w700, 
          color: const Color.fromARGB(255, 250, 244, 228), 
        ),
      ),
    ),
  ),
),
floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positioned at the right-end


      ),
    );
  }
}
