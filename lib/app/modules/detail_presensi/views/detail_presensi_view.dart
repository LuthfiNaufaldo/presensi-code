import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi_polsri/app/data/models/presensi_models.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  final Map<String, dynamic> data = Get.arguments;
  var presensi = PresensiModel.fromJson(Get.arguments);
  @override
  Widget build(BuildContext context) {
    print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(presensi.date))}", //error di sini
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  presensi.matkul,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  presensi.kelas == null
                      ? "Kelas : -"
                      : "Kelas :${presensi.kelas}",
                ),
                Text(presensi.date == null
                    ? "Jam : -"
                    : "Jam : ${DateFormat.jms().format(DateTime.parse(presensi.date))}"),
                Text(
                  presensi.lat == null && presensi.long == null
                      ? "Posisi : -"
                      : "Posisi : ${presensi.lat}, ${presensi.long}",
                ),
                Text(
                  presensi.status == null
                      ? "Status : -"
                      : "Status :${presensi.status}",
                ),
                Text(
                  presensi.jangkaun_area == null
                      ? "Jangkauan : -"
                      : "Jangkauan : ${presensi.jangkaun_area.toString().split(".").first}",
                ),
                Text(
                  presensi.address == null
                      ? "Address: -"
                      : "Address : ${presensi.address}",
                ),
                SizedBox(height: 10),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200]),
          ),
        ],
      ),
    );
  }
}
