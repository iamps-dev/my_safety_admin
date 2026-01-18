import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../admin_drawer/admin_drawer_admin.dart';
import '../../view_model/admin_dashboard_c/AdminDashboardController.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({Key? key}) : super(key: key);

  final AdminDashboardController controller = Get.put(AdminDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      drawer: AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                final data = snapshot.data ?? {};
                final email = data["sub"] ?? "Unknown";
                final role = data["role"] ?? "ADMIN";

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome, $email!",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Role: $role",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dashboardCard("Users", Icons.person, () {}),
                dashboardCard("Settings", Icons.settings, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 150,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
