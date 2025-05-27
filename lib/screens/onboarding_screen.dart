import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'sign_up_screen.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo + Ilustrasi + Tombol
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/pet_snap_logo.png',
                      width: screenWidth * 0.3,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // Ilustrasi Dokter
                    Image.asset(
                      'assets/images/ilustrasi_dokter.png',
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.35,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // Tombol Register
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke sign up
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUpScreen(role: 'user')
),
                         );
                      },
                      child: Container(
                        width: screenWidth * 0.4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowColor,
                              offset: Offset(0, 4),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Daftar',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Home Indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.black,
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
}
