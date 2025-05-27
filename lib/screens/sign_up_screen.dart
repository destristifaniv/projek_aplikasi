import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';
import '../config/app_config.dart';
import 'sign_in_screen.dart';
import 'pet_selection_screen.dart';
import 'dokter/home_dokter_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String role;

  const SignUpScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi tidak cocok')),
      );
      return;
    }

    final url = Uri.parse('${AppConfig.baseUrl}/register');

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'nama': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'role': widget.role,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType == null || !contentType.contains('application/json')) {
        throw Exception('Server tidak mengembalikan data JSON');
      }

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Berhasil daftar')),
        );

        final akunId = data['user']['id'].toString();
        final role = data['user']['role'];

        if (role == 'dokter') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeDokterScreen(akunId: int.parse(akunId)),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PetSelectionScreen(akunId: akunId),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Gagal daftar')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;

    final isDokter = widget.role == 'dokter';
    final title = isDokter ? 'Daftar sebagai Dokter' : 'Daftar sebagai Pemilik';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20 : 40,
                        vertical: isSmallScreen ? 20 : 40,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/pet_snap_logo.png',
                              width: isSmallScreen ? 120 : 180,
                              height: isSmallScreen ? 120 : 180,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(title, style: AppTextStyles.heading),
                            ),
                            const SizedBox(height: 12),

                            _buildInput(
                              controller: _usernameController,
                              hint: 'Masukkan Nama Pengguna',
                            ),
                            _buildInput(
                              controller: _emailController,
                              hint: 'Masukkan Email',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            _buildPasswordInput(
                              controller: _passwordController,
                              label: 'Buat Kata Sandi',
                              isVisible: _isPasswordVisible,
                              toggleVisibility: () {
                                setState(() => _isPasswordVisible = !_isPasswordVisible);
                              },
                            ),
                            _buildPasswordInput(
                              controller: _confirmPasswordController,
                              label: 'Ulang Kata Sandi',
                              isVisible: _isConfirmPasswordVisible,
                              toggleVisibility: () {
                                setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                              },
                              onSubmitted: (_) => _register(),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                  shadowColor: Colors.black.withOpacity(0.25),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Daftar', style: AppTextStyles.buttonText),
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Sudah punya akun?', style: AppTextStyles.accountText),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(role: widget.role),
                                      ),
                                    );
                                  },
                                  child: const Text('Masuk', style: AppTextStyles.loginText),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
        decoration: AppInputDecorations.authInputDecoration(hint),
        style: AppTextStyles.inputText,
      ),
    );
  }

  Widget _buildPasswordInput({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    ValueChanged<String>? onSubmitted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            controller: controller,
            obscureText: !isVisible,
            validator: (value) => value == null || value.isEmpty ? 'Tidak boleh kosong' : null,
            decoration: AppInputDecorations.authInputDecoration(label),
            style: AppTextStyles.inputText,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: onSubmitted,
          ),
          IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: toggleVisibility,
          ),
        ],
      ),
    );
  }
}
