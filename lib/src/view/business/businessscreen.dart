import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/view/profile/ProfileDetailsScreen.dart';
import 'package:arab_socials/src/widgets/business_tiles.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/textfomr_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Businessscreen extends StatefulWidget {
  const Businessscreen({super.key});

  @override
  State<Businessscreen> createState() => _BusinessscreenState();
}

class _BusinessscreenState extends State<Businessscreen> {
  final NavigationController navigationController =
      Get.put(NavigationController());
      
  final List<Map<String, String>> members = [
    {
      "name": "Alex Lee",
      "category": "Other Hookah Lounge",
      "location": "Florida",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Sarah Smith",
      "category": "Graphic Designer",
      "location": "California",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "John Doe",
      "category": "Software Engineer",
      "location": "New York",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Jane Wilson",
      "category": "Marketing Manager",
      "location": "Texas",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Sarah Smith",
      "category": "Graphic Designer",
      "location": "California",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Sarah Smith",
      "category": "Graphic Designer",
      "location": "California",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Sarah Smith",
      "category": "Graphic Designer",
      "location": "California",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
    {
      "name": "Chris Evans",
      "category": "Fitness Trainer",
      "location": "Nevada",
      "imagePath": "assets/logo/buisnesss_group.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 250, 244, 228),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestScopeFocus();
            },
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            navigationController.navigateBack();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: const Color.fromARGB(255, 35, 94, 77),
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
                          text: "Favourite",
                          icon: Icons.favorite_border,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        const CustomContainer(
                          text: "Location",
                          icon: Icons.location_on_outlined,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        const CustomContainer(
                          text: "Catagories",
                          icon: Icons.widgets_outlined,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Text(
                      "Businesses Directory",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const CustomTextFormField(
                      hintText: "Search businesses by name or category",
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return BusinessTile(
                            imagePath: member["imagePath"]!,
                            name: member["name"]!,
                            category: member["category"]!,
                            location: member["location"]!,
                            isCircular: false,
                            onTap: () {
                              navigationController.navigateToChild(
                                ProfileDetailsScreen(
                                  title: "Business Profile",
                                  name: member["name"]!,
                                  professionOrCategory: member["category"]!,
                                  location: member["location"]!,
                                  about: "Details about the business",
                                  interestsOrCategories: [
                                    "Technology",
                                    "Innovation",
                                    "Networking"
                                  ],
                                  personalDetails: {
                                    "Phone": "4788743654478",
                                    "Email": "user@${member["name"]}",
                                    "Location": member["location"]!,
                                    "Profession": member["category"]!,
                                  },
                                ),
                              );
                            },
                          );
                        }),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
