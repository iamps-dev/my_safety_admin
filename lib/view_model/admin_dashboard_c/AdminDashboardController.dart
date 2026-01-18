import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';

import '../../app_routes/App_routes.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminDashboardController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Timer? _logoutTimer;

  @override
  void onInit() {
    super.onInit();
    _checkTokenAndScheduleLogout();
  }

  /// ⏱ Check JWT token and schedule auto logout
  Future<void> _checkTokenAndScheduleLogout() async {
    final token = await _secureStorage.read(key: "jwt_token");

    if (token == null || JwtDecoder.isExpired(token)) {
      logout(showMessage: false);
      return;
    }

    final expiryDate = JwtDecoder.getExpirationDate(token);
    final duration = expiryDate.difference(DateTime.now());

    // Cancel previous timer
    _logoutTimer?.cancel();

    // Schedule logout when token expires
    _logoutTimer = Timer(duration, () {
      logout();
    });
  }

  /// 🚪 Logout function
  Future<void> logout({bool showMessage = true}) async {
    _logoutTimer?.cancel();

    await _secureStorage.delete(key: "jwt_token");
    await _secureStorage.delete(key: ".ut"); // delete payload if stored

    if (showMessage) {
      AppSnackBar.showError("Session expired. Please login again.");
    }

    Get.offAllNamed(AppRoutes.adminLogin);
  }

  /// 🔐 Get user payload from JWT
  Future<Map<String, dynamic>> getUserData() async {
    final token = await _secureStorage.read(key: "jwt_token");
    if (token == null || JwtDecoder.isExpired(token)) return {};
    return JwtDecoder.decode(token);
  }

  @override
  void onClose() {
    _logoutTimer?.cancel();
    super.onClose();
  }
}
