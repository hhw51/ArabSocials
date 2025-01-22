import 'dart:io';
import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/widgets/snack_bar_widget.dart';
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

  Future<void> fetchUserInfo(String token) async {
    try {
      isLoading.value = true;

      final userInfo = await _authService.getUserInfo(token: token);
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
          (userInfo['interests'] as List)
              .map((e) => e.toString().trim())
              .toList(),
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

    Future<Map<String, dynamic>> signUp(String name, String email,
        String password) async {
      isLoading(true);
      try {
        final response = await _authService.signUp(
          name: name,
          email: email,
          password: password,
        );

        final statusCode = response['statusCode'];
        if (statusCode == 200 || statusCode == 201) {
          print("Signup successful: $response");
          return response; // Return success response
        } else {
          print("Signup failed: ${response['body']}");
          throw Exception(response['body']['error'] ??
              'Sign-Up Failed'); // Throw an error for non-200 status
        }
      } catch (e) {
        print('Signup error: $e');
        rethrow; // Re-throw the error to be handled in the UI
      } finally {
        isLoading(false);
      }
    }


    Future<void> sendOtp(String email, String token) async {
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
          profession: professionController.text, token: token,
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

        Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
          try {
            isLoading(true);
            final response = await _authService.verifyOtp(
              email: email,
              otp: otp,
            );
            final statusCode = response['statusCode'];
            if (statusCode == 200 || statusCode == 201) {
              print("Signup successful: $response");
              return response; // Return success response
            } else {
              print("Signup failed: ${response['body']}");
              throw Exception(response['body']['error'] ??
                  'Sign-Up Failed'); // Throw an error for non-200 status
            }
          } catch (e) {
            print('Signup error: $e');
            rethrow; // Re-throw the error to be handled in the UI
          } finally {
            isLoading(false);
          }
        }
      };
    }
  }}