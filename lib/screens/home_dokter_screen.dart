import 'package:flutter/material.dart';

class HomeDokterScreen extends StatefulWidget {
  const HomeDokterScreen({Key? key}) : super(key: key);

  @override
  State<HomeDokterScreen> createState() => _HomeDokterScreenState();
}

class _HomeDokterScreenState extends State<HomeDokterScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSearchBar(),
            const Spacer(),
            const Text(
              'Data Pasien Kosong',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            _buildBottomNavBar(context),
            const SizedBox(height: 10),
            _buildHomeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Cari pasien...',
                  hintStyle: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                // Aksi ketika ikon search ditekan
                print('Cari: ${_searchController.text}');
              },
              icon: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = 50.0;
    final navBarHeight = 90.0;

    return Container(
      width: screenWidth * 0.9,
      height: navBarHeight,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(204, 138, 138, 0.2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navIcon(icon: Icons.home, isActive: true),
            _navIcon(icon: Icons.add, isCenter: true),
            _navIcon(icon: Icons.person),
          ],
        ),
      ),
    );
  }

  Widget _navIcon({required IconData icon, bool isActive = false, bool isCenter = false}) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: isCenter
          ? const Color(0xFFCC8A8A)
          : Colors.white,
      child: Icon(
        icon,
        color: isCenter
            ? Colors.white
            : const Color(0xFFCC8A8A),
        size: 28,
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Center(
      child: Container(
        width: 134,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
