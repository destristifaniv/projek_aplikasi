import 'package:flutter/material.dart';
import 'pet_characteristics_Input.dart';

class PetSelectionScreen extends StatelessWidget {
  const PetSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Image.asset(
                          'assets/images/pet_snap_logo.png',
                          width: 200,
                        ),
                      ),
                      const SizedBox(height: 60),

                      // Pilihan hewan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 29.0),
                        child: Column(
                          children: [
                            _buildOption(context, 'Kucing'),
                            const SizedBox(height: 30),
                            _buildOption(context, 'Anjing'),
                            const SizedBox(height: 30),
                            _buildOption(context, 'Kelinci'),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Home Indicator
                      Container(
                        width: 134,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, String name) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetCharacteristicsInput(petType: name),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 31.0),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          name,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}