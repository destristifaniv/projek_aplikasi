import 'package:flutter/material.dart';
import '../widgets/icons/close_icon.dart';
import '../widgets/icons/done_icon.dart';

class PetCharacteristicsInput extends StatefulWidget {
  final String petType;
  final String akunId;  // Tambahan parameter akunId

  const PetCharacteristicsInput({
    Key? key,
    required this.petType,
    required this.akunId,
  }) : super(key: key);

  @override
  State<PetCharacteristicsInput> createState() => _PetCharacteristicsInputState();
}

class _PetCharacteristicsInputState extends State<PetCharacteristicsInput> {
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _petGenderController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _petNameController.dispose();
    _petGenderController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 393),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 56),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const CloseIcon(width: 35, height: 35),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Simpan data jika perlu
                          },
                          child: const DoneIcon(width: 37, height: 37),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    constraints: const BoxConstraints(maxWidth: 306),
                    child: Text(
                      'Write Down The Characteristics Of Your ${widget.petType}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        height: 1.1,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Contoh tampilkan akunId
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Akun ID: ${widget.akunId}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  // Form container
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 375),
                    margin: const EdgeInsets.only(top: 35),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildInputField(_ownerNameController, 'Nama Pemilik'),
                        const SizedBox(height: 20),
                        _buildInputField(_petNameController, 'Nama Hewan'),
                        const SizedBox(height: 20),
                        _buildInputField(_petGenderController, 'Kelamin Hewan'),
                        const SizedBox(height: 20),
                        _buildInputField(_breedController, 'Ras'),
                        const SizedBox(height: 20),
                        _buildInputField(_ageController, 'Umur / Tanggal Lahir'),
                        const SizedBox(height: 20),
                        _buildInputField(_colorController, 'Warna Hewan'),
                      ],
                    ),
                  ),

                  // Save button
                  Container(
                    margin: const EdgeInsets.only(top: 91),
                    child: ElevatedButton(
                      onPressed: () {
                        // Simpan data jika perlu
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCC8A8A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(114, 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        shadowColor: const Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),

                  // Bottom indicator
                  Container(
                    width: 134,
                    height: 5,
                    margin: const EdgeInsets.only(top: 85, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(100),
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

  Widget _buildInputField(TextEditingController controller, String placeholder) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF174666),
          width: 0.5,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Color(0xFF174666),
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Color(0xFF174666),
          fontSize: 14,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}
