import 'dart:convert';

import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/auth/sign_in/pages/sign_in_page.dart';
import 'package:arab_socials/src/widgets/abouMe_popup.dart';
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
  State<Profilescreen> createState() => ProfilescreenState();
}

class ProfilescreenState extends State<Profilescreen>
    with ShowEditProfileDialog {
  static final GlobalKey<ProfilescreenState> globalKey =
      GlobalKey<ProfilescreenState>();
  final AuthService _authService = AuthService();

  // Reactive state variables
  final RxString name = ''.obs;
  final RxString aboutMe = ''.obs;
  final RxString phone = ''.obs;
  final RxString email = ''.obs;
  final RxString location = ''.obs;
  final RxString gender = ''.obs;
  final RxString dob = ''.obs;
  final RxString profession = ''.obs;
  final RxString nationality = ''.obs;
  final RxString maritalStatus = ''.obs;
  final RxList myInterest = RxList();

  final RxBool isLoading = true.obs;

  final RxBool aboutMeSwitch = false.obs;
  final RxBool interestsSwitch = false.obs;
  final RxBool locationSwitch = false.obs;
  final RxBool phoneSwitch = true.obs;
  final RxBool emailSwitch = true.obs;
  final RxBool genderSwitch = true.obs;
  final RxBool dobSwitch = true.obs;
  final RxBool professionSwitch = true.obs;
  final RxBool nationalitySwitch = true.obs;
  final RxBool maritalStatusSwitch = true.obs;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;
      final userInfo = await _authService.getUserInfo();

      name.value = userInfo['name'] ?? '';
      aboutMe.value = userInfo['about_me'] ?? '';
      phone.value = userInfo['phone'] ?? '';
      email.value = userInfo['email'] ?? '';
      location.value = userInfo['location'] ?? '';
      gender.value = userInfo['gender'] ?? '';
      dob.value = userInfo['dob'] ?? '';
      profession.value = userInfo['profession'] ?? '';
      nationality.value = userInfo['nationality'] ?? '';
      myInterest.assignAll(userInfo['interests']
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .map((item) => item.trim())
          .toList());
      maritalStatus.value = userInfo['marital_status'] ?? '';
      phoneSwitch.value = userInfo['phoneSwitch'] ?? true;
      emailSwitch.value = userInfo['emailSwitch'] ?? true;
      genderSwitch.value = userInfo['genderSwitch'] ?? true;
      dobSwitch.value = userInfo['dobSwitch'] ?? true;
      professionSwitch.value = userInfo['professionSwitch'] ?? true;
      nationalitySwitch.value = userInfo['nationalitySwitch'] ?? true;
      maritalStatusSwitch.value = userInfo['maritalStatusSwitch'] ?? true;
    } catch (e) {
      print('Error fetching user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showParagraphDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AboutMepopUp(
          title: "Edit About Me",
          hintText: "Type something about yourself...",
          initialText: aboutMe.value,
          onSave: (newText) {
            aboutMe.value = newText;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
        foregroundColor: const Color.fromARGB(255, 250, 244, 228),
        surfaceTintColor: const Color.fromARGB(255, 250, 244, 228),
        elevation: 0,
        leading: InkWell(
          onTap: () => navigationController.navigateBack(),
          child: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 35, 94, 77), size: 24),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 17.0),
            child: InkWell(
              onTap: () {
                Get.to(const Signinscreen());
              },
              child: const ImageIcon(
                AssetImage("assets/icons/profilelogout.png"),
                size: 23,
                color: Color.fromARGB(255, 35, 94, 77),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CustomContainer(
              text: "Edit Profile",
              image: "assets/icons/editprofile.png",
              onTap: () {
                showPopUp(context).then(
                  (value) {
                    List<dynamic> interestsList = updatedData['interests']
                        .replaceAll('[', '')
                        .replaceAll(']', '')
                        .split(',')
                        .map((item) => item.trim())
                        .toList();

                        myInterest.assignAll(interestsList);

                    name.value = updatedData["name"];
                    aboutMe.value = updatedData["about_me"];
                    phone.value = updatedData["phone"];
                    location.value = updatedData["location"];
                    gender.value = updatedData["gender"];
                    dob.value = updatedData["dob"];
                    profession.value = updatedData["profession"];
                    nationality.value = updatedData["nationality"];
                    maritalStatus.value = updatedData["marital_status"];
                    interests.assignAll(List.from(interestsList));

                    // phoneSwitch.value = updatedData["phoneSwitch"];9652
                    // emailSwitch.value = updatedData["emailSwitch"];
                    // genderSwitch.value = updatedData["genderSwitch"];
                    // dobSwitch.value = updatedData["dobSwitch"];
                    // professionSwitch.value = updatedData["professionSwitch"];
                    // nationalitySwitch.value = updatedData["nationalitySwitch"];
                    // maritalStatusSwitch.value = updatedData["maritalStatusSwitch"];
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
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
                        Obx(() => Text(
                              name.value,
                              style: GoogleFonts.playfairDisplaySc(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 35, 94, 77),
                              ),
                            )),
                        Obx(() => Text(
                              profession.value,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                              ),
                            )),
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
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () => _showParagraphDialog(context),
                      child: Icon(Icons.edit, color: Colors.green, size: 24),
                    ),
                    Spacer(),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: aboutMeSwitch.value,
                        onChanged: null,
                        activeColor: Colors.white,
                        activeTrackColor: const Color.fromARGB(255, 35, 94, 77),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Obx(() => Text(
                        aboutMe.value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      )),
                ),
                Row(
                  children: [
                    Text(
                      "INTERESTS",
                      style: GoogleFonts.playfairDisplaySc(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 35, 94, 77),
                      ),
                    ),
                    const Spacer(),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: interestsSwitch.value,
                        onChanged: null,
                        activeColor: Colors.grey,
                        activeTrackColor: Colors.grey[300],
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => SizedBox(
                    height: 25.h,
                    child: ListView.builder(
                 
                    scrollDirection: Axis.horizontal,
                    itemCount: myInterest.length,
                    itemBuilder: (context, index) {
                      return CustomIntrestsContainer(
                        text: Interest.fromApi(value: myInterest[index]).name,
                        color: Interest.fromApi(value: myInterest[index]).color,
                      );
                    },
                  )),

          ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "PERSONAL DETAILS",
                    style: GoogleFonts.playfairDisplaySc(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Obx(() => CustomData(
                    title: "Phone",
                    subtitle: phone.value,
                    showSwitch: true,
                    switchValue: phoneSwitch.value,
                    onSwitchChanged: (value) {
                      phoneSwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "Email",
                    subtitle: email.value,
                    showSwitch: true,
                    switchValue: emailSwitch.value,
                    onSwitchChanged: (value) {
                      emailSwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "Location",
                    subtitle: location.value,
                    showSwitch: true,
                    switchValue: false,
                    onSwitchChanged: (value) {})),
                Obx(() => CustomData(
                    title: "Gender",
                    subtitle: gender.value,
                    showSwitch: true,
                    switchValue: genderSwitch.value,
                    onSwitchChanged: (value) {
                      genderSwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "DOB",
                    subtitle: dob.value,
                    showSwitch: true,
                    switchValue: dobSwitch.value,
                    onSwitchChanged: (value) {
                      dobSwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "Profession",
                    subtitle: profession.value,
                    showSwitch: true,
                    switchValue: professionSwitch.value,
                    onSwitchChanged: (value) {
                      professionSwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "Nationality",
                    subtitle: nationality.value,
                    showSwitch: true,
                    switchValue: nationalitySwitch.value,
                    onSwitchChanged: (value) {
                      nationalitySwitch.value = value;
                    })),
                Obx(() => CustomData(
                    title: "Marital Status",
                    subtitle: maritalStatus.value,
                    showSwitch: true,
                    switchValue: maritalStatusSwitch.value,
                    onSwitchChanged: (value) {
                      maritalStatusSwitch.value = value;
                    })),
              ],
            ),
          ),
        );
      }),
    );
  }
}
