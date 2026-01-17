import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../app_routes/App_routes.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import 'dart:async';

class AdminDashboardController extends GetxController {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  Timer? _logoutTimer;

  @override
  void onInit() {
    super.onInit();
    _checkTokenAndScheduleLogout();
  }

  /// 🔹 Check JWT token and schedule auto logout
  Future<void> _checkTokenAndScheduleLogout() async {
    // ✅ Use the new key ".jt" for JWT token
    final token = await _secureStorage.read(key: ".jt");

    if (token == null || JwtDecoder.isExpired(token)) {
      logout();
      return;
    }

    // Token is valid → schedule auto logout when it expires
    final expiryDate = JwtDecoder.getExpirationDate(token);
    final durationUntilExpiry = expiryDate.difference(DateTime.now());

    _logoutTimer?.cancel(); // cancel previous timer if any
    _logoutTimer = Timer(durationUntilExpiry, () {
      logout();
    });
  }

  /// 🔹 Logout
  Future<void> logout() async {
    _logoutTimer?.cancel();

    // ✅ Delete both JWT token and user payload
    await _secureStorage.delete(key: ".jt"); // JWT token
    await _secureStorage.delete(key: ".ut"); // decoded payload

    AppSnackBar.showError("Session expired. Please login again.");
    Get.offAllNamed(AppRoutes.INITIAL); // navigate to login
  }

  @override
  void onClose() {
    _logoutTimer?.cancel();
    super.onClose();
  }
}
