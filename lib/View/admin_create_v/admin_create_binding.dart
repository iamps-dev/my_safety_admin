import 'package:get/get.dart';
import '../../view_model/admin_create_c/admin_create_controller.dart';

class AdminCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminCreateController());
  }
}
