import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_dosen_controller.dart';

class AddDosenView extends GetView<AddDosenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Dosen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: controller.nipC,
            decoration: InputDecoration(
              labelText: "NIP",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
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
            autocorrect: false,
            controller: controller.matkulC,
            decoration: InputDecoration(
              labelText: "Mata Kuliah",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
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
            decoration: InputDecoration(
              labelText: "Default role : 'Dosen' ",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Default Password = 'Password' ",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 30),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.addDosen();
                }
              },
              child: Text(
                  controller.isLoading.isFalse ? "ADD DOSEN" : "LOADING..."),
            ),
          ),
        ],
      ),
    );
  }
}
