import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Data/Network/api_client.dart';
import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import '../../app_routes/App_routes.dart';

class AdminLoginController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final GetStorage _box = GetStorage();

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void clearLoginForm() {
    emailCtrl.clear();
    passwordCtrl.clear();
    isPasswordHidden.value = true;
  }

  Future<void> loginAdmin() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.showError("Email & Password are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.adminLogin({
        "email": email,
        "password": password,
      });

      if (response['success'] == true) {
        print(response);
        final String token = response['data'];
        final Map<String, dynamic> decoded = JwtDecoder.decode(token);
        final String role = decoded['role'];
        final String emailFromToken = decoded['sub'];

        ApiClient.saveToken(token);
        _box.write("token", token);
        _box.write("role", role);
        _box.write("email", emailFromToken);

        clearLoginForm();
        AppSnackBar.showSuccess(response['message']);
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        AppSnackBar.showError(response['message'] ?? "Login failed");
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
