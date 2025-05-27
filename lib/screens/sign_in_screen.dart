import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/assets.dart';
import 'dokter/home_dokter_screen.dart';
import 'pemilik/home_pemilik_screen.dart';
import '../config/app_config.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final String role;

  const SignInScreen({Key? key, required this.role}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua field')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/login');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      final responseBody = jsonDecode(response.body);
      print('Login response: ${response.body}');

      if (response.statusCode == 200) {
        final akun = responseBody['data'];
        final int akunId = akun['id'];
        final String role = akun['role'].toString().toLowerCase();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('akun_id', akunId);
        await prefs.setString('role', role);
        await prefs.setString('nama', akun['nama'] ?? '');
        await prefs.setString('email', akun['email'] ?? '');
        await prefs.setString('foto', akun['foto'] ?? '');
        await prefs.setString('alamat', akun['alamat'] ?? '');
        await prefs.setString('noHp', akun['noHp'] ?? '');

        // ✅ Simpan token jika tersedia
        final String? token = responseBody['token'];
        if (token != null && token.isNotEmpty) {
          await prefs.setString('auth_token', token);
          print('Token saved: $token');
        } else {
          print('Token not found in response');
        }

        final message = responseBody['message']?.toString() ?? 'Login berhasil';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );

        if (role == 'dokter') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDokterScreen(akunId: akunId),
            ),
          );
        } else if (role == 'pemilik') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePemilikScreen(akunId: akunId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Role tidak dikenal')),
          );
        }
      } else {
        final message = responseBody['message']?.toString() ?? 'Login gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal koneksi ke server: $e')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAD0D8), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: isTablet ? 40 : 20),
                  Image.asset(
                    Assets.petSnapLogo,
                    width: isTablet ? 160 : 120,
                    height: isTablet ? 160 : 120,
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        color: Color(0xFFEF6C8F),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildInputField(
                    controller: _usernameController,
                    hintText: 'Email',
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _passwordController,
                    hintText: 'Kata Sandi',
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: isTablet ? 200 : 150,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF6C8F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.black.withOpacity(0.2),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(role: widget.role),
                        ),
                      );
                    },
                    child: const Text(
                      'Belum punya akun? Daftar di sini',
                      style: TextStyle(
                        color: Color(0xFFEF6C8F),
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      style: const TextStyle(
        color: Color(0xFF6A4C4C),
        fontSize: 14,
        fontFamily: 'Montserrat',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF6A4C4C),
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFEF6C8F),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xFFEF6C8F),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFEF6C8F),
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
      ),
    );
  }
}
