class Pasien {
  final String namaHewan;
  final String jenis;
  final String warna;
  final int umur;
  final String namaPemilik;
  final String alamat;
  final String noTelp;

  Pasien({
    required this.namaHewan,
    required this.jenis,
    required this.warna,
    required this.umur,
    required this.namaPemilik,
    required this.alamat,
    required this.noTelp,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_hewan': namaHewan,
      'jenis': jenis,
      'warna': warna,
      'umur': umur,
      'nama_pemilik': namaPemilik,
      'alamat': alamat,
      'no_telp': noTelp,
    };
  }
}