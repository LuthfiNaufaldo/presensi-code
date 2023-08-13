import 'dart:io';

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:presensi_polsri/app/data/models/presensi_models.dart';

class QrscanController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<PresensiModel> allPresensi = List<PresensiModel>.empty().obs;

  void downloadPdf() async {
    final pdf = pw.Document();

    // ignore: unused_local_variable
    var getData = await firestore.collection("presensi").get();

    // reset all presesnsi -> untuk mengatasi duplikasi
    allPresensi([]);

    // isi data all presensi dari database
    for (var element in getData.docs) {
      allPresensi.add(PresensiModel.fromJson(element.data()));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          List<pw.TableRow> allData =
              List.generate(allPresensi.length, (index) {
            // ignore: unused_local_variable
            PresensiModel presensi = allPresensi[index];
            return pw.TableRow(
              children: [
                // No
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    "${index + 1}",
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                // Kelas
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    presensi.kelas,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                // Hari
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    presensi.date,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                // Matkul
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    presensi.matkul,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                // Ket
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.Text(
                    presensi.keterangan,
                    textAlign: pw.TextAlign.center,
                    style: const pw.TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
                // QR Code
                pw.Padding(
                  padding: const pw.EdgeInsets.all(10),
                  child: pw.BarcodeWidget(
                    color: PdfColor.fromHex("#000000"),
                    barcode: pw.Barcode.qrCode(),
                    data: presensi.presensiId,
                    height: 50,
                    width: 50,
                  ),
                ),
              ],
            );
          });

          return [
            pw.Center(
              child: pw.Text(
                "Presensi Mahasiswa",
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Nama
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Nama",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // NPM
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "NPM",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Kelas
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Kelas",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Hari
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Hari",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Matkul
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Mata Kuliah",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Ket
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "Keterangan",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // QR Code
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Text(
                        "QR CODE",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    //simpan
    Uint8List bytes = await pdf.save();

    // buat file kosong di drektori
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/filepresensi.pdf');

    // memasukkan data bytes -> filekosong
    await file.writeAsBytes(bytes);

    //open pdf
    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getPresensiById(String codeQR) async {
    try {
      print("codeQR: $codeQR");

      var hasil = await firestore
          .collection("presensi")
          .where("code", isEqualTo: codeQR)
          .get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true,
          "message": "Tidak ada presensi di database.",
        };
      }
      Map<String, dynamic> data = hasil.docs.first.data();

      print("data: $data");

      return {
        "error": false,
        "message": "Berhasil Mendapatkan Detail Presensi",
        "data": data,
      };
    } catch (e) {
      return {
        "error": true,
        "message": "Tidak Mendapatkan Detail Presensi",
      };
    }
  }
}
