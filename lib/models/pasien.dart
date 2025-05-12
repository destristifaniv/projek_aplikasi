class Pasien {
  final String namaHewan;
  final String namaPemilik;
  final int umur;
  final String jenis;
  final String warna;
  final String alamat;
  final String noTelp;

  Pasien({
    required this.namaHewan,
    required this.namaPemilik,
    required this.umur,
    required this.jenis,
    required this.warna,
    required this.alamat,
    required this.noTelp,
  });

  // Konversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'namaHewan': namaHewan,
      'namaPemilik': namaPemilik,
      'umur': umur,
      'jenis': jenis,
      'warna': warna,
      'alamat': alamat,
      'noTelp': noTelp,
    };
  }

  // Konversi dari JSON ke objek
  factory Pasien.fromJson(Map<String, dynamic> json) {
    return Pasien(
      namaHewan: json['namaHewan'],
      namaPemilik: json['namaPemilik'],
      umur: json['umur'],
      jenis: json['jenis'],
      warna: json['warna'],
      alamat: json['alamat'],
      noTelp: json['noTelp'],
    );
  }
}
