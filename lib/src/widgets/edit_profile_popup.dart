
import 'dart:io';
import 'package:arab_socials/src/controllers/navigation_controller.dart';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/widgets/date_time_picker.dart';
import 'package:arab_socials/src/widgets/snack_bar_widget.dart';
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
  final TextEditingController aboutmeController = TextEditingController();
  final TextEditingController intrestController = TextEditingController();
    final NavigationController navigationController = Get.put(NavigationController());

  final RxList<String> interests = RxList();
  Rx<File?> selectedImage = Rx<File?>(null);

  Map<String, dynamic> updatedData = {};

  Future<void> showPopUp(BuildContext context) async {
    // Fetch the user profile data and populate the fields
    await _fetchUserProfile();

    await Get.dialog(
      barrierColor: const Color.fromARGB(255, 250, 244, 228),
      
      Material(
        color: const Color.fromARGB(255, 250, 244, 228),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                               Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: const Color.fromARGB(255, 35, 94, 77),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                        // Profile Image
                        Obx(() =>
                        GestureDetector(
  onTap: () async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  },
  child: Container(
    height: 200, // Fixed height for the container
    width: double.infinity, // Full width of the parent
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey), // Border style
      borderRadius: BorderRadius.circular(12), // Rounded corners
      image: selectedImage.value != null
          ? DecorationImage(
              image: FileImage(selectedImage.value!),
              fit: BoxFit.cover, // Cover the entire container
            )
          : (updatedData['image'] != null
              ? DecorationImage(
                  image: NetworkImage(updatedData['image']),
                  fit: BoxFit.cover,
                )
              : null),
    ),
    child: selectedImage.value == null && updatedData['image'] == null
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                size: 40,
                color: Color.fromARGB(255, 35, 94, 77),
              ),
              SizedBox(height: 10),
              Text(
                "Upload your image",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        : null,
  ),
),

                            ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: nameController,
                          hintText: "Enter your name",
                          labelText: "Your Name",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: phoneController,
                          hintText: "Enter your phone",
                          labelText: "Phone Number",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: locationController,
                          hintText: "Enter your location",
                          labelText: "Your location",
                          obscureText: false,
                        ),
                        DatePickerFieldWidget(
                          controller: dateofbirthController,
                          hintText: "Your Date of Birth",
                          
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: profrssionController,
                          hintText: "Your Profession",
                          labelText: "Your Profession",
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
                          labelText: "Your Nationality",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: martialController,
                          hintText: "Your Marital Status",
                          labelText: "Martial Status",
                          obscureText: false,
                        ),
                        CustomTextField(
                          controller: aboutmeController,
                          hintText: "About me",
                          labelText: "About Me",
                          obscureText: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                color: const Color.fromARGB(255, 250, 244, 228),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 250, 244, 228),
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
                            showSuccessSnackbar("Profile Updated Successfully");
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 250, 244, 228),
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

  Future<void> _fetchUserProfile() async {
    try {
      final authService = AuthService();
      final profileData = await authService.getUserInfo();
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
    try {
      final authService = AuthService();

      final currentUserData = await authService.getUserInfo();

      final updatedInterests = interests.isEmpty
          ? (currentUserData['interests'] as List<dynamic>).map((e) => e.toString()).toList()
          : interests;

      final updatedData = await authService.updateProfile(
        name: nameController.text.isNotEmpty ? nameController.text : currentUserData['name'],
        phone: phoneController.text.isNotEmpty ? phoneController.text : currentUserData['phone'],
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
