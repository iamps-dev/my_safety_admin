import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import '../../app_routes/App_routes.dart';
import '../../Data/Network/api_client.dart';

class AdminLoginController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final FlutterSecureStorage _storage =
  const FlutterSecureStorage();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void clearForm() {
    emailCtrl.clear();
    passwordCtrl.clear();
    isPasswordHidden.value = true;
  }

  Future<void> loginAdmin() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.showError("Email & Password required");
      return;
    }

    isLoading.value = true;

    final response = await _repo.adminLogin({
      "email": email,
      "password": password,
    });

    isLoading.value = false;

    // ❌ API / Network error
    if (response["success"] != true) {
      AppSnackBar.showError(response["message"] ?? "Login failed");
      return;
    }

    final String token = response["data"];

    // 🔐 Save JWT
    await ApiClient.saveToken(token);

    // ⏱ Expiry check (safety)
    if (JwtDecoder.isExpired(token)) {
      AppSnackBar.showError("Session expired");
      await ApiClient.clearToken();
      return;
    }

    clearForm();
    AppSnackBar.showSuccess(response["message"]);
    Get.offAllNamed(AppRoutes.adminDashboard);
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
