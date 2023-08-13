import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_presensi_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddPresensiView extends GetView<AddPresensiController> {
  final TextEditingController kelasC = TextEditingController();
  // final TextEditingController hariC = TextEditingController();
  // final TextEditingController jamC = TextEditingController();
  final TextEditingController ketC = TextEditingController();
  DateTime selectedDate = DateTime.now(); // To store the selected date and time

  // List of available matkul options (you can fetch this from a data source)
  final List<String> availableMatkul = [
    'Matkul 1',
    'Matkul 2',
    'Matkul 3',
    // Add more options as needed
  ];

  final List<String> availableStatus = [
    'Masuk',
    'Keluar',
    // Add more options as needed
  ];

  String selectedStatus = 'Masuk';
  String selectedMatkul = 'Matkul 1'; // To store the selected matkul option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Presensi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: kelasC,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: "Kelas",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          SfDateRangePicker(
            minDate: DateTime.now().subtract(Duration(days: 365)),
            maxDate: DateTime.now().add(Duration(days: 365)),
            initialSelectedDate: selectedDate,
            selectionMode: DateRangePickerSelectionMode.single,
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              // Update the selected date and time
              selectedDate = args.value;
            },
            // You can customize appearance and other properties as needed
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: selectedMatkul,
            onChanged: (newValue) {
              // Update the selected matkul option
              selectedMatkul = newValue.toString();
            },
            items: availableMatkul.map((matkul) {
              return DropdownMenuItem(
                value: matkul,
                child: Text(matkul),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Mata Kuliah",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
            value: selectedStatus,
            onChanged: (newValue) {
              // Update the selected matkul option
              selectedStatus = newValue.toString();
            },
            items: availableStatus.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(status),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: "Status Presensi",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: ketC,
            decoration: InputDecoration(
              labelText: "Keterangan",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (kelasC.text.isNotEmpty &&
                    selectedDate.toString().isNotEmpty &&
                    selectedMatkul.isNotEmpty &&
                    ketC.text.isNotEmpty) {
                  controller.isLoading(true);

                  Map<String, dynamic> hasil = await controller.addPresensi({
                    "kelas": kelasC.text,
                    "hari": selectedDate.toString(),
                    "matkul": selectedMatkul,
                    "status": selectedStatus,
                    "keterangan": ketC.text,
                  });
                  controller.isLoading(false);
                  Get.back();

                  if (hasil["error"] == false) {
                    Get.snackbar(hasil["error"] == true ? "Error" : "Sukses",
                        hasil["message"]);
                  }
                } else {
                  Get.snackbar("Error", "Semua Data Wajib Diisi.");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse
                  ? "Add Presensi"
                  : "LOADING...."),
            ),
          ),
        ],
      ),
    );
  }
}
