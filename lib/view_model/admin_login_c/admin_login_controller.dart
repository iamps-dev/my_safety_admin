import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Data/Network/api_client.dart';
import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import '../../app_routes/App_routes.dart';
import 'dart:convert';

class AdminLoginController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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

      print(response);

      if (response['success'] == true) {
        final String token = response['data'];

        // ✅ Save JWT token with key ".jt"
        await _secureStorage.write(key: ".jt", value: token);

        // ✅ Decode payload
        final decoded = JwtDecoder.decode(token);
        decoded['login_time'] = DateTime.now().toIso8601String();

        // ✅ Save decoded payload with key ".ut"
        await _secureStorage.write(key: ".ut", value: jsonEncode(decoded));

        clearLoginForm();
        AppSnackBar.showSuccess(response['message']);
        Get.offAllNamed(AppRoutes.adminDashboard);
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
