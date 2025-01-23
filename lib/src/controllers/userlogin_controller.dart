import 'dart:developer';

import 'package:arabsocials/src/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../apis/google_signin.dart';
import '../view/auth/splash_steps/stepscreen.dart';
import '../widgets/bottom_nav.dart';

class SignUpController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      _authService.getToken();

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

  Future<void> signInWithGoogle() async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Clear any previous sign-in
      await googleSignIn.signOut();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        Get.back();
        Get.snackbar('Info', 'Sign in was cancelled');
        return;
      }

      print('Google Sign In successful for user: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print('Got Google auth tokens');

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      print('Firebase sign in successful for user: ${userCredential.user?.email}');

      // Send the user email and UID to your API
      final String email = userCredential.user?.email ?? '';
      final String uid = userCredential.user?.uid ?? '';

      try {
        final response = await GoogleSigninService().googleSignIn(uid, email);
        print('API response: $response');

        // Optionally handle additional actions based on the response
      } catch (e) {
        print('Error sending data to API: $e');
        Get.snackbar('API Error', 'Failed to communicate with the server');
        // Depending on your app logic, you might choose to sign out the user here
        // await _firebaseAuth.signOut();
        // return;
      }

      // Dismiss loading indicator
      Get.back();

      // Navigate to home screen
      Get.offAll(() => const BottomNav());
      Get.snackbar(
          'Success',
          'Logged in successfully as ${userCredential.user?.email}'
      );

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      Get.back();
      Get.snackbar('Auth Error', e.message ?? 'Firebase authentication failed');

    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      Get.back();
      Get.snackbar('Platform Error', e.message ?? 'Platform error occurred');

    } catch (e) {
      print('Unexpected error: $e');
      Get.back();
      Get.snackbar('Error', 'Error: $e');
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
        await _authService.getToken();

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

