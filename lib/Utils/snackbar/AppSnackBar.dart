import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackBar {

  static void showSuccess(String message) {
    Future.microtask(() {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          "Success",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: 8,
          isDismissible: true,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }

  static void showError(String message) {
    Future.microtask(() {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          "Error",
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          borderRadius: 8,
          isDismissible: true,
          duration: const Duration(seconds: 2),
        );
      }
    });
  }
}
