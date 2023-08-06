import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/qrscan_controller.dart';

class QrscanView extends GetView<QrscanController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QrscanView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'QrscanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
