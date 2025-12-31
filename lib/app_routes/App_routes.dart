import 'package:get/get.dart';

import '../View/admin_dashboard_v/admin_dashboard_screen.dart';
import '../View/admin_login_v/admin_login_binding.dart';
import '../View/admin_login_v/admin_login_view.dart';
import '../View/admin_create_v/admin_create_view.dart';
import '../View/admin_create_v/admin_create_binding.dart';

class AppRoutes {
  // 🔹 Route names
  static const String adminLogin = "/admin-login";
  static const String adminDashboard = "/admin-dashboard";
  static const String adminCreate = "/admin-create"; // New route

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
      // You can add a binding here if needed
    ),
    GetPage(
      name: adminCreate,
      page: () => const AdminCreateView(), // SuperAdmin-only screen
      binding: AdminCreateBinding(),
    ),
  ];
}
