import 'package:get/get.dart';

import '../controllers/add_dosen_controller.dart';

class AddDosenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDosenController>(
      () => AddDosenController(),
    );
  }
}
