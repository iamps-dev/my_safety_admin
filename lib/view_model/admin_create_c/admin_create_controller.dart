import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import '../../app_routes/App_routes.dart';

class AdminController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // =======================
  // Controllers
  // =======================
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // =======================
  // State
  // =======================
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  // =======================
  // Admin List & Selection
  // =======================
  final RxList<Map<String, dynamic>> admins = <Map<String, dynamic>>[].obs;
  final RxInt selectedAdminId = 0.obs;

  // =======================
  // Lifecycle
  // =======================
  @override
  void onInit() {
    super.onInit();
    _checkSuperAdmin();
    fetchAdmins();
  }
  /// 🔐 SUPER ADMIN CHECK (SECURE)
  Future<void> _checkSuperAdmin() async {
    try {
      // ✅ Read JWT token directly (more secure than relying only on .ut)
      final token = await _secureStorage.read(key: "jwt_token");

      // ❌ No token or expired → deny access
      if (token == null || JwtDecoder.isExpired(token)) {
        _denyAccess();
        return;
      }

      // ✅ Decode token
      final payload = JwtDecoder.decode(token);

      // ❌ Check role
      final role = payload['role']?.toString().toUpperCase() ?? '';
      if (role != "SUPER_ADMIN") {
        _denyAccess();
        return;
      }

      // ✅ Optionally: also check sub/email exists
      final email = payload['sub'] ?? '';
      if (email.isEmpty) {
        _denyAccess();
        return;
      }

    } catch (e) {
      // ❌ Any error → deny access
      _denyAccess();
    }
  }

  void _denyAccess() {
    AppSnackBar.showError("Access denied! Only SUPER_ADMIN can access.");
    Get.offAllNamed(AppRoutes.adminLogin); // safer than Get.back()
  }


  // =======================
  // Fetch Admins
  // =======================
  Future<void> fetchAdmins() async {
    try {
      final response = await _repo.getAllAdmins();
      final List list = response['admins'] ?? [];

      admins.assignAll(
        list.map<Map<String, dynamic>>(
              (e) => Map<String, dynamic>.from(e),
        ).toList(),
      );
    } catch (e) {print(e);
      AppSnackBar.showError("Failed to load admins");
    }
  }

  // =======================
  // Create Admin
  // =======================
  Future<void> createAdmin() async {
    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppSnackBar.showError("Email & Password are required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.createAdmin({
        "email": emailCtrl.text.trim(),
        "password": passwordCtrl.text.trim(),
      });

      if (response['success'] == true) {
        AppSnackBar.showSuccess(response['message']);

        emailCtrl.clear();
        passwordCtrl.clear();
        fetchAdmins();
      } else {
        AppSnackBar.showError(response['message']);
      }
    } catch (e) {
      AppSnackBar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // Select Admin
  // =======================
  void selectAdmin(Map<String, dynamic> admin) {
    selectedAdminId.value = admin['id'];
    emailCtrl.text = admin['email'];
    passwordCtrl.clear();
  }

  // =======================
  // Update Admin
  // =======================
  Future<void> updateAdmin() async {
    if (selectedAdminId.value == 0) {
      AppSnackBar.showError("Please select an admin");
      return;
    }

    if (passwordCtrl.text.isEmpty) {
      AppSnackBar.showError("Password is required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.updateAdmin({
        "adminId": selectedAdminId.value,
        "newEmail": emailCtrl.text.trim(),
        "newPassword": passwordCtrl.text.trim(),
      });

      if (response['success'] == true) {
        AppSnackBar.showSuccess(response['message']);

        selectedAdminId.value = 0;
        emailCtrl.clear();
        passwordCtrl.clear();
        fetchAdmins();
      } else {
        AppSnackBar.showError(response['message']);
      }
    } catch (e) {
      AppSnackBar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // UI Helpers
  // =======================
  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }
}
