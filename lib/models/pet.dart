import 'package:flutter/material.dart'; // Hanya untuk contoh, bukan di model sebenarnya

class Pet {
  final int? id;
  final String nama;
  final String jenis;
  final String warna;
  final int usia;
  final String? catatan; // Diagnosa by dokter atau catatan umum
  final int pemilikId;
  final int? dokterId;
  final String? foto; // Path relatif foto
  final String? kondisi; // <-- TAMBAHKAN INI

  Pet({
    this.id,
    required this.nama,
    required this.jenis,
    required this.warna,
    required this.usia,
    this.catatan,
    required this.pemilikId,
    this.dokterId,
    this.foto,
    this.kondisi, // <-- TAMBAHKAN INI
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      nama: json['nama'],
      jenis: json['jenis'],
      warna: json['warna'],
      usia: json['usia'],
      catatan: json['catatan'],
      pemilikId: json['pemilik_id'],
      dokterId: json['dokter_id'],
      foto: json['foto'], // <-- Pastikan ini sesuai dengan key di JSON Anda
      kondisi: json['kondisi'], // <-- TAMBAHKAN INI
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jenis': jenis,
      'warna': warna,
      'usia': usia,
      'catatan': catatan,
      'pemilik_id': pemilikId,
      'dokter_id': dokterId,
      'foto': foto,
      'kondisi': kondisi, // <-- TAMBAHKAN INI
    };
  }

  Pet copyWith({
    int? id,
    String? nama,
    String? jenis,
    String? warna,
    int? usia,
    String? catatan,
    int? pemilikId,
    int? dokterId,
    String? foto,
    String? kondisi, // <-- TAMBAHKAN INI
  }) {
    return Pet(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      jenis: jenis ?? this.jenis,
      warna: warna ?? this.warna,
      usia: usia ?? this.usia,
      catatan: catatan ?? this.catatan,
      pemilikId: pemilikId ?? this.pemilikId,
      dokterId: dokterId ?? this.dokterId,
      foto: foto ?? this.foto,
      kondisi: kondisi ?? this.kondisi, // <-- TAMBAHKAN INI
    );
  }
}