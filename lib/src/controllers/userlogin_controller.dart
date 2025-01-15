import 'package:arab_socials/src/services/auth_services.dart';
import 'package:arab_socials/src/view/auth/otpverify/otp_screen.dart';
import 'package:arab_socials/src/widgets/snack_bar_widget.dart';
import 'package:get/get.dart';
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
      showSuccessSnackbar('Logged in successfully!');
      Get.offAll(() => BottomNav());
    } catch (e) {
      print('Login error: $e');
      showErrorSnackbar(e.toString());
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
       showSuccessSnackbar('Account created successfully!');
      // Navigate to OTP screen or another page if needed
      Get.to(() => OtpVerifyScreen(email: email));
    } catch (e) {
      print('Signup error: $e');
      showErrorSnackbar(e.toString());
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
        Get.to(() => const BottomNav());
        return response;
        // Return success response
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
}
