import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/auth/otpverify/otp_screen.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;

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
      Get.to(() => OtpVerifyScreen());
    } catch (e) {
      print('Signup error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
