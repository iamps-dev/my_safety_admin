import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';
import '../../Utils/app_colors/app_colors.dart';
import '../../view_model/admin_update_c/admin_update_controller.dart';

class AdminUpdateView extends GetView<AdminUpdateController> {
  const AdminUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Update Admin"),
        centerTitle: true,
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

                const Icon(Icons.edit, size: 60, color: Colors.deepPurple),
                const SizedBox(height: 12),

                const Text(
                  "Update Admin (SuperAdmin Only)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 24),

                /// 🔽 Admin Dropdown
                Obx(() => DropdownButtonFormField<Map<String, dynamic>>(
                  decoration: const InputDecoration(
                    labelText: "Select Admin",
                    border: OutlineInputBorder(),
                  ),
                  items: controller.admins.map<DropdownMenuItem<Map<String, dynamic>>>((admin) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: admin,
                      child: Text(admin['email'] ?? ''),
                    );
                  }).toList(),
                  onChanged: (Map<String, dynamic>? value) {
                    if (value != null) {
                      controller.selectAdmin(value);
                    }
                  },
                )),


                const SizedBox(height: 16),

                TextFormFieldWgt(
                  hinttext: "Admin Email",
                  controller: controller.emailCtrl,
                  prxicon: Icons.email,
                ),

                const SizedBox(height: 16),

                Obx(() => TextFormFieldWgt(
                  hinttext: "New Password",
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
                        : controller.updateAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "UPDATE ADMIN",
                      style: TextStyle(color: Colors.white),
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
