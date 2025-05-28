import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:klinik_hewan/models/pet.dart' as models;
import 'package:klinik_hewan/providers/pet_provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Jika menggunakan GoogleFonts

// Warna yang konsisten
const Color primaryColor = Color(0xFFFF6B9D);
const Color primaryLight = Color(0xFFFFB3D1);
const Color backgroundColor = Color(0xFFFFF5F8);
const Color cardColor = Color(0xFFFFFFFF);
const Color accentColor = Color(0xFFFF8FA3);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);

class AddPetScreen extends StatefulWidget {
  // idAkunPemilik adalah ID dari tabel akuns/users
  // Di Laravel, ini perlu dikonversi ke id primary key dari tabel pemiliks
  final int idAkunPemilik;

  const AddPetScreen({Key? key, required this.idAkunPemilik}) : super(key: key);

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _warnaController = TextEditingController();
  final TextEditingController _usiaController = TextEditingController();
  final TextEditingController _kondisiController = TextEditingController(); // Untuk kondisi hewan
  // final TextEditingController _fotoController = TextEditingController(); // Jika ingin input URL foto langsung

  bool _isSaving = false;

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _warnaController.dispose();
    _usiaController.dispose();
    _kondisiController.dispose();
    // _fotoController.dispose();
    super.dispose();
  }

  void _savePet() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        final String nama = _namaController.text;
        final String jenis = _jenisController.text;
        final String warna = _warnaController.text; // Bisa kosong
        final int usia = int.parse(_usiaController.text);
        final String kondisi = _kondisiController.text; // Tidak boleh kosong
        // final String? foto = _fotoController.text.isEmpty ? null : _fotoController.text;

        // Membuat objek Pet.
        // pemilikId adalah ID AKUN, backend akan mengonversinya ke ID PEMILIK
        final newPet = models.Pet(
          nama: nama,
          jenis: jenis,
          warna: warna.isNotEmpty ? warna : '', // Kirim string kosong jika warna kosong
          usia: usia,
          kondisi: kondisi,
          pemilikId: widget.idAkunPemilik, // Mengirim ID Akun dari pengguna yang login
          dokterId: null, // Dokter ID tidak diisi saat menambah pet oleh pemilik
          catatan: null, // Catatan biasanya untuk diagnosa, tidak diisi saat add pet
          foto: null, // Untuk saat ini, foto null. Anda bisa tambahkan fitur upload/input foto nanti.
        );

        await Provider.of<PetProvider>(context, listen: false).addPet(newPet);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hewan berhasil ditambahkan!')),
        );
        Navigator.of(context).pop(true); // Kembali ke PetsScreen dan beri sinyal untuk refresh
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan hewan: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Tambah Hewan Baru',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Hewan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.pets, color: primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Nama hewan tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jenisController,
                decoration: InputDecoration(
                  labelText: 'Jenis Hewan (misal: Kucing, Anjing)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category, color: primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Jenis hewan tidak boleh kosong';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _warnaController,
                decoration: InputDecoration(
                  labelText: 'Warna (Opsional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.color_lens, color: primaryColor),
                ),
                // Warna bisa kosong, tidak perlu validator jika nullable di DB
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usiaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Usia Hewan (tahun)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.cake, color: primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Usia tidak boleh kosong';
                  if (int.tryParse(value) == null) return 'Usia harus angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kondisiController,
                decoration: InputDecoration(
                  labelText: 'Kondisi Hewan (misal: Sehat, Sakit, Perlu Perawatan)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.healing, color: primaryColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Kondisi hewan tidak boleh kosong';
                  return null;
                },
              ),
              // const SizedBox(height: 16),
              // TextFormField( // Contoh input foto jika ingin via URL
              //   controller: _fotoController,
              //   decoration: InputDecoration(
              //     labelText: 'URL Foto (Opsional)',
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              //     prefixIcon: const Icon(Icons.image, color: primaryColor),
              //   ),
              // ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: _isSaving
                    ? const Center(child: CircularProgressIndicator(color: primaryColor))
                    : ElevatedButton(
                        onPressed: _savePet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Simpan Hewan'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}