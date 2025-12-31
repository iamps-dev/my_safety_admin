import 'package:get/get.dart';

import '../../view_model/admin_login_c/admin_login_controller.dart';

class AdminLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminLoginController());
  }
}
