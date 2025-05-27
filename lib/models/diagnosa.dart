class Diagnosa {
  final int? id;
  final int hewanId;
  final int dokterId;
  final String tanggalDiagnosa;
  final String catatan;

  Diagnosa({
    this.id,
    required this.hewanId,
    required this.dokterId,
    required this.tanggalDiagnosa,
    required this.catatan,
  });

  factory Diagnosa.fromJson(Map<String, dynamic> json) {
    return Diagnosa(
      id: json['id'],
      hewanId: json['hewan_id'],
      dokterId: json['dokter_id'],
      tanggalDiagnosa: json['tanggal_diagnosa'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hewan_id': hewanId,
      'dokter_id': dokterId,
      'tanggal_diagnosa': tanggalDiagnosa,
      'catatan': catatan,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}