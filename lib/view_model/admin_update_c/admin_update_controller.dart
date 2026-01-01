import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminUpdateController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final GetStorage _box = GetStorage();

  // Controllers
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  // State
  final RxBool isLoading = false.obs;
  final RxBool isPasswordHidden = true.obs;

  final RxList admins = [].obs;
  final RxInt selectedAdminId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSuperAdmin();
    fetchAdmins();
  }

  /// 🔐 Super Admin check
  void _checkSuperAdmin() {
    final role = _box.read("role");
    if (role != "SUPER_ADMIN") {
      AppSnackBar.showError("Access denied!");
      Get.back();
    }
  }

  Future<void> fetchAdmins() async {
    try {
      final response = await _repo.getAllAdmins();

      if (response['success'] == true && response['data'] != null) {
        admins.assignAll(
          List<Map<String, dynamic>>.from(response['data']),
        );
      } else {
        AppSnackBar.showError("No admins found");
      }
    } catch (e) {
      AppSnackBar.showError("Failed to load admins");
    }
  }


  /// 🔹 Select admin from dropdown
  void selectAdmin(Map admin) {
    selectedAdminId.value = admin['id'];
    emailCtrl.text = admin['email'];
  }

  /// 🔹 Toggle password visibility
  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// 🔹 Update admin API
  Future<void> updateAdmin() async {
    if (selectedAdminId.value == 0) {
      AppSnackBar.showError("Please select an admin");
      return;
    }

    if (emailCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      AppSnackBar.showError("All fields required");
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
        passwordCtrl.clear();
      } else {
        AppSnackBar.showError(response['message']);
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
