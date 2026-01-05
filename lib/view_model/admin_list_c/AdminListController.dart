import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> admins = <Map<String, dynamic>>[].obs;

  // Track per-row toggle loading
  final RxMap<int, bool> rowLoading = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdmins();
  }

  /// Fetch all admins from API
  Future<void> fetchAdmins() async {
    try {
      isLoading.value = true;

      final response = await _repo.getAllAdmins();
      print("Fetch admins response: $response");

      if (response['data'] != null && response['data'] is List) {
        // Normalize is_active → isActive for Flutter UI
        admins.value = List<Map<String, dynamic>>.from(response['data']).map((admin) {
          admin['isActive'] = admin['is_active'] ?? 0;
          return admin;
        }).toList();
      } else {
        admins.clear();
      }

      if (admins.isEmpty) {
        AppSnackBar.showError("No admins found");
      }
    } catch (e) {
      AppSnackBar.showError("Failed to fetch admins: $e");
      print("Fetch admins error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle admin Active / Inactive
  Future<void> toggleAdminStatus(int adminId, bool is_active) async {
    try {
      print("=== toggleAdminStatus called ===");
      print("Admin ID: $adminId, New Status: $is_active");

      rowLoading[adminId] = true;

      final body = {"adminId": adminId, "active": is_active};
      print("Request body: $body");

      final response = await _repo.updateAdminStatus(body);
      print("API response: $response");

      if (response['success'] == true) {
        AppSnackBar.showSuccess(response['message']);

        int index = admins.indexWhere((e) => e['id'] == adminId);
        print("Admin index in list: $index");

        if (index != -1) {
          // 🔹 Replace the map object to trigger Obx
          final updatedAdmin = Map<String, dynamic>.from(admins[index]);
          updatedAdmin['isActive'] = is_active ? 1 : 0;
          admins[index] = updatedAdmin;
          print("Updated admin: ${admins[index]}");
        }
      } else {
        AppSnackBar.showError(response['message']);
      }
    } catch (e) {
      AppSnackBar.showError("Failed to update admin status: $e");
      print("Error caught in toggleAdminStatus: $e");
    } finally {
      rowLoading[adminId] = false;
      print("rowLoading for $adminId = false");
    }
  }

  /// Format date → dd-MM-yyyy
  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  /// Format date & time → dd-MM-yyyy hh:mm a
  String formatDateTime(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }
}
