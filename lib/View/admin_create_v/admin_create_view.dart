import 'package:aiarchs/app_routes/App_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Utils/app_colors/app_colors.dart';
import '../../view_model/admin_create_c/admin_create_controller.dart';
import '../admin_update_v/admin_update_view.dart';
import '../../Utils/Text_form_wgt/text_form_field_wgt.dart';

class AdminCreateView extends StatefulWidget {
  const AdminCreateView({super.key});

  @override
  State<AdminCreateView> createState() => _AdminCreateViewState();
}

class _AdminCreateViewState extends State<AdminCreateView> {
  int selectedTab = 0; // 0 = Create, 1 = Update

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ✅ AppBar same as AdminListView
      appBar: AppBar(
        title: const Text(
          "Admin Management",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt), // your icon here
            color: Colors.white, // <-- white color for the icon

            tooltip: "View All Admins",
            onPressed: () {
              // Navigate to Admin List screen using GetX
              Get.toNamed(AppRoutes.adminList);
            },
          ),
        ],
      ),


      body: Column(
        children: [
          const SizedBox(height: 16),

          // ✅ Custom Tab Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectedTab = 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 160,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedTab == 0 ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add,
                          color: selectedTab == 0 ? AppColors.primary : Colors.white),
                      const SizedBox(height: 4),
                      Text(
                        "Create",
                        style: TextStyle(
                          color: selectedTab == 0 ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => selectedTab = 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 160,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedTab == 1 ? Colors.white : AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit,
                          color: selectedTab == 1 ? AppColors.primary : Colors.white),
                      const SizedBox(height: 4),
                      Text(
                        "Update",
                        style: TextStyle(
                          color: selectedTab == 1 ? AppColors.primary : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ✅ Tab Content
          Expanded(
            child: IndexedStack(
              index: selectedTab,
              children: const [
                _CreateAdminTab(),
                AdminUpdateView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🔹 Create Admin Tab (same as before)
class _CreateAdminTab extends GetView<AdminController> {
  const _CreateAdminTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
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
                  maxline: 1,
                  hinttext: "Password",
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
                        color: Colors.white)
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

