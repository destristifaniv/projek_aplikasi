import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:klinik_hewan/models/pasien.dart';
import 'package:klinik_hewan/providers/pasien_provider.dart';

// Warna tema pink soft
const Color primaryColor = Color(0xFFF8A5B3);
const Color primaryLight = Color(0xFFFDc4D0);
const Color backgroundColor = Color(0xFFFEE2E4);

class TambahPasienScreen extends StatefulWidget {
  @override
  _TambahPasienScreenState createState() => _TambahPasienScreenState();
}

class _TambahPasienScreenState extends State<TambahPasienScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaHewanController = TextEditingController();
  final TextEditingController jenisHewanController = TextEditingController();
  final TextEditingController warnaController = TextEditingController();
  final TextEditingController umurController = TextEditingController();
  final TextEditingController namaPemilikController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();

  bool _isExpandedHewan = true;
  bool _isExpandedPemilik = false;

  @override
  void dispose() {
    namaHewanController.dispose();
    jenisHewanController.dispose();
    warnaController.dispose();
    umurController.dispose();
    namaPemilikController.dispose();
    alamatController.dispose();
    noTelpController.dispose();
    super.dispose();
  }

  Widget buildInputField(String label, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator: (value) {
          if (value == null || value.isEmpty) return 'Tidak boleh kosong';
          if (label.contains('Umur') && int.tryParse(value) == null) return 'Umur harus angka';
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(color: Colors.grey[800]),
          filled: true,
          fillColor: primaryLight.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Tambah Pasien', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ExpansionTile(
                  initiallyExpanded: _isExpandedHewan,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpandedHewan = expanded;
                    });
                  },
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    'Informasi Hewan',
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  children: [
                    buildInputField('Nama Hewan', namaHewanController),
                    buildInputField('Jenis Hewan', jenisHewanController),
                    buildInputField('Warna', warnaController),
                    buildInputField('Umur', umurController, type: TextInputType.number),
                  ],
                ),
                SizedBox(height: 12),
                ExpansionTile(
                  initiallyExpanded: _isExpandedPemilik,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      _isExpandedPemilik = expanded;
                    });
                  },
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: Text(
                    'Informasi Pemilik',
                    style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  children: [
                    buildInputField('Nama Pemilik', namaPemilikController),
                    buildInputField('Alamat', alamatController),
                    buildInputField('No. Telepon', noTelpController, type: TextInputType.phone),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      shadowColor: Colors.pinkAccent.withOpacity(0.3),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final Pasien pasienBaru = Pasien(
                          namaHewan: namaHewanController.text,
                          jenis: jenisHewanController.text,
                          warna: warnaController.text,
                          umur: int.parse(umurController.text),
                          namaPemilik: namaPemilikController.text,
                          alamat: alamatController.text,
                          noTelp: noTelpController.text,
                        );

                        Provider.of<PasienProvider>(context, listen: false).addPasien(pasienBaru);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Pasien berhasil ditambahkan')),
                        );

                        _formKey.currentState!.reset();
                        setState(() {
                          _isExpandedHewan = true;
                          _isExpandedPemilik = false;
                        });
                      }
                    },
                    child: Text('Simpan Pasien', style: GoogleFonts.montserrat(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
