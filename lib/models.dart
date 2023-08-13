import 'package:flutter/material.dart';

class Kelas {
  String kode;
  String nama;
  TimeOfDay mulai;
  TimeOfDay selesai;

  Kelas(
      {required this.kode,
      required this.nama,
      required this.mulai,
      required this.selesai});
}

class Jadwal {
  final String kodeMataKuliah;
  final String jam;
  final String hari;

  Jadwal({
    required this.kodeMataKuliah,
    required this.jam,
    required this.hari,
  });
}

class Mahasiswa {
  String nim;
  String nama;
  String password;

  Mahasiswa({required this.nim, required this.nama, required this.password});
}
