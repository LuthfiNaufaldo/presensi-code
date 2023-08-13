import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> streamPresensi() async* {
    yield* firestore.collection('presensi').snapshots();
  }
}
