import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/controllers/presensi_controller.dart';
import 'package:presensi_polsri/models.dart';

import '../controllers/dosen_home_controller.dart';

// ignore: must_be_immutable
class DosenHomeView extends GetView<DosenHomeController> {
  final PresensiController presensiController = Get.put(PresensiController());
  // Dummy data untuk daftar jadwal mata kuliah
  List<Jadwal> listOfJadwal = [
    Jadwal(
      kodeMataKuliah: 'JK001',
      jam: '08.00 - 10.00',
      hari: 'Senin',
    ),
    Jadwal(
      kodeMataKuliah: 'WEB001',
      jam: '10.30 - 12.30',
      hari: 'Rabu',
    ),
    Jadwal(
      kodeMataKuliah: 'MK001',
      jam: '13.00 - 15.00',
      hari: 'Kamis',
    ),
  ];

  DosenHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beranda Dosen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the course schedule list using ListView
            ListView.builder(
              shrinkWrap: true,
              itemCount: listOfJadwal.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    '${listOfJadwal[index].kodeMataKuliah} - ${listOfJadwal[index].jam} - ${listOfJadwal[index].hari}',
                  ),
                  onTap: () {
                    // Set the selected course schedule to the text field
                    presensiController.textFieldController.text =
                        '${listOfJadwal[index].kodeMataKuliah} - ${listOfJadwal[index].jam} - ${listOfJadwal[index].hari}';
                  },
                );
              },
            ),
            // Text field for entering the course schedule
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: presensiController.textFieldController,
                decoration: InputDecoration(
                  labelText: 'Masukkan jadwal kuliah',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Extract the course schedule from the text field
                String jadwalKuliah =
                    presensiController.textFieldController.text;

                // Split the course schedule string to get the individual fields
                List<String> jadwalFields = jadwalKuliah.split(' - ');
                if (jadwalFields.length == 3) {
                  String kodeMataKuliah = jadwalFields[0];
                  String jam = jadwalFields[1];
                  String hari = jadwalFields[2];

                  // Create a new Jadwal object
                  Jadwal newJadwal = Jadwal(
                    kodeMataKuliah: kodeMataKuliah,
                    jam: jam,
                    hari: hari,
                  );

                  // Call the setJadwal method from the controller
                  await presensiController.setJadwal(newJadwal);
                }
              },
              child: Text('Ambil QR Code dari Jadwal'),
            ),
          ],
        ),
      ),
    );
  }
}

// Definisi metode getJadwalFromFirebase untuk mendapatkan data jadwal dari Firebase
Future<List<Jadwal>> getJadwalFromFirebase() async {
  // Implementasikan logika untuk mendapatkan data jadwal dari Firebase
  // Contoh implementasi sederhana: return sebuah daftar jadwal kosong
  return [];
}
