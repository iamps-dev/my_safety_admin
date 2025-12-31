import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Data/Network/api_client.dart';
import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminCreateController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final GetStorage _box = GetStorage();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> createAdmin() async {
    final role = _box.read("role") ?? "";
    if (role != "SUPER_ADMIN") {
      AppSnackBar.showError("Only SuperAdmin can create admins!");
      return;
    }

    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.showError("Email & Password are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.createAdmin({
        "email": email,
        "password": password,
      });

      if (response['success'] == true) {
        AppSnackBar.showSuccess(response['message']);
        emailCtrl.clear();
        passwordCtrl.clear();
      } else {
        AppSnackBar.showError(response['message'] ?? "Failed to create admin");
      }
    } catch (e) {
      AppSnackBar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
