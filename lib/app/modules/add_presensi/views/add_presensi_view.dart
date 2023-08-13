import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_presensi_controller.dart';

class AddPresensiView extends GetView<AddPresensiController> {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController npmC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController hariC = TextEditingController();
  final TextEditingController matkulC = TextEditingController();
  final TextEditingController ketC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
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
              if (controller.isLoading.isFalse) {
                if (nameC.text.isNotEmpty &&
                    npmC.text.isNotEmpty &&
                    kelasC.text.isNotEmpty &&
                    hariC.text.isNotEmpty &&
                    matkulC.text.isNotEmpty &&
                    ketC.text.isNotEmpty) {
                  controller.isLoading(true);

                  Map<String, dynamic> hasil = await controller.addPresensi({
                    "name": nameC.text,
                    "code": npmC.text,
                    "kelas": kelasC.text,
                    "hari": hariC.text,
                    "matkul": matkulC.text,
                    "keterangan": ketC.text,
                  });
                  controller.isLoading(false);
                  Get.back();

                  if (hasil["error"] == false) {
                    Get.snackbar(hasil["error"] == true ? "Error" : "Sukses",
                        hasil["message"]);
                  }
                } else {
                  Get.snackbar("Error", "Semua Data Wajib Diisi.");
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
              () => Text(controller.isLoading.isFalse
                  ? "Add Presensi"
                  : "LOADING...."),
            ),
          ),
        ],
      ),
    );
  }
}
