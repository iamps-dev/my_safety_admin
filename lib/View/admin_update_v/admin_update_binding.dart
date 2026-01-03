import 'package:aiarchs/view_model/admin_create_c/admin_create_controller.dart';
import 'package:get/get.dart';
import '../../view_model/admin_update_c/admin_update_controller.dart';

class AdminUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminController());
  }
}
