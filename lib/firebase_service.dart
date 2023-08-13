import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error saat login: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  // Tambahkan fungsi untuk menyimpan data presensi ke database Firestore
  Future<void> savePresensi(String mahasiswaId, String status) async {
    try {
      await _firestore.collection('presensi').doc(mahasiswaId).set({
        'status': status,
        'waktu': DateTime.now(),
      });
    } catch (e) {
      print('Error saat menyimpan data presensi: $e');
    }
  }
}
