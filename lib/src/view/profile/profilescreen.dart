import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/widgets/custom_profiletext.dart';
import 'package:arab_socials/src/widgets/custombuttons.dart';
import 'package:arab_socials/src/widgets/edit_profile_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  @override
  Widget build(BuildContext context) {
    final RxBool rememberMe = false.obs;
    final NavigationController navigationController = Get.put(NavigationController());
     // Define state for each switch
  final phoneSwitch = false.obs;
  final emailSwitch = false.obs;
  final locationSwitch = false.obs;
  final genderSwitch = false.obs;
  final dobSwitch = false.obs;
  final professionSwitch = false.obs;
  final nationalitySwitch = false.obs;
  final maritalStatusSwitch = false.obs;
  final RxBool aboutMeSwitch = false.obs;
  final RxBool interestsSwitch = false.obs;
  // final RxBool socialMediaSwitch = false.obs;


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 228),
             appBar: AppBar(
        automaticallyImplyLeading: false, 
       backgroundColor: const Color.fromARGB(255, 250, 244, 228),
       surfaceTintColor: const Color.fromARGB(255, 250, 244, 228),
        elevation: 0, 
        leading: InkWell(
    onTap: () {
      navigationController.navigateBack(); 
    },
    child: const Icon(
      Icons.arrow_back,
      color: Color.fromARGB(255, 35, 94, 77),
      size: 24,
    ),
        ),
        actions: [
  Padding(
    padding: EdgeInsets.only(right: 16.0),
    child: InkWell(
      onTap: () {
    showEditProfileDialog(context); // Call the dialog from here
      },
      child: const CustomContainer(
        text: "Edit Profile",
        image: "assets/icons/editprofile.png",
      ),
    ),
  ),
],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                "PROFILE",
                style: GoogleFonts.playfairDisplaySc(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: 96.h,
                        width: 96.w,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logo/profileimage.png"),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "ASHFAK SAYEM",
                         style: GoogleFonts.playfairDisplaySc(
                                          fontSize: 16.sp,
                                          color: const Color.fromARGB(255, 35, 94, 77),
                                          fontWeight: FontWeight.w700,
                                        ),
                      ),
                      Text(
                        "Software Engineer",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text(
                    "ABOUT ME",
                   style: GoogleFonts.playfairDisplaySc(
                       fontSize: 14.sp,
                        color: const Color.fromARGB(255, 35, 94, 77),
                       fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                Transform.scale(
  scale: 0.7,
  child: Obx(() => Switch(
    value: aboutMeSwitch.value,
    onChanged: (value) => aboutMeSwitch.value = value,
    activeColor: Colors.white,
    activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
    inactiveThumbColor: Colors.grey,
    inactiveTrackColor: Colors.grey[300],
  )),
),
                ],
              ),
              Text(
                "Enjoy your favorite dish and a lovely time with your friends and family. Food from local food trucks will be available for purchase. Read More",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 143, 146, 137),
                ),
              ),
              Row(
                children: [
                  Text(
                    "INTERESTS",
                    style: GoogleFonts.playfairDisplaySc(
                       fontSize: 14.sp,
                        color: const Color.fromARGB(255, 35, 94, 77),
                       fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                 Transform.scale(
  scale: 0.7,
  child: Obx(() => Switch(
    value: interestsSwitch.value,
    onChanged: (value) => interestsSwitch.value = value,
    activeColor: Colors.white,
    activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
    inactiveThumbColor: Colors.grey,
    inactiveTrackColor: Colors.grey[300],
  )),
),
                ],
              ),
              const Row(
                children: [
                  CustomIntrestsContainer(
                    text: "Games Online",
                    color: Color.fromARGB(255, 240, 99, 90),
                  ),
                  CustomIntrestsContainer(
                    text: "Music",
                    color: Color.fromARGB(255, 245, 151, 98),
                  ),
                  CustomIntrestsContainer(
                    text: "Movies",
                    color: Color.fromARGB(255, 41, 214, 151),
                  ),
                  CustomIntrestsContainer(
                    text: "Art",
                    color: Color.fromARGB(255, 70, 205, 251),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "PERSONAL DETAILS",
                  style: GoogleFonts.playfairDisplaySc(
                       fontSize: 14.sp,
                        color: const Color.fromARGB(255, 35, 94, 77),
                       fontWeight: FontWeight.w700,
                    ),
                ),
              ),
           Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Obx(() => CustomData(
          title: "Phone",
          subtitle: "555 568 254 789",
          showSwitch: true,
          switchValue: phoneSwitch.value,
          onSwitchChanged: (value) => phoneSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Email",
          subtitle: "user@example.com",
          showSwitch: true,
          switchValue: emailSwitch.value,
          onSwitchChanged: (value) => emailSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Location",
          subtitle: "New York, USA",
          showSwitch: true,
          switchValue: locationSwitch.value,
          onSwitchChanged: (value) => locationSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Gender",
          subtitle: "Male",
          showSwitch: true,
          switchValue: genderSwitch.value,
          onSwitchChanged: (value) => genderSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "D.O.B",
          subtitle: "03-11-2005",
          showSwitch: true,
          switchValue: dobSwitch.value,
          onSwitchChanged: (value) => dobSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Profession",
          subtitle: "Software Engineer",
          showSwitch: true,
          switchValue: professionSwitch.value,
          onSwitchChanged: (value) => professionSwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Nationality",
          subtitle: "USA",
          showSwitch: true,
          switchValue: nationalitySwitch.value,
          onSwitchChanged: (value) => nationalitySwitch.value = value,
        )),
    Obx(() => CustomData(
          title: "Marital Status",
          subtitle: "Single",
          showSwitch: true,
          switchValue: maritalStatusSwitch.value,
          onSwitchChanged: (value) => maritalStatusSwitch.value = value,
        )),
  ],
),
 ],
          ),
        ),
      ),
    );
  }
}



















//               Row(
//                 children: [
//                   Text(
//                     "SOCIAL MEDIA",
//                      style: GoogleFonts.playfairDisplaySc(
//                        fontSize: 14.sp,
//                         color: const Color.fromARGB(255, 35, 94, 77),
//                        fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const Spacer(),
//                  Transform.scale(
//   scale: 0.7,
//   child: Obx(() => Switch(
//     value: socialMediaSwitch.value,
//     onChanged: (value) => socialMediaSwitch.value = value,
//     activeColor: Colors.white,
//     activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
//     inactiveThumbColor: Colors.grey,
//     inactiveTrackColor: Colors.grey[300],
//   )),
// ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Image.asset("assets/icons/instagram.png",height: 20,width: 20,),
//                   SizedBox(width: 6),
//                   Image.asset("assets/icons/linkedin.png", height: 20,width: 20,),
//                   SizedBox(width: 6),
//                   Icon(Icons.facebook, size: 25, color: Colors.black,)
//                 ],
//               )
           
