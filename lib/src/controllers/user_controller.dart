import 'dart:io';
import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  // Text controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController maritalController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController interestController = TextEditingController();

  // Reactive state variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxList<String> interests = RxList();
  final RxBool isLoading = false.obs;

  final AuthService _authService = AuthService();
  Map<String, dynamic> updatedData = {};

  Future<void> fetchUserInfo() async {
    try {
      isLoading.value = true;

      final userInfo = await _authService.getUserInfo();
      updatedData = userInfo;

      nameController.text = userInfo['name'] ?? '';
      phoneController.text = userInfo['phone'] ?? '';
      locationController.text = userInfo['location'] ?? '';
      dateofbirthController.text = userInfo['dob'] ?? '';
      genderController.text = userInfo['gender'] ?? '';
      nationalityController.text = userInfo['nationality'] ?? '';
      maritalController.text = userInfo['marital_status'] ?? '';
      professionController.text = userInfo['profession'] ?? '';
      aboutMeController.text = userInfo['about_me'] ?? '';

      // Assign interests
      if (userInfo['interests'] != null && userInfo['interests'] is List) {
        interests.assignAll(
          (userInfo['interests'] as List).map((e) => e.toString().trim()).toList(),
        );
      } else {
        interests.clear();
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update profile handler
  Future<void> updateProfile(BuildContext context) async {
    try {
      isLoading.value = true;

      // Maintain existing interests if they haven't been changed
      final currentUserData = await _authService.getUserInfo();
      final updatedInterests = interests.isEmpty
          ? (currentUserData['interests'] as List<dynamic>)
              .map((e) => e.toString().trim())
              .toList()
          : interests;

      // Update profile data
      final updatedData = await _authService.updateProfile(
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
        aboutMe: aboutMeController.text.isNotEmpty
            ? aboutMeController.text
            : currentUserData['about_me'],
        maritalStatus: maritalController.text.isNotEmpty
            ? maritalController.text
            : currentUserData['marital_status'],
        interests: updatedInterests,
        profession: professionController.text.isNotEmpty
            ? professionController.text
            : currentUserData['profession'],
      );

      if (updatedData.isNotEmpty) {
        this.updatedData = updatedData;
       showSuccessSnackbar('Profile updated successfully');
      }
    } catch (e) {
     showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Handle image selection
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
}
