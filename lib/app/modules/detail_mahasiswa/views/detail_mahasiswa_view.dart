import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/data/models/qrpresensi_models.dart';
// ignore: unused_import
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/detail_mahasiswa_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DetailMahasiswaView extends GetView<DetailMahasiswaController> {
  final QRPresensiModel presensi = Get.arguments as QRPresensiModel;
  late String selectedStatus;
  late String selectedMatkul;
  late DateTime selectedDate;

  // final TextEditingController noC = TextEditingController();
  // final TextEditingController nameC = TextEditingController();
  // final TextEditingController npmC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  // final TextEditingController dateC = TextEditingController();
  // final TextEditingController matkulC = TextEditingController();
  // final TextEditingController statusC = TextEditingController();
  final TextEditingController ketC = TextEditingController();

  // List of available matkul options (you can fetch this from a data source)
  final List<String> availableMatkul = [
    'Matkul 1',
    'Matkul 2',
    'Matkul 3',
    // Add more options as needed
  ];

  final List<String> availableStatus = [
    'Masuk',
    'Keluar',
    // Add more options as needed
  ];

  @override
  Widget build(BuildContext context) {
    kelasC.text = presensi.kelas;
    selectedDate = DateTime.parse(presensi.hari);
    selectedMatkul = presensi.matkul;
    selectedStatus = presensi.status;
    ketC.text = presensi.keterangan;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Presensi'),
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
                  data: presensi.presensiId,
                  size: 200.0,
                  version: QrVersions.auto,
                ),
              ),
            ],
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
          SfDateRangePicker(
            minDate: DateTime.now().subtract(Duration(days: 365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
            initialSelectedDate: selectedDate,
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              // Update the selected date and time
              selectedDate = args.value;
            },
            // You can customize appearance and other properties as needed
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: selectedMatkul,
            onChanged: (newValue) {
              // Update the selected matkul option
              selectedMatkul = newValue.toString();
            },
            items: availableMatkul.map((matkul) {
              return DropdownMenuItem(
                value: matkul,
                child: Text(matkul),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Mata Kuliah",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: selectedStatus,
            onChanged: (newValue) {
              // Update the selected matkul option
              selectedStatus = newValue.toString();
            },
            items: [selectedStatus].map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Status Presensi",
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
                if (kelasC.text.isNotEmpty &&
                    selectedStatus.isNotEmpty &&
                    selectedDate.toString().isNotEmpty &&
                    ketC.text.isNotEmpty) {
                  Map<String, dynamic> hasil = await controller.editPresensi({
                    "id": presensi.presensiId,
                    "kelas": kelasC.text,
                    "hari": selectedDate.toString(),
                    "matkul": selectedMatkul,
                    "status": selectedStatus,
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
