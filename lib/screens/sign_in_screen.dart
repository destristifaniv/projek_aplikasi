import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik_hewan/screens/home_dokter_screen.dart';
import 'package:klinik_hewan/screens/onboarding_screen.dart'; // Pastikan OnboardingScreen diimpor
import '../constants/assets.dart';

class SignInScreen extends StatefulWidget {
  final String role;

  const SignInScreen({Key? key, required this.role}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky, overlays: []);
    
    // Animasi untuk slide, fade, dan scale
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0)  // Animasi skala logo lebih halus
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    
    // Mulai animasi saat layar diinisialisasi
    _animationController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    print('Login sebagai: ${widget.role}');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeDokterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
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
          child: Center( // Center semua elemen di tengah layar
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Menjaga elemen di tengah
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isTablet ? 40 : 20),
                  // Animasi logo dengan scale dan fade lebih halus
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        Assets.petSnapLogo,
                        width: isTablet ? 160 : 120,  // Ukuran logo lebih kecil
                        height: isTablet ? 160 : 120, // Ukuran logo lebih kecil
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Animasi untuk teks 'Masuk'
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Color(0xFFEF6C8F), // Warna pink pastel
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Input Fields dengan animasi fade in
                  _buildInputField(
                    controller: _phoneController,
                    hintText: 'Masukkan nama pengguna',
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Masukkan kata sandi',
                    isPassword: true,
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Tombol Masuk dengan animasi
                  Center(
                    child: SizedBox(
                      width: isTablet ? 200 : 150,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF6C8F), // Warna pink pastel tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.black.withOpacity(0.2),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun?",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OnboardingScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Color(0xFFEF6C8F), // Warna pink pastel untuk Daftar
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi input field dengan animasi fade
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: isPassword ? TextInputType.text : TextInputType.name,
        style: const TextStyle(
          color: Color(0xFF6A4C4C), // Warna teks lebih gelap untuk kontras
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle( // Regular TextStyle without const
            color: Color(0xFF6A4C4C),
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFEF6C8F), // Warna border pink pastel
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0xFFEF6C8F), // Warna border pink pastel saat fokus
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFFEF6C8F),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
