  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import '../../Utils/app_colors/app_colors.dart';
  import '../../view_model/admin_list_c/AdminListController.dart';
  import '../../Utils/snackbar/AppSnackBar.dart';

  class AdminListView extends GetView<AdminListController> {
    const AdminListView({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text(
            "All Admins",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: AppColors.primary,
          centerTitle: true,
          elevation: 2,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.admins.isEmpty) {
            return const Center(
              child: Text(
                "No admins found.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: controller.admins.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final admin = controller.admins[index];

              return Card(
                color: Colors.white,
                elevation: 3,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Index Circle
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Admin Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              admin['email'] ?? "",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                _infoItem(
                                  icon: Icons.person_outline,
                                  text: admin['role'] ?? '',
                                ),
                                _infoItem(
                                  icon: Icons.calendar_today,
                                  text:
                                  "Created: ${controller.formatDateTime(admin['createdAt'] ?? '')}",
                                ),
                                _infoItem(
                                  icon: Icons.vpn_key_outlined,
                                  text:
                                  "Password Version: ${admin['passwordVersion'] ?? admin['password_version'] ?? 0}",
                                ),
                                if ((admin['createdAt'] ?? '') !=
                                    (admin['passwordChangedAt'] ??
                                        admin['password_changed_at'] ??
                                        ''))
                                  _infoItem(
                                    icon: Icons.lock_outline,
                                    text:
                                    "Password changed: ${controller.formatDateTime(admin['passwordChangedAt'] ?? admin['password_changed_at'] ?? '')}",
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // 🔄 Active / Inactive Switch with row loading
                      Obx(() {
                        final loading =
                            controller.rowLoading[admin['id']] == true;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Switch(
                              value: (admin['isActive'] ?? false) == true,
                              onChanged: loading
                                  ? null
                                  : (val) {
                                if (admin['role'] == 'SUPER_ADMIN') {
                                  AppSnackBar.showError(
                                      "Cannot change SuperAdmin status");
                                  return;
                                }
                                controller.toggleAdminStatus(
                                    admin['id'], val);
                              },
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.red,
                            ),
                            if (loading)
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      );
    }

    Widget _infoItem({required IconData icon, required String text}) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      );
    }
  }
