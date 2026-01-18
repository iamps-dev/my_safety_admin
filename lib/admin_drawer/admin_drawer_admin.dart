import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../app_routes/App_routes.dart';
import '../../Utils/snackbar/AppSnackBar.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({Key? key}) : super(key: key);

  final FlutterSecureStorage _secureStorage =
  const FlutterSecureStorage();

  /// 🔐 Get user data from JWT
  Future<Map<String, dynamic>> _getUserFromToken() async {
    final token = await _secureStorage.read(key: "jwt_token");
    if (token == null || JwtDecoder.isExpired(token)) return {};

    final decoded = JwtDecoder.decode(token);
    print("Decoded JWT: $decoded"); // check keys in console
    return decoded;
  }


  /// 🚪 LOGOUT
  Future<void> _logout() async {
    await _secureStorage.delete(key: "jwt_token");

    if (Get.isOverlaysOpen) Get.back();

    AppSnackBar.showSuccess("Admin logged out successfully");
    await Future.delayed(const Duration(milliseconds: 600));

    Get.offAllNamed(AppRoutes.adminLogin);
  }

  void _navigate(String route) {
    Get.back();
    Future.delayed(const Duration(milliseconds: 150), () {
      Get.toNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserFromToken(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {};
          final email = data["sub"] ?? "Unknown";
          final role = data["role"] ?? "ADMIN";


          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(role),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 40, color: Colors.blueAccent),
                ),
                decoration:
                const BoxDecoration(color: Colors.blueAccent),
              ),

              drawerItem("Dashboard", Icons.dashboard,
                      () => _navigate(AppRoutes.adminDashboard)),

              drawerItem("Users", Icons.people,
                      () => Get.snackbar("Info", "Coming soon")),

              drawerItem("Settings", Icons.settings,
                      () => Get.snackbar("Info", "Coming soon")),

              if (role == "SUPER_ADMIN")
                drawerItem(
                  "Create Admin",
                  Icons.admin_panel_settings,
                      () => _navigate(AppRoutes.adminCreate),
                ),

              const Divider(),
              drawerItem("Logout", Icons.logout, _logout),
            ],
          );
        },
      ),
    );
  }

  Widget drawerItem(
      String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
