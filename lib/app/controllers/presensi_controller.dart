import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../firebase_service.dart';
import '../../models.dart';

class PresensiController extends GetxController {
  final Rx<Jadwal?> jadwal = Rx<Jadwal?>(null);
  final RxBool isPresensiDetected = RxBool(false);
  final RxBool isPresensiValid = RxBool(false);

  final FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String get textFieldValue => textFieldController.text;
  TextEditingController textFieldController = TextEditingController();

  void setJadwalKuliah(DateTime jadwal, String mataKuliah, String ruang) async {
    try {
      String uid = auth.currentUser!.uid;

      CollectionReference<Map<String, dynamic>> colJadwalKuliah = firestore
          .collection("Mahasiswa")
          .doc(uid)
          .collection("jadwal_kuliah");

      String jadwalDocID = DateFormat.yMd().format(jadwal).replaceAll("/", "-");

      // Menyimpan jadwal kuliah ke dalam database
      await colJadwalKuliah.doc(jadwalDocID).set({
        "tanggal": jadwal.toIso8601String(),
        "mata_kuliah": mataKuliah,
        "ruang": ruang,
      });

      Get.snackbar("Berhasil", "Jadwal kuliah berhasil diatur");
    } catch (error) {
      print("Gagal mengatur jadwal kuliah: $error");
      Get.snackbar("Error", "Terjadi kesalahan saat mengatur jadwal kuliah");
    }
  }

  Future<List<Jadwal>> getJadwalFromFirebase() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<Jadwal> jadwalList = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("Mahasiswa")
          .doc(uid)
          .collection("jadwal_kuliah")
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        Jadwal jadwal = Jadwal(
          kodeMataKuliah: data['kode_mata_kuliah'],
          jam: data['jam'],
          hari: data['hari'],
        );
        jadwalList.add(jadwal);
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    return jadwalList;
  }

  Mahasiswa? currentUser;

  Future<void> login(String email, String password) async {
    // Panggil metode signInWithEmailAndPassword dari FirebaseService
    final user =
        await firebaseService.signInWithEmailAndPassword(email, password);
    // Jika user berhasil login, simpan informasi user ke dalam variabel currentUser
    if (user != null) {
      currentUser =
          Mahasiswa(nim: user.email!, nama: user.displayName!, password: '');
    }

    void setJadwal(Jadwal? newJadwal) {
      jadwal.value = newJadwal;
    }
  }

  void detectPresensi() {
    // Implementasi deteksi presensi dari QR Code di sini
    // ...

    // Misalkan kita memiliki variabel bool yang menandakan apakah QR Code berhasil terdeteksi
    bool qrCodeDetected =
        true; // Ganti nilainya dengan deteksi QR Code yang sesuai

    // Misalkan kita memiliki variabel bool yang menandakan apakah presensi valid berdasarkan jam mulai dan selesai kelas
    bool presensiValid = true; // Ganti nilainya dengan validasi yang sesuai

    // Jika berhasil terdeteksi dan valid, simpan data presensi ke Firebase
    if (qrCodeDetected && presensiValid && currentUser != null) {
      // Simpan data presensi ke Firebase
      firebaseService.savePresensi(currentUser!.nim, 'hadir');
    }
  }

  setJadwal(Jadwal newJadwal) {}
}
