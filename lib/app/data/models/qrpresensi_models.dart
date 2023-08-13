class QRPresensiModel {
  final String hari;
  final String kelas;
  final String keterangan;
  final String matkul;
  final String presensiId;
  final String status;

  QRPresensiModel(
      {required this.hari,
      required this.kelas,
      required this.keterangan,
      required this.matkul,
      required this.presensiId,
      required this.status});

  factory QRPresensiModel.fromJson(Map<String?, dynamic> json) =>
      QRPresensiModel(
        hari: json["hari"] ?? "",
        kelas: json["kelas"],
        keterangan: json["keterangan"] ?? "",
        matkul: json["matkul"],
        presensiId: json["presensiId"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "hari": hari,
        "kelas": kelas,
        "keterangan": keterangan,
        "matkul": matkul,
        "presensiId": presensiId,
        "status": status,
      };
}
