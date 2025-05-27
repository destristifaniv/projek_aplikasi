import 'package:flutter/material.dart';
import 'package:klinik_hewan/screens/dokter/tambah_diagnosa_screen.dart';
import 'package:provider/provider.dart';
import 'package:klinik_hewan/providers/pet_provider.dart';
import 'package:klinik_hewan/models/pet.dart';
import 'package:klinik_hewan/screens/dokter/profile_dokter_screen.dart';
import 'package:klinik_hewan/screens/dokter/detail_pet_screen.dart';

const Color primaryColor = Color(0xFFFF6B9D);
const Color primaryLight = Color(0xFFFFB3D1);
const Color backgroundColor = Color(0xFFFFF5F8);
const Color cardColor = Color(0xFFFFFFFF);
const Color accentColor = Color(0xFFFF8FA3);
const Color textPrimary = Color(0xFF2D3436);
const Color textSecondary = Color(0xFF636E72);
const Color secondaryColor = Color(0xFFFFA1B5);

class HomeDokterScreen extends StatefulWidget {
  final int akunId;

  const HomeDokterScreen({Key? key, required this.akunId}) : super(key: key);

  @override
  State<HomeDokterScreen> createState() => _HomeDokterScreenState();
}

class _HomeDokterScreenState extends State<HomeDokterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    // Ensure fetchPets is called after the context is fully available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPets();
    });
  }

  void _fetchPets() {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    print('Fetching pets for dokterId: ${widget.akunId} at ${DateTime.now()}');
    petProvider.fetchPetsByDiagnosaDokter(widget.akunId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _fetchPets(); // Trigger a refresh when pulling down
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                'Selamat Datang, Dokter!',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Lihat daftar pasien yang sudah didiagnosa',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.white.withOpacity(0.9),
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: screenWidth * 0.07,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                _buildSearchBar(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                Consumer<PetProvider>(
                  builder: (context, petProvider, child) {
                    if (petProvider.isLoading && petProvider.petList.isEmpty) {
                      return _buildLoadingState();
                    }
                    if (petProvider.errorMessage != null && petProvider.petList.isEmpty) {
                      return _buildErrorState(petProvider.errorMessage!);
                    }
                    // Filter hanya hewan yang memiliki diagnosa
                    final filteredPets = petProvider.petList.where((pet) {
                      final searchText = _searchController.text.toLowerCase();
                      final hasDiagnosa = pet.catatan != null && pet.catatan!.isNotEmpty;
                      return hasDiagnosa &&
                          (pet.nama.toLowerCase().contains(searchText) ||
                              pet.jenis.toLowerCase().contains(searchText) ||
                              (pet.catatan?.toLowerCase().contains(searchText) ?? false));
                    }).toList();
                    return filteredPets.isEmpty && !petProvider.isLoading && petProvider.errorMessage == null
                        ? _buildEmptyState()
                        : _buildPetList(filteredPets, screenWidth);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context, screenWidth),
    );
  }

  Widget _buildSearchBar(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: screenWidth * 0.04,
              color: textPrimary,
            ),
            onChanged: (text) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: 'Cari nama, jenis, atau warna hewan...',
              hintStyle: TextStyle(
                color: textSecondary.withOpacity(0.7),
                fontFamily: 'Montserrat',
                fontSize: screenWidth * 0.04,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: primaryColor,
                size: screenWidth * 0.06,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenWidth * 0.04,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat data pasien...',
              style: TextStyle(
                fontSize: 16,
                color: textSecondary,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal memuat data pasien',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textSecondary,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: textSecondary.withOpacity(0.7),
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchPets,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 80,
              color: textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pasien yang didiagnosa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba ubah kata kunci pencarian atau tambahkan diagnosa baru',
              style: TextStyle(
                fontSize: 14,
                color: textSecondary.withOpacity(0.7),
                fontFamily: 'Montserrat',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetList(List<Pet> petList, double screenWidth) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: 16),
      itemCount: petList.length,
      itemBuilder: (context, index) {
        final pet = petList[index];
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildPetCard(pet, index, screenWidth),
        );
      },
    );
  }

  Widget _buildPetCard(Pet pet, int index, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPetScreen(pet: pet),
              ),
            );
            _fetchPets(); // Refresh data after returning from detail screen
          },
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: screenWidth * 0.12,
                      height: screenWidth * 0.12,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [primaryColor, primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: screenWidth * 0.06,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.nama,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Row(
                            children: [
                              Icon(
                                Icons.pets,
                                size: screenWidth * 0.04,
                                color: textSecondary,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                '${pet.jenis} (${pet.warna})',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: textSecondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: screenWidth * 0.04,
                                color: textSecondary,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                'Usia: ${pet.usia} tahun',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: textSecondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: textSecondary),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _confirmHapusPet(pet);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              const SizedBox(width: 8),
                              Text('Hapus'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.04),
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        size: screenWidth * 0.04,
                        color: primaryColor,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Diagnosa: ',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pet.catatan ?? 'Belum ada diagnosa',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: pet.catatan != null && pet.catatan!.isNotEmpty
                                ? primaryColor
                                : textSecondary,
                            fontStyle: pet.catatan != null && pet.catatan!.isNotEmpty
                                ? FontStyle.normal
                                : FontStyle.italic,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPetScreen(pet: pet),
                          ),
                        );
                        _fetchPets(); // Refresh data after returning from detail screen
                      },
                      icon: Icon(Icons.visibility_outlined, size: screenWidth * 0.04),
                      label: Text(
                        'Lihat Detail',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmHapusPet(Pet pet) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: primaryColor, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Konfirmasi Hapus',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus data ${pet.nama}? Tindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: textSecondary,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<PetProvider>(context, listen: false).hapusPet(pet.id!);
                _fetchPets(); // Refresh data after deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar(BuildContext context, double screenWidth) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.05),
      height: screenWidth * 0.18,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
            isActive: true,
            onTap: () {
              _fetchPets();
            },
            screenWidth: screenWidth,
          ),
          _navIcon(
            icon: Icons.add_circle_outline,
            activeIcon: Icons.add_circle,
            isCenter: true,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TambahDiagnosaScreen(akunId: widget.akunId),
                ),
              );
              _fetchPets();
            },
            screenWidth: screenWidth,
          ),
          _navIcon(
            icon: Icons.person_outline,
            activeIcon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileDokterScreen(akunId: widget.akunId),
                ),
              );
            },
            screenWidth: screenWidth,
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
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: isActive || isCenter
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isActive && activeIcon != null ? activeIcon : icon,
          color: Colors.white,
          size: isCenter ? screenWidth * 0.08 : screenWidth * 0.07,
        ),
      ),
    );
  }
}