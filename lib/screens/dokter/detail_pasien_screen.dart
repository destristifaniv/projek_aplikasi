import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/pasien.dart';

const Color primaryColor = Color(0xFFF8A5B3); // Warna pink pastel
const Color primaryLight = Color(0xFFFDC4D0); // Warna pink muda
const Color backgroundColor = Color(0xFFFEE2E4); // Warna latar belakang pink lembut

class DetailPasienScreen extends StatelessWidget {
  final Pasien pasien;

  const DetailPasienScreen({Key? key, required this.pasien}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Detail Pasien',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Informasi Hewan'),
            _buildDetailCard('Nama Hewan', pasien.namaHewan),
            _buildDetailCard('Jenis Hewan', pasien.jenis),
            _buildDetailCard('Warna', pasien.warna),
            _buildDetailCard('Umur', '${pasien.umur} tahun'),
            const SizedBox(height: 30),
            _sectionTitle('Informasi Pemilik'),
            _buildDetailCard('Nama Pemilik', pasien.namaPemilik),
            _buildDetailCard('Alamat', pasien.alamat),
            _buildDetailCard('No. Telepon', pasien.noTelp),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: primaryColor, // Warna untuk judul
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value.isEmpty ? 'Tidak tersedia' : value,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
