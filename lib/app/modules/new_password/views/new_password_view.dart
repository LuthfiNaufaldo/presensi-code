import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Password Baru'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            obscureText: true,
            controller: controller.newPassC,
            decoration: InputDecoration(
              labelText: "Masukkan Password Baru",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              controller.newPassword();
            },
            child: Text("Lanjutkan"),
          )
        ],
      ),
    );
  }
}
