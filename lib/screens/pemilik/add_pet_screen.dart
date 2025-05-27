import 'package:flutter/material.dart';

class AddPetScreen extends StatefulWidget {
  final int pemilikId;

  const AddPetScreen({Key? key, required this.pemilikId}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Hewan')),
      body: Center(
        child: Text('Form Tambah Hewan untuk Pemilik ID: ${widget.pemilikId}'),
      ),
    );
  }
}

class Pet {
  final int? id;
  final String nama;
  final String jenis;

  Pet({this.id, required this.nama, required this.jenis});

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        id: json['id'],
        nama: json['nama'],
        jenis: json['jenis'],
      );

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'jenis': jenis,
      };
}
