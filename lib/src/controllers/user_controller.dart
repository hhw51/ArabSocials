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

  // Reactive state variables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxList<String> interests = RxList();
  final RxBool isLoading = false.obs;

  final AuthService _authService = AuthService();
  Map<String, dynamic> updatedData = {};

  // Flag for first-time signup
  bool isFirstTimeSignup = true;

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

  // Validate all fields for the first-time signup
  bool validateAllFields() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dateofbirthController.text.isNotEmpty &&
        genderController.text.isNotEmpty &&
        nationalityController.text.isNotEmpty &&
        maritalController.text.isNotEmpty &&
        professionController.text.isNotEmpty &&
        aboutMeController.text.isNotEmpty &&
        interests.isNotEmpty;
  }

  // Update profile
  Future<void> updateProfile(BuildContext context) async {
    if (isFirstTimeSignup && !validateAllFields()) {
      showErrorSnackbar('All fields are required for first-time setup.');
      return;
    }

    try {
      isLoading.value = true;

      final updatedData = await _authService.updateProfile(
        name: nameController.text,
        phone: phoneController.text,
        location: locationController.text,
        image: selectedImage.value,
        nationality: nationalityController.text,
        gender: genderController.text,
        dob: dateofbirthController.text,
        aboutMe: aboutMeController.text,
        maritalStatus: maritalController.text,
        interests: interests,
        profession: professionController.text,
      );

      if (updatedData.isNotEmpty) {
        this.updatedData = updatedData;
        isFirstTimeSignup = false; // Mark first-time signup as complete
        showSuccessSnackbar('Profile updated successfully.');
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