import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/assets.dart';
import 'role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  Assets.petSnapLogo,
                  width: screenSize.width * 0.3,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: screenSize.height * 0.03),

                // Ilustrasi Dokter
                Image.asset(
                  'assets/images/ilustrasi_dokter.png',
                  width: screenSize.width * 0.7,
                  height: screenSize.height * 0.3,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: screenSize.height * 0.05),

                // Tombol Mulai
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectionScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink.shade200,  // Tombol dengan warna pastel
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.24,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenSize.height * 0.04), // Spacer bawah agar tidak mentok
              ],
            ),
          ),
        ),
      ),
    );
  }
}
