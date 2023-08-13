import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/data/models/presensi_models.dart';
// ignore: unused_import
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/detail_mahasiswa_controller.dart';

class DetailMahasiswaView extends GetView<DetailMahasiswaController> {
  final PresensiModel presensi = Get.arguments;
  final TextEditingController noC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController npmC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController hariC = TextEditingController();
  final TextEditingController matkulC = TextEditingController();
  final TextEditingController ketC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameC.text = presensi.name;
    npmC.text = presensi.npm;
    kelasC.text = presensi.kelas;
    hariC.text = presensi.hari;
    matkulC.text = presensi.matkul;
    ketC.text = presensi.keterangan;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Mahasiswa'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data:
                      "${presensi.npm}\n${presensi.kelas}\n${presensi.matkul}\n${presensi.hari}",
                  size: 200.0,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: nameC,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: npmC,
            keyboardType: TextInputType.number,
            maxLength: 12,
            decoration: InputDecoration(
              labelText: "NPM",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: kelasC,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: "Kelas",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: hariC,
            decoration: InputDecoration(
              labelText: "Hari",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: matkulC,
            decoration: InputDecoration(
              labelText: "Mata Kuliah",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: ketC,
            decoration: InputDecoration(
              labelText: "Keterangan",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoadingUpdate.isFalse) {
                if (nameC.text.isNotEmpty &&
                    npmC.text.isNotEmpty &&
                    kelasC.text.isNotEmpty &&
                    hariC.text.isNotEmpty &&
                    matkulC.text.isNotEmpty &&
                    ketC.text.isNotEmpty) {
                  // ignore: unused_local_variable

                  Map<String, dynamic> hasil = await controller.editPresensi({
                    "id": presensi.presensiId,
                    "name": nameC.text,
                    "code": npmC.text,
                    "kelas": kelasC.text,
                    "hari": hariC.text,
                    "matkul": matkulC.text,
                    "keterangan": ketC.text,
                  });
                  Get.back();
                  controller.isLoadingUpdate(false);
                  Get.snackbar(
                    hasil["error"] == true ? "Error" : "Berhasil",
                    hasil["message"],
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Semua Data Wajib Diisi.",
                    duration: const Duration(seconds: 2),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoadingUpdate.isFalse
                  ? "Update Presensi"
                  : "LOADING...."),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                  title: "Delete presensi",
                  middleText: "Apakah Kamu yakin hapus data presensi ?",
                  actions: [
                    OutlinedButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        controller.isLoadingDelete(true);
                        // ignore: unused_local_variable
                        Map<String, dynamic> hasil = await controller
                            .deletePresensi(presensi.presensiId);
                        controller.isLoadingDelete(false);

                        Get.back(); // tutup dialog
                        Get.back(); // balik ke page all presensi

                        Get.snackbar(
                          hasil["error"] == true ? "Error" : "Berhasil",
                          hasil["message"],
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Obx(
                        () => controller.isLoadingDelete.isFalse
                            ? const Text("Delete Presensi")
                            : Container(
                                padding: const EdgeInsets.all(2),
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                      ),
                    ),
                  ]);
            },
            child: Text(
              "Delete Presensi",
              style: TextStyle(
                color: Colors.red.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
