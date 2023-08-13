import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Berhasil",
            "Kami telah mengirimkan email reset password. periksa email anda.");
      } catch (e) {
        Get.snackbar(
            "terjadi Kesalahan", "tidak dapat mengirim email reset password.");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
