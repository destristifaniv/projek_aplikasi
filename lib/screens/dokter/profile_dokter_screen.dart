import 'package:flutter/material.dart';
import 'package:klinik_hewan/screens/dokter/home_dokter_screen.dart';
import 'package:klinik_hewan/screens/dokter/tambah_pasien_screen.dart';

const Color primaryColor = Color(0xFFF8A5B3); // Pink pastel
const Color primaryLight = Color(0xFFFDc4D0); // Pink muda
const Color secondaryColor = Color(0xFFFDA7C9); // Soft pink accent
const Color backgroundColor = Color(0xFFF3F1F9); // Soft background color

class ProfileDokterScreen extends StatefulWidget {
  @override
  _ProfileDokterScreenState createState() => _ProfileDokterScreenState();
}

class _ProfileDokterScreenState extends State<ProfileDokterScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profil Dokter',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            Expanded(child: Container()), // Spacer untuk BottomNavBar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, screenWidth),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: secondaryColor,
            child: Icon(
              Icons.person,
              size: 70,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Dr. Jane Doe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Dokter Spesialis Hewan',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            indent: 40,
            endIndent: 40,
          ),
          const SizedBox(height: 10),
          const Text(
            'Mengabdi sejak 2010, berpengalaman dalam perawatan hewan kecil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: screenWidth * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeDokterScreen()),
                );
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.home,
                  color: primaryColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => TambahPasienScreen()),
                );
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: primaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Sudah di halaman ini
              },
              child: CircleAvatar(
                radius: 26,
                backgroundColor: secondaryColor,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
