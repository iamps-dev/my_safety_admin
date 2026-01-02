import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> admins = <Map<String, dynamic>>[].obs;

  /// Fetch all admins from API
  Future<void> fetchAdmins() async {
    try {
      isLoading.value = true;

      final response = await _repo.getAllAdmins(); // returns List<Map>

      // directly assign to admins
      admins.value = List<Map<String, dynamic>>.from(response);

      if (admins.isEmpty) {
        AppSnackBar.showError("No admins found");
      }

    } catch (e) {
      AppSnackBar.showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Format date to dd-MM-yyyy
  String formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAdmins();
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
