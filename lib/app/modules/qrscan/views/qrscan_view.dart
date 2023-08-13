import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi_polsri/app/routes/app_pages.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../controllers/qrscan_controller.dart';

class QrscanView extends GetView<QrscanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SCAN QR'),
        centerTitle: true,
      ),
      body: GridView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          late String title;
          late IconData icon;
          late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Add Presensi";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.ADD_PRESENSI);
              break;
            case 1:
              title = "Detail Presensi";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.PRESENSI);
              break;
            case 2:
              title = "QR Code";
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                // Get data dari firebase search by product id
                Map<String, dynamic> hasil =
                    await controller.getPresensiById(barcode);
                if (hasil["error"] == false) {
                  Get.toNamed(Routes.DETAIL_PRESENSI, arguments: hasil["data"]);
                } else {
                  Get.snackbar(
                    "Error",
                    hasil["message"],
                    duration: const Duration(seconds: 2),
                  );
                }
              };
              break;
            case 3:
              title = "Cetak Presensi";
              icon = Icons.document_scanner_outlined;
              onTap = () {
                controller.downloadPdf();
              };
              break;
          }

          return Material(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(icon, size: 50),
                  ),
                  const SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Get.offAndToNamed(Routes.HOME);
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}
