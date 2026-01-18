import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../Appurl/app_url.dart';
import '../../app_routes/App_routes.dart';

class ApiClient {
  static final FlutterSecureStorage _secureStorage =
  const FlutterSecureStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      // ✅ FIXED
      validateStatus: (status) => status != null && status < 400,
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      // 🔐 Attach JWT token
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: "jwt_token");
        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options);
      },

      // 🚪 Auto logout
      onResponse: (response, handler) async {
        if (response.statusCode == 401 || response.statusCode == 403) {
          await clearToken();
          Get.offAllNamed(AppRoutes.adminLogin);
        }
        handler.next(response);
      },

      onError: (DioException e, handler) {
        handler.reject(e);
      },
    ),
  );

  // ================= TOKEN =================

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: "jwt_token", value: token);
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: "jwt_token");
  }

  // ================= ERROR HANDLER =================

  static Map<String, dynamic> _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError) {
      return {
        "success": false,
        "message": "Server not reachable. Please try again later"
      };
    }

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return {
        "success": false,
        "message": "Connection timeout. Check your internet"
      };
    }

    if (e.response != null) {
      return {
        "success": false,
        "message":
        e.response?.data?["message"] ?? "Server error occurred"
      };
    }

    return {
      "success": false,
      "message": "Unexpected error occurred"
    };
  }

  // ================= REQUESTS =================

  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await dio.get(url);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  static Future<Map<String, dynamic>> post(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.post(url, data: body);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  static Future<Map<String, dynamic>> put(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.put(url, data: body);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }

  static Future<Map<String, dynamic>> patch(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.patch(url, data: body);
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      return _handleDioError(e);
    }
  }
}
