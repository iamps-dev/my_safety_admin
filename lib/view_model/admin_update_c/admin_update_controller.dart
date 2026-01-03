// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import '../../Repo/Login/auth_repository.dart';
// import '../../Utils/snackbar/AppSnackBar.dart';
//
// class AdminUpdateController extends GetxController {
//   final AuthRepository _repo = AuthRepository();
//   final GetStorage _box = GetStorage();
//
//   // Controllers
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passwordCtrl = TextEditingController();
//
//   // State
//   final RxBool isLoading = false.obs;
//   final RxBool isPasswordHidden = true.obs;
//
//   // Admin list and selection
//   final RxList<Map<String, dynamic>> admins = <Map<String, dynamic>>[].obs;
//   final RxInt selectedAdminId = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkSuperAdmin();
//     fetchAdmins();
//   }
//
//   /// 🔐 Super Admin check
//   void _checkSuperAdmin() {
//     final role = _box.read("role");
//     if (role != "SUPER_ADMIN") {
//       AppSnackBar.showError("Access denied! Only SUPER_ADMIN can access.");
//       Get.back();
//     }
//   }
//
//   Future<void> fetchAdmins() async {
//     try {
//       final response = await _repo.getAllAdmins();
//
//       // ✅ extract list safely
//       final List adminsList = response['data'] ?? [];
//
//       if (adminsList.isNotEmpty) {
//         admins.assignAll(
//           adminsList
//               .map<Map<String, dynamic>>(
//                   (e) => Map<String, dynamic>.from(e))
//               .toList(),
//         );
//       } else {
//         AppSnackBar.showError("No admins found");
//       }
//     } catch (e) {
//       print("Error fetching admins: $e");
//       AppSnackBar.showError("Failed to load admins");
//     }
//   }
//
//
//   /// 🔹 Select admin from dropdown
//   void selectAdmin(Map<String, dynamic> admin) {
//     selectedAdminId.value = admin['id'];
//     emailCtrl.text = admin['email'];
//     passwordCtrl.clear();
//   }
//
//   /// 🔹 Toggle password visibility
//   void togglePassword() {
//     isPasswordHidden.value = !isPasswordHidden.value;
//   }
//
//   /// 🔹 Update admin API
//   Future<void> updateAdmin() async {
//     if (selectedAdminId.value == 0) {
//       AppSnackBar.showError("Please select an admin");
//       return;
//     }
//
//     if (passwordCtrl.text.isEmpty) {
//       AppSnackBar.showError("Password is required");
//       return;
//     }
//
//     try {
//       isLoading.value = true;
//
//       final response = await _repo.updateAdmin({
//         "adminId": selectedAdminId.value,
//         "newEmail": emailCtrl.text.trim(),
//         "newPassword": passwordCtrl.text.trim(),
//       });
//
//       if (isClosed) return; // ✅ IMPORTANT SAFETY CHECK
//
//       if (response['success'] == true) {
//         AppSnackBar.showSuccess(response['message']);
//
//         /// Close keyboard safely
//         FocusManager.instance.primaryFocus?.unfocus();
//
//         await Future.delayed(const Duration(milliseconds: 100));
//
//         if (isClosed) return; // ✅ CHECK AGAIN
//
//         /// Reset state
//         selectedAdminId.value = 0;
//         emailCtrl.clear();
//         passwordCtrl.clear();
//       } else {
//         AppSnackBar.showError(
//           response['message'] ?? "Failed to update admin",
//         );
//       }
//     } catch (e) {
//       if (!isClosed) {
//         AppSnackBar.showError(e.toString());
//       }
//     } finally {
//       if (!isClosed) {
//         isLoading.value = false;
//       }
//     }
//   }
//
//   @override
//   void onClose() {
//     emailCtrl.dispose();
//     passwordCtrl.dispose();
//     super.onClose();
//   }
// }
