import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/auth/otpverify/otp_screen.dart';
import 'package:get/get.dart';

import '../view/homepage/homescreen.dart';

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
      Get.offAll(() => Homescreen());
    } catch (e) {
      print('Login error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    isLoading(true);
    try {
      final response = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      print('Signup successful: $response');
      Get.snackbar('Success', 'Account created successfully!');
      // Navigate to OTP screen or another page if needed
      Get.to(() => OtpVerifyScreen(email: email));
    } catch (e) {
      print('Signup error: $e');
      Get.snackbar('Error', e.toString());
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

  Future<void> verifyOtp(String email, String otp) async {
    try {
      isLoading(true);
      final response = await _authService.verifyOtp(
        email: email,
        otp: otp,
      );
      print("Verify OTP Response: $response");

      // If the response is successful, handle next step, e.g.:
      Get.snackbar('Success', 'OTP Verified!');

      // Navigate to next screen, or do other logic
      Get.offAll(() => Homescreen());
    } catch (e) {
      print('Verify OTP error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
