import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMahasiswaController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddMahasiswa = false.obs;
  // RxString selectedRole = "".obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController npmC = TextEditingController();
  TextEditingController kelasC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passadminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddMahasiswa() async {
    if (passadminC.text.isNotEmpty) {
      isLoadingAddMahasiswa.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        // ignore: unused_local_variable
        UserCredential userCredentialAdmin =
            await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passadminC.text,
        );

        UserCredential mhsCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (mhsCredential.user != null) {
          String uid = mhsCredential.user!.uid;

          firestore.collection("Mahasiswa").doc(uid).set({
            "NPM": npmC.text,
            "Nama": nameC.text,
            "Email": emailC.text,
            "Kelas": kelasC.text,
            "uid": uid,
            "role": "Mahasiswa",
            "createdAt": DateTime.now().toIso8601String(),
          });
          await mhsCredential.user!.sendEmailVerification();

          await auth.signOut();

          // ignore: unused_local_variable
          UserCredential userCredentialAdmin =
              await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passadminC.text,
          );

          Get.back(); // tutup dialog
          Get.back(); // back to home
          Get.snackbar("Berhasil ", "Anda berhasil menambahkan mahasiswa.");
          isLoadingAddMahasiswa.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddMahasiswa.value = false;
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
        isLoadingAddMahasiswa.value = false;
        Get.snackbar(
            "Terjadi Kesalahan", "NPM, Nama, email, dan password  harus diisi");
      }
    } else {
      isLoading.value = false;
      Get.snackbar(
          "terjadi Kesalahan", "Password Wajib diisi untuk keperluan validasi");
    }
  }

  Future<void> addMahasiwa() async {
    if (nameC.text.isNotEmpty &&
        npmC.text.isNotEmpty &&
        kelasC.text.isNotEmpty &&
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
                  if (isLoadingAddMahasiswa.isFalse) {
                    await prosesAddMahasiswa();
                  }
                  isLoading.value = false;
                },
                child: Text(isLoadingAddMahasiswa.isFalse
                    ? "ADD Mahasiswa"
                    : "LOADING..."),
              ),
            ),
          ]);
    } else {
      Get.snackbar(
          "Terjadi Kesalahan", "NPM,Nama,Email dan Kelas harus diisi.");
    }
  }
}
