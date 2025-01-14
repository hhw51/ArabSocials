import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/auth/otpverify/otp_screen.dart';
import 'package:get/get.dart';

import '../view/homepage/homescreen.dart';
import '../widgets/bottom_nav.dart';

class SignUpController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      print("Login successful: $response");
      Get.snackbar('Success', 'Logged in successfully!');

      // Once logged in, navigate to home screen
      Get.offAll(() => BottomNav());
    } catch (e) {
      print('Login error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
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
        throw Exception(response['body']['error'] ?? 'Sign-Up Failed'); // Throw an error for non-200 status
      }
    } catch (e) {
      print('Signup error: $e');
      rethrow; // Re-throw the error to be handled in the UI
    } finally {
      isLoading(false);
    }
  }


  Future<void> sendOtp(String email) async {
    try {
      isLoading.value = true;
      final response = await _authService.sendOtp(email: email);
      // You can parse/handle 'response' if needed
      print("Send OTP Response: $response");
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

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
        throw Exception(response['body']['error'] ?? 'Sign-Up Failed'); // Throw an error for non-200 status
      }
    } catch (e) {
      print('Signup error: $e');
      rethrow; // Re-throw the error to be handled in the UI
    } finally {
      isLoading(false);
    }
  }
}
