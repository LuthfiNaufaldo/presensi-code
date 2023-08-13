import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'package:get/get.dart';
import 'package:presensi_polsri/app/controllers/page_index_controller.dart';
import 'package:presensi_polsri/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            String defaultImage =
                "https://ui-avatars.com/api/?name=${user['Nama']}";
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          user["Profile"] != null
                              ? user["Profile"] != ""
                                  ? user["Profile"]
                                  : defaultImage
                              : "https://ui-avatars.com/api/?name=${user['Nama']}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "${user['Nama'].toString().toUpperCase()}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "${user['Email']}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: () =>
                      Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                  leading: Icon(Icons.person),
                  title: Text("Update Profile"),
                ),
                ListTile(
                  onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                  leading: Icon(Icons.vpn_key),
                  title: Text("Update Password"),
                ),
                if (user["role"] == "Admin")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_MAHASISWA),
                    leading: Icon(Icons.person_add),
                    title: Text("Add Mahasiswa"),
                  ),
                if (user["role"] == "Admin")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_DOSEN),
                    leading: Icon(Icons.person_add),
                    title: Text("Add Dosen"),
                  ),
                if (user["role"] == "Dosen")
                  ListTile(
                    onTap: () => Get.toNamed(Routes.ADD_PRESENSI),
                    leading: Icon(Icons.person_add),
                    title: Text("Add Presensi"),
                  ),
                ListTile(
                  onTap: () => controller.logout(),
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat user."),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.qr_code, title: 'Add Presensi'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}
