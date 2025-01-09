import 'dart:io';
import 'package:arab_socials/src/widgets/textfieled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void showEditProfileDialog(BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  Rx<File?> selectedImage = Rx<File?>(null);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Profile Image
                Obx(() => GestureDetector(
                      onTap: () async {
                       // Uncomment this and use ImagePicker to select an image
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

                // Name Field
                CustomTextField(
                  controller: nameController,
                  hintText: "Enter your name",
                  obscureText: false,
                ),

                // Phone Field
                CustomTextField(
                  controller: phoneController,
                  hintText: "Enter your phone",
                  obscureText: false,
                ),

                // Location Field
                CustomTextField(
                  controller: locationController,
                  hintText: "Enter your location",
                  obscureText: false,
                ),

                SizedBox(height: 24.h),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel Button
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text("Cancel"),
                    ),

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        // Save the updated details
                        print("Name: ${nameController.text}");
                        print("Phone: ${phoneController.text}");
                        print("Location: ${locationController.text}");
                        if (selectedImage.value != null) {
                          print("Image Path: ${selectedImage.value!.path}");
                        }
                        Navigator.pop(context); // Close the dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 35, 94, 77),
                      ),
                      child: const Text("Save"),
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
