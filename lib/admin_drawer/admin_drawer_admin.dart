import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../app_routes/App_routes.dart';
import '../Utils/snackbar/AppSnackBar.dart';

class AdminDrawer extends StatelessWidget {
  AdminDrawer({Key? key}) : super(key: key);

  final GetStorage _box = GetStorage();

  /// 🔴 LOGOUT FUNCTION
  void _logout() async {
    await _box.erase();

    if (Get.isOverlaysOpen) Get.back(); // close drawer if open

    AppSnackBar.showSuccess("Admin logged out successfully");

    await Future.delayed(const Duration(milliseconds: 800));
    Get.offAllNamed(AppRoutes.adminLogin); // go to login
  }

  /// 🔹 Common navigation handler (push to screen)
  void _navigate(String route) {
    Get.back(); // close drawer first
    Future.delayed(const Duration(milliseconds: 150), () {
      // ✅ Use Get.toNamed to keep dashboard in stack
      Get.toNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Read saved email & role from GetStorage
    final String email = _box.read("email") ?? "Unknown";
    final String role = _box.read("role") ?? "ADMIN";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 🔹 Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(role),
            accountEmail: Text(email),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blueAccent),
            ),
            decoration: const BoxDecoration(color: Colors.blueAccent),
          ),

          // 🔹 Drawer Items
          drawerItem("Dashboard", Icons.dashboard,
                  () => _navigate(AppRoutes.adminDashboard)),
          drawerItem("Users", Icons.people,
                  () => Get.snackbar("Info", "Users screen coming soon")),
          drawerItem("Settings", Icons.settings,
                  () => Get.snackbar("Info", "Settings screen coming soon")),
          drawerItem("Reports", Icons.bar_chart,
                  () => Get.snackbar("Info", "Reports screen coming soon")),

          // 🔹 SuperAdmin-only option
          if (role == "SUPER_ADMIN")
            drawerItem("Create Admin", Icons.admin_panel_settings,
                    () => _navigate(AppRoutes.adminCreate)),

          const Divider(),

          // 🔹 Logout
          drawerItem("Logout", Icons.logout, _logout),
        ],
      ),
    );
  }

  /// 🔹 Drawer Item Builder
  Widget drawerItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
