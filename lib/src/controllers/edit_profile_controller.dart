import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/widgets/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

class EditProfileController extends GetxController {
  var currentStep = 0.obs;

  // Fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController profrssionController = TextEditingController();
  final TextEditingController martialController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();
  final TextEditingController intrestController = TextEditingController();

  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  final RxList<String> interests = RxList();
  Rx<File?> selectedImage = Rx<File?>(null);

  Map<String, dynamic> updatedData = {};

  // Navigation between steps
  void nextStep() {
    if (currentStep.value < 2) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  Future<void> fetchUserProfile() async {
    try {
      final authService = AuthService();
      String? token = await getToken();
      final profileData = await authService.getUserInfo(token: token!);

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

  Future<void> updateProfile(BuildContext context) async {
    try {
      final authService = AuthService();

      final updatedInterests = interests.isEmpty
          ? updatedData['interests'] ?? []
          : interests;
      String? token = await getToken();

      await authService.updateProfile(
        name: nameController.text,
        phone: phoneController.text,
        location: locationController.text,
        image: selectedImage.value,
        nationality: nationalityController.text,
        gender: genderController.text,
        dob: dateofbirthController.text,
        aboutMe: aboutmeController.text,
        maritalStatus: martialController.text,
        interests: updatedInterests,
        profession: profrssionController.text,
        token: token!,
      );

      showSuccessSnackbar("Profile Updated Successfully");
    } catch (e) {
      showErrorSnackbar("Failed to update profile: $e");
    }
  }
}