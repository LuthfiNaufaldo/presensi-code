import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDosenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddDosen = false.obs;

  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController matkulC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passadminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddDosen() async {
    if (passadminC.text.isNotEmpty) {
      isLoadingAddDosen.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // ignore: unused_local_variable
        UserCredential dosenCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passadminC.text,
        );

        UserCredential dosenCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (dosenCredential.user != null) {
          String uid = dosenCredential.user!.uid;

          firestore.collection("Mahasiswa").doc(uid).set({
            "NPM": nipC.text,
            "Nama": nameC.text,
            "Email": emailC.text,
            "Mata Kuliah": matkulC.text,
            "uid": uid,
            "role": "Dosen",
            "createdAt": DateTime.now().toIso8601String(),
          });
          await dosenCredential.user!.sendEmailVerification();

          await auth.signOut();

          // ignore: unused_local_variable
          UserCredential dosenCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passadminC.text,
          );

          Get.back(); // tutup dialog
          Get.back(); // back to home
          Get.snackbar("Berhasil ", "Anda berhasil menambahkan Dosen.");
          isLoadingAddDosen.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddDosen.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar(
              "Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan",
              "akun telah terdaftar, tidak dapat menambahkan lagi akun yang telah ada.");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan",
              "Admin tidak dapat login. Password Salah !.");
        } else {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        isLoadingAddDosen.value = false;
        Get.snackbar(
            "Terjadi Kesalahan", "NIP, Nama, email, dan password  harus diisi");
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          "terjadi Kesalahan", "Password Wajib diisi untuk keperluan validasi");
    }
  }

  Future<void> addDosen() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        matkulC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
          title: "Validasi Admin",
          content: Column(
            children: [
              Text("Masukkan Password untuk validasi admin !"),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passadminC,
                autocorrect: false,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                isLoading.value = false;
                Get.back();
              },
              child: Text("Cancel"),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  if (isLoadingAddDosen.isFalse) {
                    await prosesAddDosen();
                  }
                  isLoading.value = false;
                },
                child: Text(
                    isLoadingAddDosen.isFalse ? "ADD Dosen" : "LOADING..."),
              ),
            ),
          ]);
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "NIP,Nama,Email dan Pengajar harus diisi.");
    }
  }
}
