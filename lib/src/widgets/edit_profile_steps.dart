import 'dart:io';
import 'package:arabsocials/src/controllers/edit_profile_controller.dart';
import 'package:arabsocials/src/controllers/navigation_controller.dart';
import 'package:arabsocials/src/widgets/custom_elevated_button.dart';
import 'package:arabsocials/src/widgets/date_time_picker.dart';
import 'package:arabsocials/src/widgets/snack_bar_widget.dart';
import 'package:arabsocials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_services.dart';

mixin ShowEditProfileDialog {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController martialController = TextEditingController();
  final TextEditingController profrssionController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();
  final TextEditingController intrestController = TextEditingController();
  final NavigationController navigationController = Get.put(NavigationController());

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final RxList<String> interests = RxList();
  Rx<File?> selectedImage = Rx<File?>(null);

  Map<String, dynamic> updatedData = {};

  Future<void> showEditProfilePopup(BuildContext context, Function refreshCallback) async {
    final EditProfileController controller = Get.put(EditProfileController());

    // Ensure the popup always starts from Step 1
    controller.currentStep.value = 0;

    await controller.fetchUserProfile();

    await Get.dialog(
      Material(
        color: const Color.fromARGB(255, 250, 244, 228),
        child: Obx(
              () => SafeArea(
            child: Column(
              children: [
                // Linear Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: LinearProgressIndicator(
                    value: (controller.currentStep.value + 1) / 3,
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color.fromARGB(255, 35, 94, 77),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Step Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Step 1: Image Upload
                          if (controller.currentStep.value == 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Your Photo",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 35, 94, 77),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "Regulations require you to upload your image. Don't worry, your data will stay safe and private.",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  GestureDetector(
                                    onTap: () async {
                                      final picker = ImagePicker();
                                      final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (pickedFile != null) {
                                        controller.selectedImage.value =
                                            File(pickedFile.path);
                                      }
                                    },
                                    child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 35, 94, 77),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        image: controller.selectedImage.value != null
                                            ? DecorationImage(
                                          image: FileImage(controller.selectedImage.value!),
                                          fit: BoxFit.cover,
                                        )
                                            : null,
                                      ),
                                      child: controller.selectedImage.value == null
                                          ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.insert_photo,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "Select Image",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[500],
                                          thickness: 1.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                                        child: Text(
                                          "or",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey[500],
                                          thickness: 1.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () async {
                                        final picker = ImagePicker();
                                        final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera,
                                        );
                                        if (pickedFile != null) {
                                          controller.selectedImage.value =
                                              File(pickedFile.path);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Open Camera & Take Photo",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // Step 2: Basic Information
                          if (controller.currentStep.value == 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Your Personal Details",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 35, 94, 77),
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  CustomTextField(
                                    controller: controller.nameController,
                                    hintText: "Enter your name",
                                    labelText: "Your Name",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: controller.phoneController,
                                    hintText: "Enter your phone number",
                                    labelText: "Phone Number",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: controller.locationController,
                                    hintText: "Enter your location",
                                    labelText: "Location",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: controller.nationalityController,
                                    hintText: "Enter your nationality",
                                    labelText: "Nationality",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomDropdown(
                                    controller: controller.genderController,
                                    hintText: "Your Gender",
                                    items: const ["Male", "Female", "Other"],
                                    onChanged: (value) {},
                                  ),
                                ],
                              ),
                            ),
                          // Step 3: Additional Information
                          if (controller.currentStep.value == 2)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Upload Your Personal Details",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 35, 94, 77),
                                    ),),
                                  SizedBox(height: 30.h),
                                  CustomTextField(
                                    controller: controller.profrssionController,
                                    hintText: "Your Profession",
                                    labelText: "Profession",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomTextField(
                                    controller: controller.martialController,
                                    hintText: "Marital Status",
                                    labelText: "Marital Status",
                                    obscureText: false,
                                  ),
                                  SizedBox(height: 10.h),
                                  CustomMultiSelectDropdown(
                                    onSelect: (selectedValues) {
                                      controller.interests.assignAll(selectedValues);
                                    },
                                    controller: controller.intrestController,
                                    hintText: "Your Interests",
                                    items: const [
                                      "Games",
                                      "Music",
                                      "Movies",
                                      "Art",
                                      "Technology",
                                      "Networking",
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  DatePickerFieldWidget(
                                    controller: controller.dateofbirthController,
                                    hintText: "Date of Birth",
                                  ),
                                  SizedBox(height: 20.h),
                                  CustomTextField(
                                    controller: controller.aboutmeController,
                                    hintText: "About Me",
                                    labelText: "About Me",
                                    obscureText: false,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  color: const Color.fromARGB(255, 250, 244, 228),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                        text: "Back",
                        onPressed: () {
                          if (controller.currentStep.value == 0) {
                            Get.back(); // Navigate to Profile Screen
                          } else {
                            controller.previousStep();
                          }
                        },
                      ),
                      CustomElevatedButton(
                        text: (controller.currentStep.value == 2 ? "Save" : "Next"),
                        onPressed: () async {
                          if (controller.currentStep.value < 2) {
                            controller.nextStep();
                          } else {
                            Get.dialog(
                              Center(child: CircularProgressIndicator()),
                              barrierDismissible: false,
                            );

                            final result = await updateProfileHandler(context);
                            // Close spinner
                            Get.back();
                            if (result != null) {
                              Get.back();
                              refreshCallback();
                              showSuccessSnackbar("Profile Updated Successfully");
                            } else {
                              showErrorSnackbar("Failed to update profile");
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<void> _fetchUserProfile() async {
    try {
      final authService = AuthService();
      String? token = await getToken();
      final profileData = await authService.getUserInfo(token: token!);
      print("profile dataa👌👌😒👌👌$profileData");
      updatedData = profileData;
      // Prepopulate fields
      nameController.text = profileData['name'] ?? '';
      phoneController.text = profileData['phone'] ?? '';
      locationController.text = profileData['location'] ?? '';
      dateofbirthController.text = profileData['dob'] ?? '';
      genderController.text = profileData['gender'] ?? '';
      nationalityController.text = profileData['nationality'] ?? '';
      martialController.text = profileData['marital_status'] ?? '';
      profrssionController.text = profileData['profession'] ?? '';
      aboutmeController.text = profileData['about_me'] ?? '';

      if (profileData['interests'] != null) {
        interests.assignAll(
          (profileData['interests'] as List).map((e) => e.toString()).toList(),
        );
      } else {
        interests.clear();
      }
    } catch (e) {
      showErrorSnackbar("Failed to fetch user profile: $e");
    }
  }

  Future<Map<String, dynamic>?> updateProfileHandler(BuildContext context) async {
    final controller = Get.find<EditProfileController>();

    try {
      final authService = AuthService();
      String? token = await getToken();
      final currentUserData = await authService.getUserInfo(token: token!);

      final updatedInterests = interests.isEmpty
          ? (currentUserData['interests'] as List<dynamic>).map((e) => e.toString()).toList()
          : interests;


      final updatedData = await authService.updateProfile(

        name:controller. nameController.text.isNotEmpty ?controller. nameController.text : currentUserData['name'],
        phone:controller. phoneController.text.isNotEmpty ?controller. phoneController.text : currentUserData['phone'],
        location:controller. locationController.text.isNotEmpty
            ? controller.locationController.text
            : currentUserData['location'],
        image:controller. selectedImage.value,
        nationality: controller.nationalityController.text.isNotEmpty
            ?controller. nationalityController.text
            : currentUserData['nationality'],
        gender:controller. genderController.text.isNotEmpty
            ?controller. genderController.text
            : currentUserData['gender'],
        dob: controller.dateofbirthController.text.isNotEmpty
            ? controller.dateofbirthController.text
            : currentUserData['dob'],
        aboutMe: controller.aboutmeController.text.isNotEmpty
            ? controller.aboutmeController.text
            : currentUserData['about_me'],
        maritalStatus:controller. martialController.text.isNotEmpty
            ?controller. martialController.text
            : currentUserData['marital_status'],
        interests: controller.interests.isNotEmpty?controller.interests:updatedInterests,
        profession: controller.profrssionController.text.isNotEmpty
            ? controller.profrssionController.text
            : currentUserData['profession'], token: token,
      );

      if (updatedData.isNotEmpty) {
        print("Data updated: $updatedData");
        return updatedData;
      }

      showSuccessSnackbar("Profile Updated Successfully");
    } catch (e) {
      showErrorSnackbar(e.toString());
    }
    return null;
  }
}