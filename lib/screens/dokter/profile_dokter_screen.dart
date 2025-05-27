import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:klinik_hewan/screens/dokter/home_dokter_screen.dart';
import 'package:klinik_hewan/screens/dokter/tambah_diagnosa_screen.dart';
import 'package:klinik_hewan/screens/dokter/edit_profile_dokter_screen.dart';
import 'package:klinik_hewan/screens/sign_in_screen.dart';
import 'package:klinik_hewan/config/app_config.dart';

const Color primaryColor = Color(0xFFF8A5B3);
const Color primaryLight = Color(0xFFFDc4D0);
const Color secondaryColor = Color(0xFFFDA7C9);
const Color backgroundColor = Color(0xFFF3F1F9);
const Color gradientStart = Color(0xFFFF9A9E);
const Color gradientEnd = Color(0xFFFECFEF);

class ProfileDokterScreen extends StatefulWidget {
  final int akunId;

  const ProfileDokterScreen({Key? key, required this.akunId}) : super(key: key);

  @override
  _ProfileDokterScreenState createState() => _ProfileDokterScreenState();
}

class _ProfileDokterScreenState extends State<ProfileDokterScreen> {
  String? nama;
  String? email;
  String? alamat;
  String? noHp;
  String? fotoUrl;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  Future<void> getProfile() async {
    final url = Uri.parse('${AppConfig.baseUrl}/dokter-by-akun/${widget.akunId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          nama = data['nama'];
          email = data['email'];
          alamat = data['alamat'];
          noHp = data['no_hp'];

          if (data['foto'] != null && data['foto'].toString().isNotEmpty) {
            fotoUrl = data['foto'].toString().startsWith('http')
                ? data['foto']
                : '${AppConfig.baseUrlStorage}/${data['foto']}';
          } else {
            fotoUrl = null;
          }
        });
      } else {
        setState(() {
          nama = 'Data dokter tidak ditemukan';
          email = '';
        });
      }
    } catch (e) {
      setState(() {
        nama = 'Terjadi kesalahan';
        email = '';
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.logout, color: Colors.red, size: 24),
          ),
          title: const Text('Konfirmasi Logout'),
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen(role: 'dokter')),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(screenHeight),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileCard(),
                const SizedBox(height: 20),
                _buildInfoCards(),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context, screenWidth),
    );
  }

  Widget _buildSliverAppBar(double screenHeight) {
    return SliverAppBar(
      expandedHeight: screenHeight * 0.3,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [gradientStart, gradientEnd],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -30,
                left: -30,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          'Profil Dokter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileDokterScreen(akunId: widget.akunId),
                ),
              ).then((_) => getProfile());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl!) : null,
                  child: fotoUrl == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                  backgroundColor: Colors.grey[200],
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            nama ?? 'Memuat...',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.medical_services, size: 18, color: Colors.black54),
                const SizedBox(width: 6),
                const Text(
                  'Dokter Hewan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards() {
    List<Map<String, dynamic>> infoItems = [];

    if (email != null && email!.isNotEmpty) {
      infoItems.add({
        'icon': Icons.email_outlined,
        'title': 'Email',
        'value': email!,
        'color': Colors.blue,
      });
    }

    if (noHp != null && noHp!.isNotEmpty) {
      infoItems.add({
        'icon': Icons.phone_outlined,
        'title': 'No. Telepon',
        'value': noHp!,
        'color': Colors.green,
      });
    }

    if (alamat != null && alamat!.isNotEmpty) {
      infoItems.add({
        'icon': Icons.location_on_outlined,
        'title': 'Alamat',
        'value': alamat!,
        'color': Colors.orange,
      });
    }

    return Column(
      children: infoItems.map((item) => _buildInfoCard(
            item['icon'],
            item['title'],
            item['value'],
            item['color'],
          )).toList(),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildActionButton(
            icon: Icons.settings_outlined,
            label: 'Pengaturan Akun',
            color: primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileDokterScreen(akunId: widget.akunId),
                ),
              ).then((_) => getProfile());
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            icon: Icons.logout_outlined,
            label: 'Keluar',
            color: Colors.red,
            onPressed: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded( // 👈 Penting agar teks tidak menyebabkan overflow
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navIcon(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomeDokterScreen(akunId: widget.akunId)),
              );
            },
          ),
          _navIcon(
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle,
            isCenter: true,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => TambahDiagnosaScreen(akunId: widget.akunId)),
              );
            },
          ),
          _navIcon(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            isActive: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _navIcon({
    required IconData icon,
    IconData? activeIcon,
    bool isActive = false,
    bool isCenter = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive || isCenter 
              ? Colors.white.withOpacity(0.2) 
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isActive && activeIcon != null ? activeIcon : icon,
          color: Colors.white,
          size: isCenter ? 30 : 26,
        ),
      ),
    );
  }
}