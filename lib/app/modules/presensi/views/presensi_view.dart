import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/data/models/presensi_models.dart';
import 'package:presensi_polsri/app/routes/app_pages.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/presensi_controller.dart';

class PresensiView extends GetView<PresensiController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presensi'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamPresensi(),
        builder: (context, snapPresensi) {
          if (snapPresensi.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapPresensi.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Presensi"),
            );
          }
          List<PresensiModel> allPresensi = [];
          for (var element in snapPresensi.data!.docs) {
            allPresensi.add(PresensiModel.fromJson(element.data()));
          }
          return ListView.builder(
            itemCount: allPresensi.length,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) {
              PresensiModel presensi = allPresensi[index];
              return Card(
                elevation: 20,
                margin: EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.DETAIL_MAHASISWA, arguments: presensi);
                  },
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                presensi.npm,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text("Nama : ${presensi.name}"),
                              Text("Kelas : ${presensi.kelas}"),
                              Text("Mata Kuliah : ${presensi.matkul}"),
                              Text("Hari : ${presensi.hari}"),
                              Text("Ket ${presensi.keterangan}"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: QrImageView(
                            data:
                                "${presensi.npm}\n${presensi.kelas}\n${presensi.matkul}\n${presensi.hari}",
                            size: 200.0,
                            version: QrVersions.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
