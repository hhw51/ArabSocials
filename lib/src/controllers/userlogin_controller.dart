import 'dart:developer';
import 'package:arabsocials/src/services/auth_services.dart';
import 'package:arabsocials/src/view/auth/splash_steps/stepscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nav.dart';

class SignUpController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  final Rx<Map<String, dynamic>> userData = Rx<Map<String, dynamic>>({});
  final RxString authToken = ''.obs;

  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
         _authService.setToken(response?['token']);

      // _authService.setToken(tocken)
      showSuccessSnackbar('Logged in successfully!');
      Get.offAll(() => BottomNav());
    } catch (e) {
      print('Login error: $e');
      // showErrorSnackbar(e.toString());
    } finally {
      isLoading(false);
    }
  }
 
Future<void> setLoginState()async{
      String? token=          await _authService.getToken();
log('token $token');
      // Future.delayed(Duration(seconds: 3),(){
 if(token!=null){
          Get.offAll(() => BottomNav());

      }else{
        Get.to(() => Stepscreen());

      }
      // });
     

}

  void showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<Map<String, dynamic>> signUp(
      String name,
      String email,
      String password,
      String account_type,
      String phone,
      ) async {
    try {
      isLoading(true);
      final response = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        account_type: account_type,
        phone: phone,
      );

      print("📬 [signUp] Response: $response");

      if (response['user'] != null && response['token'] != null) {
        // Store user data and token
        userData.value = response['user'];
        authToken.value = response['token'];

        // Save token to secure storage
         _authService.setToken(response['token']);
// splash sy aggay jaa he nhi rhii
        return {
          'data': response,
          'user': response['user'],
          'token': response['token']
        };
      } else if (response.containsKey('error')) {
        return {'status': 'error', 'error': response['error']};
      } else {
        return {'status': 'error', 'error': 'Invalid response format'};
      }
    } catch (e) {
      print('🚫 [signUp] Error: $e');
      return {'status': 'error', 'error': e.toString()};
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

      print("📬 [verifyOtp] Response: $response");

      if (response['detail'] == 'Authentication successful') {
        return {'status': 'success', 'detail': 'Authentication successful'};
      } else {
        return {
          'status': 'error',
          'error': response['error'] ?? 'Verification Failed'
        };
      }
    } catch (e) {
      print('🚫 [verifyOtp] Error: $e');
      return {'status': 'error', 'error': e.toString()};
    } finally {
      isLoading(false);
    }
  }
}