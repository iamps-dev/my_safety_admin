import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../app_routes/App_routes.dart';
import '../../Utils/snackbar/AppSnackBar.dart';
import 'dart:async';

class AdminDashboardController extends GetxController {
  final GetStorage _box = GetStorage();
  Timer? _logoutTimer;

  @override
  void onInit() {
    super.onInit();
    _checkTokenAndScheduleLogout();
  }

  void _checkTokenAndScheduleLogout() {
    final token = _box.read("token") as String?;

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

  void logout() {
    _logoutTimer?.cancel();
    _box.erase(); // clear token & other data
    AppSnackBar.showError("Session expired. Please login again.");
    Get.offAllNamed(AppRoutes.INITIAL); // navigate to login
  }

  @override
  void onClose() {
    _logoutTimer?.cancel();
    super.onClose();
  }
}
