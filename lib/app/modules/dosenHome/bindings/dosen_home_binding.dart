import 'package:get/get.dart';

import '../controllers/dosen_home_controller.dart';

class DosenHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DosenHomeController>(
      () => DosenHomeController(),
    );
  }
}
