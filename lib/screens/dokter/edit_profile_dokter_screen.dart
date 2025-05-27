import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:klinik_hewan/config/app_config.dart';
import 'dart:convert';

class EditProfileDokterScreen extends StatefulWidget {
  final int akunId;

  const EditProfileDokterScreen({Key? key, required this.akunId}) : super(key: key);

  @override
  _EditProfileDokterScreenState createState() => _EditProfileDokterScreenState();
}

class _EditProfileDokterScreenState extends State<EditProfileDokterScreen> {
  File? _imageFile;
  String? _fotoUrl;
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noHpController = TextEditingController();
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // atau .camera
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProfile() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/update-dokter/${widget.akunId}');
      var request = http.MultipartRequest('POST', url)
        ..fields['nama'] = _namaController.text
        ..fields['alamat'] = _alamatController.text
        ..fields['no_hp'] = _noHpController.text;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('foto', _imageFile!.path),
        );
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profil berhasil diperbarui")),
        );
        Navigator.of(context).pop(true);
      } else {
        print("Gagal update: $respStr");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui profil")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat mengirim data")),
      );
    }
  }

  Future<void> fetchDokterData() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/dokter/${widget.akunId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final dokter = data['data']; // Sesuaikan dengan struktur respons Laravel

        setState(() {
          _namaController.text = dokter['nama'] ?? '';
          _alamatController.text = dokter['alamat'] ?? '';
          _noHpController.text = dokter['no_hp'] ?? '';
          if (dokter['foto'] != null) {
            _fotoUrl = '${AppConfig.baseUrl}/storage/${dokter['foto']}'; // sesuaikan path
          }
        });
      } else {
        print('Gagal mengambil data: ${response.body}');
      }
    } catch (e) {
      print('Error mengambil data dokter: $e');
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profil')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null ? Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              controller: _noHpController,
              decoration: InputDecoration(labelText: 'No HP'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
