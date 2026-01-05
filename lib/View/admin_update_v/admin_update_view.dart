import 'package:aiarchs/view_model/admin_create_c/admin_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/SearchableDropdown/SearchableDropdown.dart';
import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';
import '../../view_model/admin_update_c/admin_update_controller.dart';

class AdminUpdateView extends GetView<AdminController> {
  const AdminUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Container(
              width: 380, // ✅ SAME WIDTH AS CREATE
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
                    "Update Admin (SuperAdmin Only)",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  /// Dropdown
                  DropdownWithSearch(
                    hintText: "Select Admin",
                    items: controller.admins,
                    selectedId: controller.selectedAdminId,
                    onSelect: controller.selectAdmin,
                  ),

                  const SizedBox(height: 16),

                  /// Email display
                  /// Editable Email
                  Obx(() {
                    if (controller.selectedAdminId.value == 0) {
                      return const SizedBox();
                    }

                    return TextFormFieldWgt(
                      hinttext: "Admin Email",
                      maxline: 1,
                      controller: controller.emailCtrl,
                      prxicon: Icons.email,
                    );
                  }),

                  const SizedBox(height: 16),

                  /// Password
                  Obx(() => TextFormFieldWgt(
                    hinttext: "New Password",
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

                  /// Button
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.updateAdmin,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "UPDATE ADMIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
