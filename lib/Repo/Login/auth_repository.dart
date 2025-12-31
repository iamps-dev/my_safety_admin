import '../../Data/Appurl/app_url.dart';
import '../../Data/Network/api_client.dart';

class AuthRepository {
  // 🔹 Login API
  Future<Map<String, dynamic>> adminLogin(Map<String, dynamic> body) {
    return ApiClient.post("${AppUrl.adminAuth}/login", body: body);
  }

  // 🔹 Create Admin API
  Future<Map<String, dynamic>> createAdmin(Map<String, dynamic> body) {
    return ApiClient.post("${AppUrl.adminAuth}/create", body: body);
  }

  // 🔹 Update Admin API
  Future<Map<String, dynamic>> updateAdmin(Map<String, dynamic> body) {
    return ApiClient.post("${AppUrl.adminAuth}/update", body: body);
  }

  // 🔹 Get all Admins API
  Future<Map<String, dynamic>> getAllAdmins() {
    return ApiClient.get("${AppUrl.adminAuth}/list");
  }
}
