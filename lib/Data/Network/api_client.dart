import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Appurl/app_url.dart';

class ApiClient {
  // 🔐 Secure Storage instance
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      // 🔹 Attach token automatically
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: ".jt");

        if (token != null && token.isNotEmpty) {
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
  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: "jwt_token", value: token);
  }

  /// 🔓 Remove JWT
  static Future<void> clearToken() async {
    await _secureStorage.delete(key: "jwt_token");
  }

  // ================= REQUESTS =================

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
