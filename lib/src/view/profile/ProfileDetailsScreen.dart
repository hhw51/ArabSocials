import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/widgets/custom_details.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileDetailsScreen extends StatelessWidget {
  final String title;
  final String name;
  final String professionOrCategory;
  final String location;
  final String about;
  final List<String>? interestsOrCategories;
  final Map<String, String>?personalDetails; 
  final List<String>? excludedFields; 
  final bool showPersonalDetails;

  const ProfileDetailsScreen({
    super.key,
    required this.title,
    required this.name,
    required this.professionOrCategory,
    required this.location,
    required this.about,
    this.interestsOrCategories,
    this.personalDetails,
    this.excludedFields,
    this.showPersonalDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors for interests
    final List<Color> interestColors = [
      const Color.fromARGB(255, 240, 99, 90),
      const Color.fromARGB(255, 245, 151, 98),
      const Color.fromARGB(255, 41, 214, 151),
      Colors.purpleAccent,
      Colors.teal,
      Colors.redAccent,
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 35, 94, 77)),
          onPressed: () {
            final NavigationController navigationController = Get.find();
            navigationController.navigateBack();
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.playfairDisplaySc(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // Profile Image and Name
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48.r,
                      backgroundImage:
                          AssetImage("assets/logo/profileimage.png"),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      name,
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    Text(
                      professionOrCategory,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),

              // About Section
              Text(
                title == "Member Profile" ? "About Me" : "About Business",
                style: GoogleFonts.playfairDisplaySc(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 35, 94, 77),
                ),
              ),
              Text(
                about,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color.fromARGB(255, 143, 146, 137),
                ),
              ),
              SizedBox(height: 20.h),

              // Interests Section
              if (interestsOrCategories != null) ...[
                Text(
                  title == "Member Profile" ? "Interests" : "Categories",
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 35, 94, 77),
                  ),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  runSpacing: 4.h,
                  children: interestsOrCategories!
                      .asMap()
                      .entries
                      .map(
                        (entry) => CustomIntrestsContainer(
                          text: entry.value,
                          color:
                              interestColors[entry.key % interestColors.length],
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 20.h),
              ],

              // Personal Details Section
              if (showPersonalDetails && personalDetails != null) ...[
                Text(
                  "Personal Details",
                  style: GoogleFonts.playfairDisplaySc(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 35, 94, 77),
                  ),
                ),
                ...personalDetails!.entries
                    .where((entry) =>
                        excludedFields == null ||
                        !excludedFields!.contains(entry.key))
                    .map(
                      (entry) => CustonDetails(
                        title: entry.key,
                        subtitle: entry.value,
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
