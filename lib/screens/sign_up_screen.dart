import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'sign_in_screen.dart';
import 'pet_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth <= 640;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Konten Utama
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/pet_snap_logo.png',
                            width: isSmallScreen ? 120 : 180,
                            height: isSmallScreen ? 120 : 180,
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Daftar',
                              style: AppTextStyles.heading,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInput('Masukkan Nama Pengguna'),
                          _buildInput(
                            'Masukkan Email',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          _buildPasswordInput(
                            label: 'Buat Kata Sandi',
                            isVisible: _isPasswordVisible,
                            toggleVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          _buildPasswordInput(
                            label: 'Ulang Kata Sandi',
                            isVisible: _isConfirmPasswordVisible,
                            toggleVisibility: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                // Lanjut ke layar berikutnya
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PetSelectionScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black.withOpacity(0.25),
                              ),
                              child: const Text(
                                'Selanjutnya',
                                style: AppTextStyles.buttonText,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun?',
                                style: AppTextStyles.accountText,
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignInScreen(role: 'pemilik'),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Masuk',
                                  style: AppTextStyles.loginText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Home Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        keyboardType: keyboardType,
        decoration: AppInputDecorations.authInputDecoration(hint),
        style: AppTextStyles.inputText,
      ),
    );
  }

  Widget _buildPasswordInput({
    required String label,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          TextFormField(
            obscureText: !isVisible,
            decoration: AppInputDecorations.authInputDecoration(label),
            style: AppTextStyles.inputText,
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
