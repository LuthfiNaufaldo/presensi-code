import 'package:get/get.dart';

import '../controllers/mahasiswa_home_controller.dart';

class MahasiswaHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MahasiswaHomeController>(
      () => MahasiswaHomeController(),
    );
  }
}
