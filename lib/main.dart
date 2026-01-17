import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'app_routes/App_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage
  const secureStorage = FlutterSecureStorage();

  // Read saved JWT token (.jt)
  final savedToken = await secureStorage.read(key: ".jt");

  String initialRoute = AppRoutes.INITIAL; // default = login

  if (savedToken != null && savedToken.isNotEmpty) {
    if (!JwtDecoder.isExpired(savedToken)) {
      // Token is valid → go to dashboard
      initialRoute = AppRoutes.adminDashboard;
    } else {
      // Token expired → erase storage
      await secureStorage.delete(key: ".jt"); // delete token
      await secureStorage.delete(key: ".ut"); // delete payload
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Admin Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
