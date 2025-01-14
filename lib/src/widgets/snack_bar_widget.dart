import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Success Snackbar
void showSuccessSnackbar(String message) {
  Get.snackbar(
    "Success",
    message,
    backgroundColor: Colors.green,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
    mainButton: TextButton(
      onPressed: () {
        Get.closeAllSnackbars();
      },
      child: const Icon(
        Icons.close,
        size: 20,
      ),
    ),
  );
}
// Error Snackbar
void showErrorSnackbar(String message) {
  Get.snackbar(
    "Error",
    message,
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.TOP,
    duration: const Duration(seconds: 2),
    mainButton: TextButton(
      onPressed: () {
        Get.closeAllSnackbars();
      },
      child: const Icon(
        Icons.close,
        size: 20,
      ),
    ),
  );
}
