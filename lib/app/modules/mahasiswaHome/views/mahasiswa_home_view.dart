import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/controllers/presensi_controller.dart';

import '../controllers/mahasiswa_home_controller.dart';

class MahasiswaHomeView extends GetView<MahasiswaHomeController> {
  final PresensiController presensiController = Get.put(PresensiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda Mahasiswa'),
      ),
      body: Center(
        child: Obx(() {
          // Tampilkan pesan notifikasi status presensi jika berhasil terdeteksi
          // Misalnya, "Presensi: Hadir", "Presensi: Terlambat", dll.
          return Text(presensiController.isPresensiDetected.value
              ? presensiController.isPresensiValid.value
                  ? "Presensi: Hadir"
                  : "Presensi: Terlambat"
              : "Presensi: Belum Terdeteksi");
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Jalankan aksi untuk mendeteksi QR Code
          presensiController.detectPresensi();
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
