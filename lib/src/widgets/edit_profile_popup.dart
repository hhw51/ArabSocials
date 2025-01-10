import 'dart:io';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/profile/profilescreen.dart';
import 'package:arab_socials/src/widgets/date_time_picker.dart';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void showEditProfileDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController martialController = TextEditingController();
  final TextEditingController profrssionController = TextEditingController();
  final TextEditingController intrestController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();

  Rx<File?> selectedImage = Rx<File?>(null);

  void updateProfileHandler() async {
  try {
    final authService = AuthService();

    // Fetch current user data to merge unedited fields
    final currentUserData = await authService.getUserInfo();

    // Call the update profile method with merged data
    final updatedData = await authService.updateProfile(
      name: nameController.text.isNotEmpty ? nameController.text : currentUserData['name'],
      phone: phoneController.text.isNotEmpty ? phoneController.text : currentUserData['phone'],
      location: locationController.text.isNotEmpty ? locationController.text : currentUserData['location'],
      image: selectedImage.value,
      nationality: nationalityController.text.isNotEmpty ? nationalityController.text : currentUserData['nationality'],
      gender: genderController.text.isNotEmpty ? genderController.text : currentUserData['gender'],
      dob: dateofbirthController.text.isNotEmpty ? dateofbirthController.text : currentUserData['dob'],
      aboutMe: aboutmeController.text.isNotEmpty ? aboutmeController.text : currentUserData['about_me'],
      maritalStatus: martialController.text.isNotEmpty ? martialController.text : currentUserData['marital_status'],
      interests: intrestController.text.isNotEmpty ? intrestController.text : currentUserData['interests'],
      profession: profrssionController.text.isNotEmpty ? profrssionController.text : currentUserData['profession'],
    );

    // Use GlobalKey to update state
    final profileScreenState = Profilescreen.globalKey.currentState;

if (profileScreenState != null) {
  nameController.text = profileScreenState.name.value;
  phoneController.text = profileScreenState.phone.value;
  locationController.text = profileScreenState.location.value;
  dateofbirthController.text = profileScreenState.dob.value;
  genderController.text = profileScreenState.gender.value;
  nationalityController.text = profileScreenState.nationality.value;
  martialController.text = profileScreenState.maritalStatus.value;
  profrssionController.text = profileScreenState.profession.value;
  intrestController.text = profileScreenState.aboutMe.value;
  aboutmeController.text = profileScreenState.aboutMe.value;
}
    

    // Show success message
    Get.snackbar(
      "Success",
      "Profile updated successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );

    Navigator.pop(context); // Close the dialog
  } catch (e) {
    // Show error message
    Get.snackbar(
      "Error",
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}


  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        backgroundColor: const Color.fromARGB(255, 250, 244, 228),
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
                  onChanged: (value) {
                    // genderController.text = value;
                  },
                ),
                CustomMultiSelectDropdown(
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
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
                    // Save Button
                    ElevatedButton(
                      onPressed: updateProfileHandler,
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
              ],
            ),
          ),
        ),
      );
    },
  );
}
