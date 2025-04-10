import 'package:flutter/material.dart';
import '../constants/assets.dart';
import 'sign_in_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;

    // Ukuran disesuaikan agar tetap proporsional
    final double logoWidth = isTablet
        ? screenSize.width * 0.25
        : screenSize.width * 0.45;

    final double buttonWidth = isTablet
        ? screenSize.width * 0.4
        : screenSize.width * 0.7;

    final double buttonPadding = isTablet ? 18 : 14;
    final double buttonFontSize = isTablet ? 18 : 15;
    final double textFontSize = isTablet ? 16 : 14;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      Assets.petSnapLogo,
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 30),

                    // Tulisan "Masuk sebagai:"
                    Text(
                      'Masuk sebagai :',
                      style: TextStyle(
                        fontSize: textFontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Dokter
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(role: 'dokter'),
                            ),
                          );
                        },
                        child: Text(
                          'Dokter',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Tulisan "atau"
                    Text(
                      'atau',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Tombol Pemilik Hewan
                    SizedBox(
                      width: buttonWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(role: 'pemilik'),
                            ),
                          );
                        },
                        child: Text(
                          'Pemilik Hewan',
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Home Indicator
            Positioned(
              bottom: 10,
              left: (screenSize.width / 2) - 67,
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
    );
  }
}
