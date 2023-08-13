import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.npmC.text = user["NPM"] ?? "";
    controller.nameC.text = user["Nama"] ?? "";
    controller.kelasC.text = user["Kelas"] ?? "";
    controller.emailC.text = user["Email"] ?? "";
    controller.roleC.text = user["role"] ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text('UPDATE PROFILE'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          if (user["role"] == "Mahasiswa")
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: controller.npmC,
              decoration: InputDecoration(
                labelText: "NPM",
                border: OutlineInputBorder(),
              ),
            ),
          if (user["role"] == "Dosen")
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: controller.npmC,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
            ),
          if (user["role"] == "Admin")
            TextField(
              readOnly: true,
              autocorrect: false,
              controller: controller.npmC,
              decoration: InputDecoration(
                labelText: "NIP",
                border: OutlineInputBorder(),
              ),
            ),
          SizedBox(height: 20),
          Text(
            "Photo Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(
                builder: (c) {
                  if (c.image != null) {
                    return ClipOval(
                      child: Container(
                        height: 100,
                        width: 100,
                        child:
                            Image.file(File(c.image!.path), fit: BoxFit.cover),
                      ),
                    );
                  } else {
                    if (user["Profile"] != null) {
                      return Column(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user["Profile"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              controller.deleteProfile(user["uid"]);
                            },
                            child: Text("Delete"),
                          ),
                        ],
                      );
                    } else {
                      return Text("No image choosen");
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: Text("choose"),
              ),
            ],
          ),
          SizedBox(height: 30),
          TextField(
            autocorrect: false,
            controller: controller.nameC,
            decoration: InputDecoration(
              labelText: "Nama",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            readOnly: true,
            autocorrect: false,
            controller: controller.emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            readOnly: true,
            controller: controller.roleC,
            decoration: InputDecoration(
              labelText: "Role : ",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.updateProfile(user["uid"]);
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "UPDATE PROFILE"
                  : "LOADING..."),
            ),
          ),
        ],
      ),
    );
  }
}
