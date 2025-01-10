import 'dart:io';
import 'package:arab_socials/src/services/auth_services.dart';
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
  void updateProfileHandler(BuildContext context) async {
    final authService = AuthService();

    try {
      final response = await authService.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        location: locationController.text.trim(),
        martialStatus: martialController.text.trim(),
        interests: intrestController.text.trim(),
        profession: profrssionController.text.trim(),
        socialLinks: null, 
        image: selectedImage.value,
      );

      print('Profile updated successfully: $response');
      print("emailis done 😀😀🤣${nameController.text}");
      print("emailis done 😀😀🤣${phoneController.text}");
      print("emailis done 😀😀🤣${locationController.text}");
      print("emailis done 😀😀🤣${martialController.text}");
      print("emailis done 😀😀🤣${intrestController.text}");
      print("emailis done 😀😀🤣${profrssionController.text}");

      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile: $e');

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
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

                DatePickerFieldWidget(controller: dateofbirthController, hintText: "Your Date of Birth"),
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
                  items: const [
                    "Male",
                    "Female",
                    "Divorced",
                  ],
                  onChanged: (value) {
                    print("Selected Gender: $value");
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
                  hintText: "Your Martial status",
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
                      onPressed: () => updateProfileHandler(context),
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
