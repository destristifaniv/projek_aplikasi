import 'package:flutter/material.dart';
import 'package:klinik_hewan/screens/pemilik/pets_screen.dart'; // Import PetsScreen
import 'package:klinik_hewan/screens/pemilik/profile_pemilik_screen.dart'; // Import ProfilePemilikScreen
import 'package:google_fonts/google_fonts.dart'; // Untuk font yang konsisten

// Pastikan warna-warna ini konsisten di seluruh aplikasi
const Color primaryColor = Color(0xFFFF6B9D);
const Color primaryLight = Color(0xFFFFB3D1);
const Color backgroundColor = Color(0xFFFFF5F8); // Warna background utama
const Color cardColor = Color(0xFFFFFFFF);
const Color accentColor = Color(0xFFFF8FA3);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);
const Color secondaryColor = Color(0xFFFFA1B5); // Untuk gradient, dll.


// Main Entry Point for Pemilik (biasanya di main.dart, tapi jika ini entry point spesifik pemilik)
class HomePemilikScreen extends StatelessWidget {
  final int akunId;

  const HomePemilikScreen({super.key, required this.akunId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Hewan Pemilik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat', // Menggunakan Montserrat sebagai font default
        scaffoldBackgroundColor: backgroundColor, // Menggunakan warna latar belakang yang konsisten
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor), // Warna utama aplikasi
        useMaterial3: true,
      ),
      home: HomeScreen(akunId: akunId),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final int akunId;

  const HomeScreen({super.key, required this.akunId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  List<Widget> _pages = []; // Deklarasikan sebagai List<Widget>

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Durasi transisi fade
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Inisialisasi _pages di initState
    _pages = [
      HomeContent(akunId: widget.akunId), // Halaman Home/Dashboard
      PetsScreen(idAkun: widget.akunId), // Halaman Daftar Hewan
      ProfilePemilikScreen(akunId: widget.akunId.toString()), // Halaman Profil Pemilik
    ];

    _animationController.forward(); // Mulai animasi saat halaman pertama dimuat
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavBarTapped(int index) {
    if (_selectedIndex != index) { // Hanya update jika indeks berubah
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward(from: 0.0); // Mulai animasi fade dari awal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // Background Scaffold yang konsisten
      body: FadeTransition( // Menerapkan FadeTransition ke konten halaman yang dipilih
        opacity: _fadeAnimation,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar( // BottomNavigationBar standar Anda
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor, // Warna aktif konsisten
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded, size: 28),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Konten Halaman Home/Dashboard yang Diperbarui
class HomeContent extends StatelessWidget {
  final int akunId;
  const HomeContent({super.key, required this.akunId});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04), // Padding responsif
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Selamat Datang dengan Gaya Modern
          Container(
            padding: EdgeInsets.all(screenWidth * 0.05), // Padding lebih besar
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryLight], // Gradient warna primary
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25), // Sudut lebih membulat
              boxShadow: [ // Shadow lebih dalam
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Vertically center content
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang,',
                        style: GoogleFonts.montserrat( // Menggunakan GoogleFonts
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      Text(
                        'Pemilik Hewan!', // Atau bisa ambil nama pemilik jika tersedia di sini
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Kelola hewan kesayangan Anda dengan mudah.',
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.pets,
                  color: Colors.white.withOpacity(0.8),
                  size: screenWidth * 0.12, // Ukuran ikon lebih besar
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.04), // Spasi setelah header

          // Bagian "Fitur Utama" dengan Card interaktif
          Text(
            'Fitur Utama',
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Card untuk navigasi ke PetsScreen
          _buildInteractiveCard(
            context,
            icon: Icons.pets_rounded,
            title: 'Daftar Hewan Anda',
            subtitle: 'Lihat, tambah, edit, dan kelola semua hewan peliharaan Anda.',
            onTap: () {
              final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
              homeScreenState?._onNavBarTapped(1); // Navigasi ke PetsScreen (indeks 1)
            },
            color: primaryColor,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Card untuk navigasi ke ProfilePemilikScreen
          _buildInteractiveCard(
            context,
            icon: Icons.person_rounded,
            title: 'Profil Akun',
            subtitle: 'Perbarui informasi pribadi dan pengaturan akun Anda.',
            onTap: () {
              final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
              homeScreenState?._onNavBarTapped(2); // Navigasi ke ProfilePemilikScreen (indeks 2)
            },
            color: Colors.blueAccent, // Warna berbeda
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.04),

          // Bagian "Informasi & Tips"
          Text(
            'Informasi & Tips',
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.055,
              fontWeight: FontWeight.bold,
              color: textPrimary,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          // Card untuk Tips Perawatan Hewan
          _buildInfoCard(
            context,
            icon: Icons.lightbulb_outline,
            title: 'Tips Perawatan Hewan',
            content: 'Dapatkan tips dan panduan terbaik untuk menjaga kesehatan dan kebahagiaan hewan kesayangan Anda.',
            color: Colors.orangeAccent,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.02),

          // Card untuk Emergency Contact
          _buildInfoCard(
            context,
            icon: Icons.call,
            title: 'Kontak Darurat Klinik',
            content: 'Dapatkan informasi kontak klinik darurat terdekat untuk hewan Anda.',
            color: Colors.teal,
            screenWidth: screenWidth,
          ),
          SizedBox(height: screenHeight * 0.12), // Spasi untuk Bottom Nav Bar
        ],
      ),
    );
  }

  // Widget untuk kartu fitur interaktif (berisi icon, title, subtitle, onTap)
  Widget _buildInteractiveCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Vertically center
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: screenWidth * 0.08),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: screenWidth * 0.035,
                      color: textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: screenWidth * 0.05),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu informasi (tanpa onTap langsung, bisa ada tombol "Baca Selengkapnya" di dalamnya)
  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required double screenWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: screenWidth * 0.08),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.03),
          Text(
            content,
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.035,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          // Tambahkan tombol "Baca Selengkapnya" jika diperlukan
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                // Aksi untuk melihat lebih banyak tips/info
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Membaca lebih lanjut tentang $title')),
                );
              },
              child: Text(
                'Baca Selengkapnya',
                style: GoogleFonts.montserrat(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Kelas PetsContent dan ProfileContent tidak perlu perubahan
class PetsContent extends StatelessWidget {
  final int akunId;
  const PetsContent({super.key, required this.akunId});

  @override
  Widget build(BuildContext context) {
    return PetsScreen(idAkun: akunId);
  }
}

class ProfileContent extends StatelessWidget {
  final int akunId;
  const ProfileContent({super.key, required this.akunId});

  @override
  Widget build(BuildContext context) {
    return ProfilePemilikScreen(akunId: akunId.toString());
  }
}