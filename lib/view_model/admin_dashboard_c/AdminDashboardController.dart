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

  Future<void> _checkTokenAndScheduleLogout() async {
    final token = await _secureStorage.read(key: "jwt_token");

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

  Future<void> logout() async {
    _logoutTimer?.cancel();
    await _secureStorage.delete(key: "jwt_token"); // clear token
    AppSnackBar.showError("Session expired. Please login again.");
    Get.offAllNamed(AppRoutes.INITIAL); // navigate to login
  }

  @override
  void onClose() {
    _logoutTimer?.cancel();
    super.onClose();
  }
}

