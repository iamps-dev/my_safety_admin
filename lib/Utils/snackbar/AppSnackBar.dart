import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackBar {

  static showSuccess(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,

      // 🔽 reduce height
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      borderRadius: 8,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    );
  }

  static showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,

      // 🔽 reduce height
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      borderRadius: 8,
      isDismissible: true,
      duration: const Duration(seconds: 2),
    );
  }
}
