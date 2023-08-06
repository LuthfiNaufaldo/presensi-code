import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController npmC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController kelasC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController roleC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;
  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);

    update();
  }

  Future<void> updateProfile(String uid) async {
    if (npmC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        roleC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "Nama": nameC.text,
        };
        if (image != null) {
          File file = File(image!.path);

          String ext = image!.name.split(".").last;

          await storage.ref('$uid/Profile.$ext').putFile(file);

          String urlImage =
              await storage.ref('$uid/Profile.$ext').getDownloadURL();

          data.addAll({"Profile": urlImage});
        }

        await firestore.collection("Mahasiswa").doc(uid).update(data);
        image = null;
        Get.back();
        Get.snackbar("Berhasil", "Update Profile Sukses.");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat update Profile.");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection("Mahasiswa").doc(uid).update({
        "Profile": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Berhasil", "Hapus Foto Profile Sukses.");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Tidak dapat delete foto profile.");
    } finally {
      update();
    }
  }
}
