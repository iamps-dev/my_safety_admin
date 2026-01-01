import 'package:get/get.dart';
import '../../view_model/admin_update_c/admin_update_controller.dart';

class AdminUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminUpdateController());
  }
}
