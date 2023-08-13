import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AddPresensiController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addPresensi(Map<String, dynamic> data) async {
    try {
      var hasil = await firestore.collection("presensi").add(data);
      await firestore.collection("presensi").doc(hasil.id).update({
        "presensiId": hasil.id,
      });
      return {
        "error": false,
        "message": "Berhasil menambah presensi.",
      };
    } catch (e) {
      // error general
      return {
        "error": true,
        "message": "Tidak dapat menambah presensi.",
      };
    }
  }
}
