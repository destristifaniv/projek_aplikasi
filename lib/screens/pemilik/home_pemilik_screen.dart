import 'package:flutter/material.dart';
import 'package:klinik_hewan/screens/pemilik/profile_pemilik_screen.dart';
import 'package:klinik_hewan/screens/pemilik/pets_screen.dart';

void main() {
  runApp(const HomePemilikScreen());
}

class HomePemilikScreen extends StatelessWidget {
  const HomePemilikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Pemilik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: const Color(0xFFFDF9FA),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade300),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const PetsContent(),
    const ProfileContent(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // FocusNode untuk search bar
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink.shade300,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets_rounded, size: 28),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: _selectedIndex == 2
                    ? Border.all(color: Colors.pink.shade300, width: 2)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  'assets/images/profile.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade400,
                      child: const Icon(Icons.person, color: Colors.white),
                    );
                  },
                ),
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FocusNode _searchFocus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() {
        _isFocused = _searchFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar dengan efek border shadow saat fokus
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: Colors.pink.shade200.withOpacity(0.6),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: TextField(
                focusNode: _searchFocus,
                decoration: InputDecoration(
                  hintText: 'Cari dokter, layanan, atau informasi...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.pink.shade300),
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Fitur Utama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFeatureCard(
                    context, Icons.local_hospital, 'Rekam Medis', Colors.blue.shade100),
                _buildFeatureCard(
                    context, Icons.calendar_month, 'Janji Temu', Colors.green.shade100),
              ],
            ),
            const SizedBox(height: 36),

            const Text(
              'Info Terbaru',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade50, Colors.pink.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade200.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.vaccines_rounded, color: Colors.pink.shade300),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Jangan lupa vaksinasi hewan peliharaan Anda bulan ini! 💉🐶🐱',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, IconData icon, String title, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 2,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.6), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 38, color: Colors.black87),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ],
      ),
    );
  }
}

class PetsContent extends StatelessWidget {
  const PetsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const PetsScreen();
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfilePemilikScreen();
  }
}
