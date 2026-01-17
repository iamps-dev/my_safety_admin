import '../../Data/Appurl/app_url.dart';
import '../../Data/Network/api_client.dart';

class AuthRepository {

  // 🔹 Admin Login
  Future<Map<String, dynamic>> adminLogin(Map<String, dynamic> body) {
    return ApiClient.post("${AppUrl.adminAuth}/login", body: body);
  }

  // 🔹 Create Admin
  Future<Map<String, dynamic>> createAdmin(Map<String, dynamic> body) {
    return ApiClient.post("${AppUrl.adminAuth}/create", body: body);
  }

  // 🔹 Update Admin
  Future<Map<String, dynamic>> updateAdmin(Map<String, dynamic> body) {
    return ApiClient.put("${AppUrl.adminAuth}/update", body: body);
  }

  // 🔹 Get All Admins
  Future<Map<String, dynamic>> getAllAdmins() {
    return ApiClient.get("${AppUrl.adminAuth}/all");
  }

  // 🔹 Activate / Deactivate Admin
  Future<Map<String, dynamic>> updateAdminStatus(Map<String, dynamic> body) {
    return ApiClient.put("${AppUrl.adminAuth}/status", body: body);
  }
}
