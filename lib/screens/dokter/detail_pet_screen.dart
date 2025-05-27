import 'package:flutter/material.dart';
import 'package:klinik_hewan/models/pet.dart';
import 'package:klinik_hewan/config/app_config.dart'; // untuk baseUrl

const Color primaryColor = Color(0xFFFF6B9D);
const Color primaryLight = Color(0xFFFFB3D1);
const Color backgroundColor = Color(0xFFFFF5F8);
const Color cardColor = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);

class DetailPetScreen extends StatelessWidget {
  final Pet pet;

  const DetailPetScreen({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Detail Pasien',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar hewan
              if ((pet.foto?.isNotEmpty ?? false))
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    '${AppConfig.baseUrl}/storage/${pet.foto}',
                    height: screenWidth * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: screenWidth * 0.04),

              // Kartu detail
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama dan ikon
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.pets,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Text(
                            pet.nama,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    Divider(color: textSecondary.withOpacity(0.2)),
                    SizedBox(height: screenWidth * 0.02),

                    // Detail tambahan
                    Text(
                      'Jenis: ${pet.jenis}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: textSecondary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Text(
                      'Warna: ${pet.warna}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: textSecondary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Text(
                      'Usia: ${pet.usia} tahun',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: textSecondary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Text(
                      'Kondisi: ${pet.kondisi}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: textSecondary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.03),

                    // Diagnosa
                    Text(
                      'Diagnosa:',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      pet.catatan ?? 'Belum ada diagnosa',
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: pet.catatan != null && pet.catatan!.isNotEmpty ? primaryColor : textSecondary,
                        fontStyle: pet.catatan != null && pet.catatan!.isNotEmpty ? FontStyle.normal : FontStyle.italic,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
