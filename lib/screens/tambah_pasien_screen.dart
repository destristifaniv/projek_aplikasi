import 'package:flutter/material.dart';

class TambahPasienScreen extends StatefulWidget {
  const TambahPasienScreen({super.key});

  @override
  State<TambahPasienScreen> createState() => _TambahPasienScreenState();
}

class _TambahPasienScreenState extends State<TambahPasienScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final namaHewanController = TextEditingController();
  final warnaController = TextEditingController();
  final jenisController = TextEditingController();
  final umurController = TextEditingController();
  final namaPemilikController = TextEditingController();
  final alamatController = TextEditingController();
  final noTelpController = TextEditingController();

  final primaryColor = const Color(0xFFF8A5B3); // Pink pastel
  final secondaryColor = const Color(0xFFFDC4D0); // Pink muda

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  InputDecoration get inputDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.95),
        hintStyle: const TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: secondaryColor.withOpacity(0.4)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Tambah Pasien',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [secondaryColor.withOpacity(0.2), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Informasi Hewan'),
                    TextField(
                        controller: namaHewanController,
                        decoration:
                            inputDecoration.copyWith(hintText: 'Nama Hewan')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: warnaController,
                        decoration: inputDecoration.copyWith(hintText: 'Warna')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: jenisController,
                        decoration: inputDecoration.copyWith(hintText: 'Jenis')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: umurController,
                        decoration: inputDecoration.copyWith(hintText: 'Umur')),
                    const SizedBox(height: 28),
                    _sectionTitle('Informasi Pemilik'),
                    TextField(
                        controller: namaPemilikController,
                        decoration:
                            inputDecoration.copyWith(hintText: 'Nama Pemilik')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: alamatController,
                        decoration: inputDecoration.copyWith(hintText: 'Alamat')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: noTelpController,
                        decoration:
                            inputDecoration.copyWith(hintText: 'Nomor Telepon')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'hewan':
                  '${namaHewanController.text}, Umur ${umurController.text}, ${jenisController.text}, ${warnaController.text}',
              'pemilik':
                  '${namaPemilikController.text}, ${alamatController.text}, ${noTelpController.text}',
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 8,
            shadowColor: Colors.black38,
          ),
          child: const Text(
            'Simpan Data',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }
}
