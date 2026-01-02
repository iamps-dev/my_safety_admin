import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';
import '../../Utils/app_colors/app_colors.dart';
import '../../app_routes/App_routes.dart';
import '../../view_model/admin_create_c/admin_create_controller.dart';
import '../amdin_list_v/AdminListView.dart';

class AdminCreateView extends GetView<AdminCreateController> {
  const AdminCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔹 APP BAR WITH BACK ARROW AND LIST ICON
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Create Admin",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          // 🔹 Only visible to SuperAdmin
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            tooltip: "View All Admins",
            onPressed: () {
              // Navigate using route name, so binding is applied
              Get.toNamed(AppRoutes.adminList);
            },
          ),

        ],
      ),

      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 12),

                const Text(
                  "Create Admin (SuperAdmin Only)",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                TextFormFieldWgt(
                  hinttext: "Admin Email",
                  controller: controller.emailCtrl,
                  prxicon: Icons.email,
                  inptype: TextInputType.emailAddress,
                  autofocus: true,
                ),

                const SizedBox(height: 16),

                Obx(() => TextFormFieldWgt(
                  hinttext: "Password",
                  maxline: 1,
                  controller: controller.passwordCtrl,
                  prxicon: Icons.lock,
                  obstxt: controller.isPasswordHidden.value,
                  sfxicon: controller.isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  onSficonTap: controller.togglePassword,
                )),

                const SizedBox(height: 24),

                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.createAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "CREATE ADMIN",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
