class PresensiModel {
  final String npm;
  final String presensiId;
  final String name;
  final String kelas;
  final String hari;
  final String matkul;
  final String keterangan;

  PresensiModel({
    required this.npm,
    required this.presensiId,
    required this.name,
    required this.kelas,
    required this.hari,
    required this.matkul,
    required this.keterangan,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) => PresensiModel(
        npm: json["code"] ?? "",
        presensiId: json["presensiId"] ?? "",
        name: json["name"] ?? "",
        kelas: json["kelas"] ?? "",
        hari: json["hari"] ?? "",
        matkul: json["matkul"] ?? "",
        keterangan: json["keterangan"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": npm,
        "presensiId": presensiId,
        "name": name,
        "kelas": kelas,
        "hari": hari,
        "matkul": matkul,
        "keterangan": keterangan,
      };
}
