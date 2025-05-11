import 'package:flutter/material.dart';
import 'sign_in_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateToSignIn(String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;
    final double logoWidth = isTablet
        ? screenSize.width * 0.15  // Mengecilkan ukuran logo untuk tablet
        : screenSize.width * 0.25;  // Mengecilkan ukuran logo untuk ponsel

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFAD0D8), // Pink pastel
              Colors.white, // Putih
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16), // Mengurangi padding untuk ruang yang lebih kompak
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pet_snap_logo.png',
                      width: logoWidth,
                    ),
                    const SizedBox(height: 30), // Mengurangi jarak vertikal
                    const Text(
                      'Pilih Peran Anda',
                      style: TextStyle(
                        fontSize: 20,  // Mengecilkan ukuran teks
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 24), // Mengurangi jarak vertikal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoleCard('Dokter', Icons.medical_services_outlined, Colors.pink.shade300),
                        const SizedBox(width: 16), // Mengurangi jarak antar kartu
                        _buildRoleCard('Pemilik Hewan', Icons.pets, Colors.pink.shade400),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => navigateToSignIn(title),
      child: Container(
        width: 120,  // Mengecilkan lebar kartu
        padding: const EdgeInsets.symmetric(vertical: 16), // Mengecilkan padding vertikal
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),  // Mengecilkan radius border
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,  // Mengecilkan blur pada shadow
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white), // Mengecilkan ukuran ikon
            const SizedBox(height: 8), // Mengurangi jarak antar ikon dan teks
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,  // Mengecilkan ukuran teks
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
