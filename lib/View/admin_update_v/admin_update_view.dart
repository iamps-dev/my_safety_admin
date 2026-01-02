import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/SearchableDropdown/SearchableDropdown.dart';
import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';
import '../../Utils/app_colors/app_colors.dart';
import '../../view_model/admin_update_c/admin_update_controller.dart';

class AdminUpdateView extends GetView<AdminUpdateController> {
  const AdminUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Update Admin",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// 🔹 FIXED BODY (NO OVERFLOW)
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                      "Update Admin (SuperAdmin Only)",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    /// 🔹 ADMIN DROPDOWN
                    DropdownWithSearch(
                      hintText: "Select Admin",
                      items: controller.admins,
                      selectedId: controller.selectedAdminId,
                      onSelect: controller.selectAdmin,
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 EMAIL FIELD
                    TextFormFieldWgt(
                      hinttext: "Email",
                      controller: controller.emailCtrl,
                      prxicon: Icons.email,
                      inptype: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    /// 🔹 PASSWORD FIELD
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

                    /// 🔹 UPDATE BUTTON
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
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          "UPDATE ADMIN",
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
        ),
      ),
    );
  }
}
