import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:klinik_hewan/config/app_config.dart';

// Warna yang sering digunakan, mungkin bisa di satu file theme.dart
const Color primaryColor = Color(0xFFF8A5B3);
const Color accentColor = Color(0xFFFF7096);

// Hapus PetsScreen dan EditProfileScreen dummy jika sudah di file terpisah
// Asumsi kelas Pet sudah di models/pet.dart, jadi tidak perlu di sini

class ProfilePemilikScreen extends StatefulWidget {
  final String akunId; // akunId di sini adalah ID dari tabel akuns/users

  const ProfilePemilikScreen({super.key, required this.akunId});

  @override
  State<ProfilePemilikScreen> createState() => _ProfilePemilikScreenState();
}

class _ProfilePemilikScreenState extends State<ProfilePemilikScreen> {
  Map<String, dynamic>? profileData; // Akan berisi data akun dan pemilik
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // URL API: api/profil/{id}
      final url = Uri.parse('${AppConfig.baseUrl}/profil/${widget.akunId}');
      print('DEBUG: Fetching profile from: $url');

      final response = await http.get(
        Uri.parse(url.toString()), // Pastikan menggunakan Uri.parse().toString() jika url sudah Uri
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('DEBUG: Profile response status: ${response.statusCode}');
      print('DEBUG: Profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          setState(() {
            profileData = decodedResponse['data'] as Map<String, dynamic>;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected response format: ${response.body}');
        }
      } else {
        String msg = 'Failed to load profile. Status: ${response.statusCode}.';
        try {
          final errorBody = json.decode(response.body);
          if (errorBody.containsKey('message')) {
            msg = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(msg);
      }
    } on Exception catch (e) {
      print('Error loading profile: $e');
      setState(() {
        errorMessage = 'Gagal memuat profil: ${e.toString()}';
        isLoading = false;
        profileData = null;
      });
    }
  }

  void _logout(BuildContext context) {
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.of(context).pushNamed('/change_password');
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(akunId: widget.akunId),
      ),
    ).then((_) {
      loadProfile(); // Refresh data setelah kembali dari EditProfileScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 50),
              const SizedBox(height: 10),
              Text(errorMessage!),
              ElevatedButton(onPressed: loadProfile, child: const Text('Coba Lagi')),
            ],
          ),
        ),
      );
    }

    // Pastikan 'pemilikData' tidak null sebelum mengakses propertinya
    final Map<String, dynamic>? pemilikData = profileData!['pemilik'];

    // Gunakan nilai default jika pemilikData null atau properti di dalamnya null
    // Perhatikan bahwa jika pemilikData itu sendiri null, maka nama, telepon, dan alamat akan menjadi '-'
    final String namaPemilik = pemilikData?['nama'] ?? '-';
    final String emailAkun = profileData!['email'] ?? '-'; // Email selalu dari profileData utama
    final String teleponPemilik = pemilikData?['telepon'] ?? '-';
    final String alamatPemilik = pemilikData?['alamat'] ?? '-';

    // List hewan tidak perlu lagi diakses jika tidak ditampilkan
    // final List<dynamic> hewanList = pemilikData?['pets'] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9FA),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withOpacity(0.6),
                    blurRadius: 12,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              namaPemilik,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              emailAkun,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),

            Text(
              'ID Akun: ${widget.akunId}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Text(
                  teleponPemilik,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    alamatPemilik,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 4,
              shadowColor: Colors.pink.shade100.withOpacity(0.5),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profil',
                    onTap: () => _navigateToEditProfile(context),
                  ),
                  _buildDivider(),
                  _buildProfileMenuItem(
                    icon: Icons.lock,
                    title: 'Ubah Kata Sandi',
                    onTap: () => _navigateToChangePassword(context),
                  ),
                  _buildDivider(),
                  _buildProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Keluar',
                    textColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    onTap: () => _logout(context),
                  ),
                ],
              ),
            ),
            // Hapus bagian "Daftar Hewan Anda" sepenuhnya jika tidak perlu ditampilkan di sini
            // const SizedBox(height: 30), // Anda bisa hapus atau sesuaikan spasi ini

            // Hapus widget PetsScreen atau bagian daftar hewan di sini
            /*
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Hewan Anda',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.pink.shade700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            hewanList.isEmpty
                ? Text(
                    'Tidak ada hewan yang terdaftar untuk akun ini.',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hewanList.length,
                    itemBuilder: (context, index) {
                      final hewan = hewanList[index] as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.pets, size: 18, color: Colors.pink.shade400),
                            const SizedBox(width: 8),
                            Text(
                              '${hewan['nama']} (${hewan['jenis']}, ${hewan['warna']})',
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            */
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, color: iconColor ?? Colors.pink.shade300),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
      onTap: onTap,
      horizontalTitleGap: 4,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey.shade200,
    );
  }
}

// EditProfileScreen (dummy)
class EditProfileScreen extends StatelessWidget {
  final String akunId;

  const EditProfileScreen({super.key, required this.akunId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Pemilik'),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Center(
        child: Text('Halaman Edit Profil untuk pemilik akun: $akunId'),
      ),
    );
  }
}