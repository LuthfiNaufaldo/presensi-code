import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailMahasiswaController extends GetxController {
  RxBool isLoadingUpdate = false.obs;
  RxBool isLoadingDelete = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editPresensi(Map<String, dynamic> data) async {
    try {
      await firestore.collection("presensi").doc(data["id"]).update({
        "name": data["name"],
        "code": data["npm"],
        "kelas": data["kelas"],
        "hari": data["hari"],
        "matkul": data["matkul"],
        "keterangan": data["keterangan"],
      });
      return {
        "error": false,
        "message": "Berhasil update presensi.",
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak dapat update presensi.",
      };
    }
  }

  Future<Map<String, dynamic>> deletePresensi(String id) async {
    try {
      await firestore.collection("presensi").doc(id).delete();
      return {
        "error": false,
        "message": "Berhasil delete presensi.",
      };
    } catch (e) {
      // error general
      return {
        "error": true,
        "message": "Tidak dapat delete presensi.",
      };
    }
  }
}
