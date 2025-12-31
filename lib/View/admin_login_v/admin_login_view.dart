import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';
import '../../view_model/admin_login_c/admin_login_controller.dart';

class AdminLoginView extends GetView<AdminLoginController> {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

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
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // 📧 Email
                TextFormFieldWgt(
                  hinttext: "Admin Email",
                  controller: controller.emailCtrl,
                  prxicon: Icons.email,
                  inptype: TextInputType.emailAddress,
                  autofocus: true,
                ),

                const SizedBox(height: 16),

                // 🔑 Password
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

                // 🔘 Login Button
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.loginAdmin,
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
                      "LOGIN",
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
