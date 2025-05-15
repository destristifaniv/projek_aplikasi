import 'package:flutter/material.dart';

class ProfilePemilikScreen extends StatelessWidget {
  const ProfilePemilikScreen({super.key});

  void _logout(BuildContext context) {
    // Contoh fungsi logout sederhana
    // TODO: Implementasi logout sesungguhnya, misal clear session, token, dll
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _navigateToChangePassword(BuildContext context) {
    // TODO: Navigasi ke halaman ubah kata sandi
    Navigator.of(context).pushNamed('/change_password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9FA),
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil dengan border dan shadow
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

            // Nama Pemilik
            const Text(
              'cleryn',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            // Email dengan style italic dan warna grey lembut
            Text(
              'cleyrn@example.com',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 10),

            // Nomor HP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Text(
                  '+62 812 3456 7890',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Alamat
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Jl. Mawar No. 123, Lamongan',
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
                    onTap: () {
                      // TODO: Navigasi ke halaman edit profil
                    },
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
