import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import '../../app_routes/App_routes.dart';
import '../Utils/snackbar/AppSnackBar.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({Key? key}) : super(key: key);

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// 🔴 LOGOUT FUNCTION
  void _logout() async {
    await _secureStorage.delete(key: ".jt");
    await _secureStorage.delete(key: ".ut");


    if (Get.isOverlaysOpen) Get.back();

    AppSnackBar.showSuccess("Admin logged out successfully");

    await Future.delayed(const Duration(milliseconds: 800));
    Get.offAllNamed(AppRoutes.adminLogin);
  }

  /// 🔹 Common navigation handler
  void _navigate(String route) {
    Get.back();
    Future.delayed(const Duration(milliseconds: 150), () {
      Get.toNamed(route);
    });
  }
  Future<Map<String, dynamic>> _getUserPayload() async {
    final jsonStr = await _secureStorage.read(key: ".ut");
    if (jsonStr == null) return {};
    return Map<String, dynamic>.from(jsonDecode(jsonStr));
  }
  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _getUserPayload(),
        builder: (context, snapshot) {
          final data = snapshot.data ?? {};
          final email = data['sub'] ?? "Unknown";
          final role = data['role'] ?? "ADMIN";

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(role),
                accountEmail: Text(email),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
                ),
                decoration: const BoxDecoration(color: Colors.blueAccent),
              ),

              drawerItem("Dashboard", Icons.dashboard,
                      () => _navigate(AppRoutes.adminDashboard)),
              drawerItem("Users", Icons.people,
                      () => Get.snackbar("Info", "Users screen coming soon")),
              drawerItem("Settings", Icons.settings,
                      () => Get.snackbar("Info", "Settings screen coming soon")),
              drawerItem("Reports", Icons.bar_chart,
                      () => Get.snackbar("Info", "Reports screen coming soon")),

              if (role == "SUPER_ADMIN") ...[
                drawerItem(
                  "Create Admin",
                  Icons.admin_panel_settings,
                      () => _navigate(AppRoutes.adminCreate),
                ),
              ],

              const Divider(),

              drawerItem("Logout", Icons.logout, _logout),
            ],
          );
        },
      ),
    );
  }

  Widget drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
