import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../Appurl/app_url.dart';

class ApiClient {
  static final GetStorage _storage = GetStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },

      // ✅ IMPORTANT: Allow backend to return 401 / 403
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      // 🔹 Attach token automatically
      onRequest: (options, handler) {
        final token = _storage.read("jwt_token");

        if (token != null && token.toString().isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },

      // 🔹 Handle auth errors globally
      onResponse: (response, handler) {
        if (response.statusCode == 401 || response.statusCode == 403) {
          clearToken(); // token expired / unauthorized
        }
        return handler.next(response);
      },

      // 🔹 Network / unexpected error
      onError: (error, handler) {
        return handler.next(error);
      },
    ),
  );

  // ================= TOKEN =================

  /// 🔐 Save JWT
  static void saveToken(String token) {
    _storage.write("jwt_token", token);
  }

  /// 🔓 Remove JWT
  static void clearToken() {
    _storage.remove("jwt_token");
  }

  // ================= REQUESTS =================

  /// 🟢 GET
  static Future<Map<String, dynamic>> get(String url) async {
    final response = await dio.get(url);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        response.data is Map
            ? response.data['message'] ?? "Unauthorized"
            : "Unauthorized",


      );
    }

    return Map<String, dynamic>.from(response.data);
  }

  /// 🔵 POST
  static Future<Map<String, dynamic>> post(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    final response = await dio.post(url, data: body);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        response.data is Map
            ? response.data['message'] ?? "Unauthorized"
            : "Unauthorized",
      );
    }

    return Map<String, dynamic>.from(response.data);
  }

  /// 🟡 PATCH
  static Future<Map<String, dynamic>> patch(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    final response = await dio.patch(url, data: body);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        response.data is Map
            ? response.data['message'] ?? "Unauthorized"
            : "Unauthorized",
      );
    }

    return Map<String, dynamic>.from(response.data);
  }

  /// 🔴 PUT
  static Future<Map<String, dynamic>> put(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    final response = await dio.put(url, data: body);

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception(
        response.data is Map
            ? response.data['message'] ?? "Unauthorized"
            : "Unauthorized",
      );
    }

    return Map<String, dynamic>.from(response.data);
  }
}
