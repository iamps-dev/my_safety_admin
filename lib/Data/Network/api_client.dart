import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../Appurl/app_url.dart';

class ApiClient {
  static final _storage = GetStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppUrl.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read("jwt_token");

        if (token != null && token.isNotEmpty) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          clearToken();
          // Get.offAllNamed('/login');
        }
        return handler.next(error);
      },
    ),
  );

  // 🔐 Save token
  static void saveToken(String token) {
    _storage.write("jwt_token", token);
  }

  // 🔓 Clear token
  static void clearToken() {
    _storage.remove("jwt_token");
  }

  // 🔵 POST
  static Future<Map<String, dynamic>> post(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.post(url, data: body);
      return response.data;
    } on DioException catch (e) {
      print(e);
      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message'] ?? "Server error"
            : "Server error",
      );
    }
  }

  // 🟢 GET
  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await dio.get(url);
      return response.data;
    } on DioException catch (e) {
      print("+++++++++++++++++");
      print(e);
      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message'] ?? "Server error"
            : "Server error",
      );
    }
  }

  // 🟡 PATCH
  static Future<Map<String, dynamic>> patch(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.patch(url, data: body);
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message'] ?? "Server error"
            : "Server error",
      );
    }
  }

  // 🔴 PUT (✅ ADDED)
  static Future<Map<String, dynamic>> put(
      String url, {
        Map<String, dynamic>? body,
      }) async {
    try {
      final response = await dio.put(url, data: body);
      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data is Map
            ? e.response?.data['message'] ?? "Server error"
            : "Server error",
      );
    }
  }
}
