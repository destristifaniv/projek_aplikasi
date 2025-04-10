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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 700;
            final isMediumScreen = constraints.maxWidth < 1000;

            final logoSize = isSmallScreen
                ? 140.0
                : isMediumScreen
                    ? 160.0
                    : 180.0;

            final widthFactor = isSmallScreen
                ? 0.5
                : isMediumScreen
                    ? 0.4
                    : 0.35;

            final buttonFontSize = isSmallScreen
                ? 12.0
                : isMediumScreen
                    ? 14.0
                    : 16.0;

            final buttonPadding = EdgeInsets.symmetric(
              horizontal: isSmallScreen
                  ? 20
                  : isMediumScreen
                      ? 24
                      : 30,
              vertical: isSmallScreen
                  ? 10
                  : isMediumScreen
                      ? 12
                      : 14,
            );

            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: FractionallySizedBox(
                          widthFactor: widthFactor,
                          child: Image.asset(
                            Assets.petSnapLogo,
                            width: logoSize,
                            height: logoSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(bottom: screenSize.height * 0.22),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RoleSelectionScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: buttonPadding,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCC8A8A),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            'Mulai',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
            );
          },
        ),
      ),
    );
  }
}
