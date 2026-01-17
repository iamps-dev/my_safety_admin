import 'package:get/get.dart';
import '../../Repo/Login/auth_repository.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminListController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // Loading indicators
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> admins = <Map<String, dynamic>>[].obs;
  final RxMap<int, bool> rowLoading = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdmins();
  }

  // =======================
  // Fetch all admins
  // =======================
  Future<void> fetchAdmins() async {
    try {
      isLoading.value = true;

      final response = await _repo.getAllAdmins();
      print(response);

      if (response['admins'] != null && response['admins'] is List) {
        admins.assignAll(
          List<Map<String, dynamic>>.from(response['admins']).map((admin) {
            // Normalize active status to 'isActive'
            if (admin['isActive'] != null) {
              admin['isActive'] = admin['isActive'] == true || admin['isActive'] == 1;
            } else if (admin['active'] != null) {
              admin['isActive'] = admin['active'] == true || admin['active'] == 1;
            } else {
              admin['isActive'] = true; // default if missing
            }

            return admin;
          }).toList(),
        );

      } else {
        admins.clear();
        AppSnackBar.showError("No admins found");
      }
    } catch (e) {
      AppSnackBar.showError("Failed to load admins: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =======================
  // Toggle admin status
  // =======================
  Future<void> toggleAdminStatus(int adminId, bool active) async {
    try {
      rowLoading[adminId] = true;

      final response = await _repo.updateAdminStatus({
        "adminId": adminId,
        "active": active,
      });
      print(response);

      if (response['success'] == true) {
        final index = admins.indexWhere((e) => e['id'] == adminId);
        if (index != -1) {
          final updatedAdmin = Map<String, dynamic>.from(admins[index]);
          updatedAdmin['isActive'] = active;
          admins[index] = updatedAdmin; // triggers UI update
        }
        AppSnackBar.showSuccess(response['message']);
      } else {
        AppSnackBar.showError(response['message'] ?? "Failed to update status");
      }
    } catch (e) {
      AppSnackBar.showError("Status update failed: $e");
    } finally {
      rowLoading[adminId] = false;
    }
  }

  // =======================
  // Optional: Format Date
  // =======================
  String formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day}-${dt.month}-${dt.year}";
    } catch (_) {
      return dateStr;
    }
  }

  String formatDateTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day}-${dt.month}-${dt.year} ${dt.hour}:${dt.minute}";
    } catch (_) {
      return dateStr;
    }
  }
}
