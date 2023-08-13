import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// ignore: unused_import
import '../modules/qrscan/controllers/qrscan_controller.dart';
import '../routes/app_pages.dart';
import 'dart:async';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> getRole() async {
    // Initialize Firebase
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String uid = await auth.currentUser!.uid;

    Stream<DocumentSnapshot<Map<String, dynamic>>> userStream =
        firestore.collection("Mahasiswa").doc(uid).snapshots();

    var role = null;

    var completer = Completer<String?>(); // Use Completer to manage the future

    userStream.listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        // Process userData as needed
        role = userData["role"];
        completer.complete(role); // Complete the future when role is obtained
      } else {
        role = null;
        completer.complete(role); // Complete the future even if role is null
      }
    }, onError: (error) {
      role = null;
      print("Debag: Error: $error");
      completer.complete(role); // Complete the future in case of error
    });

    // To stop listening when you're done
    // subscription.cancel();
    // No need to cancel the subscription here, as it would prevent the future from completing

    return completer.future; // Return the future from Completer
  }

  void changePage(int i) async {
    switch (i) {
      case 1:
        try {
          String? role = await getRole();
          print("Debag: $role");

          if (role == 'Mahasiswa') {
            Map<String, dynamic> dataResponse = await determinePosition();
            if (dataResponse["error"] != true) {
              Position position = dataResponse["position"];

              List<Placemark> placemarks = await placemarkFromCoordinates(
                  position.latitude, position.longitude);
              String address =
                  "${placemarks[0].name}, ${placemarks[0].subLocality},${placemarks[0].locality} ";
              await updatePosition(position, address);

              //cek distance between 2 position
              double distance = Geolocator.distanceBetween(
                  -2.98207, 104.73433, position.latitude, position.longitude);

              String barcode = await FlutterBarcodeScanner.scanBarcode(
                "#000000",
                "CANCEL",
                true,
                ScanMode.QR,
              );

              //bandingkan barcode

              //presensi
              await presensi(position, address, distance);
            } else {
              Get.snackbar("Terjadi Kesalahan", dataResponse["message"]);
            }
          } else if (role == 'Admin' || role == 'Dosen') {
            Get.offAllNamed(Routes.QRSCAN);
          }
        } catch (error) {
          print("Debag: Error: $error");
        }
        break;

      case 2:
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presensi(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresensi =
        firestore.collection("Mahasiswa").doc(uid).collection("presensi");

    QuerySnapshot<Map<String, dynamic>> snapPresensi = await colPresensi.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    String status = "Di luar Area";

    if (distance <= 200) {
      status = "Di dalam area";
    }

    if (snapPresensi.docs.length == 0) {
      //belum pernah melakukan presensi & set presensi masuk

      await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText:
            "Apakah Kamu yakin akan mengisi daftar hadir (Masuk) Sekarang ?",
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await colPresensi.doc(todayDocID).set(
                {
                  "date": now.toIso8601String(),
                  "masuk": {
                    "date": now.toIso8601String(),
                    "lat": position.latitude,
                    "long": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  },
                },
              );
              Get.back();
              Get.snackbar(
                  "Berhasil", "kamu telah mengisi daftar hadir (Masuk)");
            },
            child: const Text("Yes !"),
          ),
        ],
      );
    } else {
      // sudah pernah absen -> cek hari ini udah absen masuk/keluar ?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresensi.doc(todayDocID).get();

      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk & keluar

        Map<String, dynamic>? dataPresensiToday = todayDoc.data();
        if (dataPresensiToday?["keluar"] != null) {
          //sudah absen masuk & keluar
          Get.snackbar("Infomasi Penting",
              "Kamu telah absen masuk & keluar tidak dapat presensi kembali.");
        } else {
          // absen keluar
          await Get.defaultDialog(
            title: "Validasi Presensi",
            middleText:
                "Apakah Kamu yakin akan mengisi daftar hadir (Keluar) Sekarang ?",
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await colPresensi.doc(todayDocID).update(
                    {
                      "keluar": {
                        "date": now.toIso8601String(),
                        "lat": position.latitude,
                        "long": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      },
                    },
                  );
                  Get.back();
                  Get.snackbar(
                      "Berhasil", "kamu telah mengisi daftar hadir (Keluar)");
                },
                child: const Text("Yes !"),
              ),
            ],
          );
        }
      } else {
        // absen masuk
        await Get.defaultDialog(
          title: "Validasi Presensi",
          middleText:
              "Apakah Kamu yakin akan mengisi daftar hadir (Masuk) Sekarang ?",
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await colPresensi.doc(todayDocID).set(
                  {
                    "date": now.toIso8601String(),
                    "masuk": {
                      "date": now.toIso8601String(),
                      "lat": position.latitude,
                      "long": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    },
                  },
                );
                Get.back();
                Get.snackbar(
                    "Berhasil", "kamu telah mengisi daftar hadir (Masuk)");
              },
              child: const Text("Yes !"),
            ),
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    firestore.collection("Mahasiswa").doc(uid).update({
      "position": {
        "lat": position.latitude,
        "long": position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        "message": "Tidak dapat menggunakan GPS dari device ini.",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return {
          "message": "Izin menggunakan GPS ditolak.",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Device kamu tidak mengizinkan akses GPS. ubah settingan pada device kamu",
        "error": true,
      };
      //   return Future.error(
      //       'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return {
      "position": position,
      "message": "Berhasil Mendapatkan Lokasi.",
      "error": false,
    };
  }
}
