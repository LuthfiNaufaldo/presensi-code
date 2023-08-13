class PresensiModel {
  final String address;
  final String kelas;
  final String date;
  final double lat;
  final double long;
  final double distance;
  final String matkul;
  final String status;
  final String jangkaun_area;
  final String keterangan;
  final String presensiId;

  PresensiModel({
    required this.address,
    required this.kelas,
    required this.date,
    required this.distance,
    required this.lat,
    required this.long,
    required this.matkul,
    required this.status,
    required this.jangkaun_area,
    required this.keterangan,
    required this.presensiId,
  });

  factory PresensiModel.fromJson(Map<String?, dynamic> json) => PresensiModel(
        presensiId: json["presensiId"] ?? "",
        address: json["address"],
        date: json["date"] ?? "",
        distance: json["distance"],
        kelas: json["kelas"] ?? "",
        lat: json["lat"] ?? "",
        long: json["long"] ?? "",
        matkul: json["matkul"] ?? "",
        status: json["status"] ?? "",
        jangkaun_area: json["jangkaun_area"] ?? "",
        keterangan: json["keterangan"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "presensiId": presensiId,
        "address": address,
        "kelas": kelas,
        "date": date,
        "distance": distance,
        "lat": lat,
        "long": long,
        "matkul": matkul,
        "status": status,
        "jangkaun_area": jangkaun_area,
        "keterangan": keterangan,
      };
}
