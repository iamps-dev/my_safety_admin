import 'package:get/get.dart';

import '../View/admin_dashboard_v/admin_dashboard_screen.dart';
import '../View/admin_login_v/admin_login_binding.dart';
import '../View/admin_login_v/admin_login_view.dart';
import '../View/admin_create_v/admin_create_view.dart';
import '../View/admin_create_v/admin_create_binding.dart';
import '../View/admin_update_v/admin_update_view.dart';
import '../View/admin_update_v/admin_update_binding.dart';
import '../View/amdin_list_v/AdminListBinding.dart';
import '../View/amdin_list_v/AdminListView.dart';

// ✅ New imports for Admin List



class AppRoutes {
  // 🔹 Route names
  static const String adminLogin = "/admin-login";
  static const String adminDashboard = "/admin-dashboard";
  static const String adminCreate = "/admin-create";
  static const String adminUpdate = "/admin-update";
  static const String adminList = "/admin-list"; // <-- NEW

  // 🔹 Initial route
  static const String INITIAL = adminLogin;

  // 🔹 GetX pages
  static final List<GetPage> pages = [
    GetPage(
      name: adminLogin,
      page: () => const AdminLoginView(),
      binding: AdminLoginBinding(),
    ),
    GetPage(
      name: adminDashboard,
      page: () => AdminDashboardScreen(),
    ),
    GetPage(
      name: adminCreate,
      page: () =>  AdminCreateView(),
      binding: AdminCreateBinding(),
    ),
    GetPage(
      name: adminUpdate,
      page: () => const AdminUpdateView(),
      binding: AdminUpdateBinding(),
    ),
    // ✅ Admin List page
    GetPage(
      name: AppRoutes.adminList,
      page: () => const AdminListView(),
      binding: AdminListBinding(), // inject controller here
    ),

  ];
}
