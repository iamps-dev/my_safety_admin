import 'package:get/get.dart';
import '../../view_model/admin_list_c/AdminListController.dart';

class AdminListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AdminListController());
  }
}
