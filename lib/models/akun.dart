class Akun {
  final int id;
  final String nama;
  final String email;
  final String role;

  Akun({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
  });

  factory Akun.fromJson(Map<String, dynamic> json) {
    return Akun(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
    );
  }
}
