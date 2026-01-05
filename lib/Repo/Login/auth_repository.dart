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

  // 🔹 Update Admin API (PUT)
  Future<Map<String, dynamic>> updateAdmin(Map<String, dynamic> body) {
    return ApiClient.put("${AppUrl.adminAuth}/update", body: body);
  }

  // 🔹 Get all Admins API (List)
// 🔹 Get all Admins API
// 🔹 Get all Admins API
  Future<Map<String, dynamic>> getAllAdmins() async {
    return await ApiClient.get("${AppUrl.adminAuth}/all");
  }
// 🔄 Update Admin Status (Activate / Deactivate)
  Future<Map<String, dynamic>> updateAdminStatus(Map<String, dynamic> body) {
    return ApiClient.put("${AppUrl.adminAuth}/status", body: body);
  }


}
