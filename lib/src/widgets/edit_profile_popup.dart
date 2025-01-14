import 'dart:io';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/widgets/date_time_picker.dart';
import 'package:arab_socials/src/widgets/snack_bar_widget.dart';
import 'package:arab_socials/src/view/profile/profilescreen.dart';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

mixin ShowEditProfileDialog {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController martialController = TextEditingController();
  final TextEditingController profrssionController = TextEditingController();
  final RxList<String> interests = RxList();
  final TextEditingController intrestController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);

  Map<String, dynamic> updatedData = {};

  Future<void> showPopUp(BuildContext context) async {
    // Prepopulate TextFields with existing data
    nameController.text = updatedData["name"] ?? "";
    phoneController.text = updatedData["phone"] ?? "";
    locationController.text = updatedData["location"] ?? "";
    dateofbirthController.text = updatedData["dob"] ?? "";
    genderController.text = updatedData["gender"] ?? "";
    nationalityController.text = updatedData["nationality"] ?? "";
    martialController.text = updatedData["marital_status"] ?? "";
    profrssionController.text = updatedData["profession"] ?? "";
    aboutmeController.text = updatedData["about_me"] ?? "";

 if (updatedData['interests'] != null && updatedData['interests'] is List) {
  interests.assignAll(
    (updatedData['interests'] as List).map((e) => e.toString().trim()).toList(),
  );
} else {
  interests.clear();
}


    await Get.dialog(
      barrierColor: const Color.fromARGB(255, 250, 244, 228),
      Material(
        color: const Color.fromARGB(255, 250, 244, 228),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Profile Image
                        Obx(() => GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  selectedImage.value = File(pickedFile.path);
                                }
                              },
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: selectedImage.value != null
                                    ? FileImage(selectedImage.value!)
                                    : const AssetImage("assets/logo/profileimage.png") as ImageProvider,
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt, color: Colors.black, size: 18),
                                  ),
                                ),
                              ),
                            )),

                        SizedBox(height: 16.h),
                        CustomTextField(
                          controller: nameController,
                          hintText: "Enter your name",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: phoneController,
                          hintText: "Enter your phone",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: locationController,
                          hintText: "Enter your location",
                          obscureText: false,
                        ),
                        DatePickerFieldWidget(
                            controller: dateofbirthController, hintText: "Your Date of Birth"),
                        SizedBox(height: 10.h),
                        CustomTextField(
                          controller: profrssionController,
                          hintText: "Your Profession",
                          obscureText: false,
                        ),
                        CustomDropdown(
                          controller: genderController,
                          hintText: "Your Gender",
                          prefixIcon: Icons.person_2_outlined,
                          items: const ["Male", "Female", "Other"],
                          onChanged: (value) {},
                        ),
                        CustomMultiSelectDropdown(
                          onSelect: (selectedValues) {
                            interests.assignAll(selectedValues);
                          },
                          controller: intrestController,
                          hintText: "Your Interests",
                          items: const [
                            "Games",
                            "Music",
                            "Movies",
                            "Art",
                            "Technology",
                            "Innovation",
                            "Networking",
                          ],
                        ),
                        CustomTextField(
                          controller: nationalityController,
                          hintText: "Your Nationality",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: martialController,
                          hintText: "Your Marital Status",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: aboutmeController,
                          hintText: "About me",
                          obscureText: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                color: const Color.fromARGB(255, 250, 244, 228),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 250, 244, 228),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await updateProfileHandler(context);

                        if (result != null) {
                          updatedData = result;
                          if (context.mounted) {
                            Get.back();
                            showSuccessSnackbar("Profile Updated Suceesfully");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      ),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 250, 244, 228),
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
    );
  }

 Future<Map<String, dynamic>?> updateProfileHandler(BuildContext context) async {
  try {
    final authService = AuthService();

    // Fetch current user data to merge unedited fields
    final currentUserData = await authService.getUserInfo();

    // Maintain existing interests if they haven't been changed
    final updatedInterests = interests.isEmpty
        ? (currentUserData['interests'] as List<dynamic>)
            .map((e) => e.toString().trim())
            .toList()
        : interests;

    // Call the update profile method with merged data
    final updatedData = await authService.updateProfile(
      name: nameController.text.isNotEmpty
          ? nameController.text
          : currentUserData['name'],
      phone: phoneController.text.isNotEmpty
          ? phoneController.text
          : currentUserData['phone'],
      location: locationController.text.isNotEmpty
          ? locationController.text
          : currentUserData['location'],
      image: selectedImage.value,
      nationality: nationalityController.text.isNotEmpty
          ? nationalityController.text
          : currentUserData['nationality'],
      gender: genderController.text.isNotEmpty
          ? genderController.text
          : currentUserData['gender'],
      dob: dateofbirthController.text.isNotEmpty
          ? dateofbirthController.text
          : currentUserData['dob'],
      aboutMe: aboutmeController.text.isNotEmpty
          ? aboutmeController.text
          : currentUserData['about_me'],
      maritalStatus: martialController.text.isNotEmpty
          ? martialController.text
          : currentUserData['marital_status'],
      interests: updatedInterests,
      profession: profrssionController.text.isNotEmpty
          ? profrssionController.text
          : currentUserData['profession'],
    );

    if (updatedData.isNotEmpty) {
      return updatedData;
    }

    showSuccessSnackbar("Profile Updated Successfully");
  } catch (e) {
    showErrorSnackbar(e.toString());
  }
  return null;
}
}