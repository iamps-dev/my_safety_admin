import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final GetStorage _box = GetStorage();

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
    fetchAdmins(); // 🔥 auto refresh on screen open
  }

  /// 🔐 Super Admin check
  void _checkSuperAdmin() {
    final role = _box.read("role");
    if (role != "SUPER_ADMIN") {
      AppSnackBar.showError("Access denied! Only SUPER_ADMIN can access.");
      Get.back();
    }
  }

  // =======================
  // Fetch Admins
// =======================
  Future<void> fetchAdmins() async {
    try {
      final response = await _repo.getAllAdmins();
      print(response);

      final List list = response['admins'] ?? [];

      admins.assignAll(
        list.map<Map<String, dynamic>>(
              (e) => Map<String, dynamic>.from(e),
        ).toList(),
      );
    } catch (e) {
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

        // 🔥 refresh admin list after create
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
  // Select Admin (for update)
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

        // 🔥 refresh admin list after update
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
  // UI helpers
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
