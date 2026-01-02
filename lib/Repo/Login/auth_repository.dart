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
  Future<List<Map<String, dynamic>>> getAllAdmins() async {
    final response =
    await ApiClient.dio.get("${AppUrl.adminAuth}/all");

    // response.data is a MAP
    final Map<String, dynamic> body =
    Map<String, dynamic>.from(response.data);

    // extract LIST from "data"
    final List admins = body['data'] ?? [];

    return admins
        .map<Map<String, dynamic>>(
            (e) => Map<String, dynamic>.from(e))
        .toList();
  }

}
