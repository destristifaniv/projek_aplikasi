import 'package:flutter/material.dart';
import 'tambah_pasien_screen.dart';

// Warna tema pink soft
const Color primaryColor = Color(0xFFF8A5B3); // Pink pastel
const Color primaryLight = Color(0xFFFDc4D0); // Pink muda
const Color backgroundColor = Color(0xFFFEE2E4); // Pink sangat lembut

class HomeDokterScreen extends StatefulWidget {
  const HomeDokterScreen({Key? key}) : super(key: key);

  @override
  State<HomeDokterScreen> createState() => _HomeDokterScreenState();
}

class _HomeDokterScreenState extends State<HomeDokterScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> pasienList = [
    {
      'hewan': 'Kucing, Putih, Anggora, 1 tahun',
      'pemilik': 'Dian, Jl. Veteran No.21, 081122334455',
    },
    {
      'hewan': 'Anjing, Coklat, Husky, 2 tahun',
      'pemilik': 'Rudi, Jl. Melati No.5, 085956784321',
    },
    {
      'hewan': 'Kelinci, Putih, Holland Lop, 5 bulan',
      'pemilik': 'Sari, Jl. Mawar No.10, 081234567890',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSearchBar(),
            const SizedBox(height: 17),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: pasienList.length,
                      itemBuilder: (context, index) {
                        final pasien = pasienList[index];
                        return _buildPasienCard(
                          hewan: pasien['hewan']!,
                          pemilik: pasien['pemilik']!,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildBottomNavBar(context, screenWidth),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  color: primaryColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari pasien...',
                  hintStyle: TextStyle(
                    color: primaryColor.withOpacity(0.5),
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            Icon(Icons.search, size: 20, color: primaryColor.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }

  Widget _buildPasienCard({required String hewan, required String pemilik}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hewan,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Montserrat',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            pemilik,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Montserrat',
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                print("Detail pasien: $hewan - $pemilik");
              },
              child: Text(
                "Lihat Detail",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  color: primaryColor.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navIcon(icon: Icons.home, isActive: true),
            _navIcon(
              icon: Icons.add,
              isCenter: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TambahPasienScreen()),
                );
              },
            ),
            _navIcon(icon: Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _navIcon({
    required IconData icon,
    bool isActive = false,
    bool isCenter = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 26,
        backgroundColor: isCenter ? primaryColor : Colors.white,
        child: Icon(
          icon,
          color: isCenter ? Colors.white : primaryColor.withOpacity(0.7),
          size: 28,
        ),
      ),
    );
  }
}
