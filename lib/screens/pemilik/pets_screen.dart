import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:klinik_hewan/models/pet.dart' as models;
import 'package:klinik_hewan/providers/pet_provider.dart';
import 'package:klinik_hewan/screens/pemilik/add_pet_screen.dart';
import 'package:klinik_hewan/screens/pemilik/edit_pet_screen.dart';
import 'package:klinik_hewan/config/app_config.dart'; // Import AppConfig untuk baseUrlStorage

class PetsScreen extends StatefulWidget {
  final int idAkun;
  const PetsScreen({Key? key, required this.idAkun}) : super(key: key);

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetProvider>(context, listen: false).fetchPetsByPemilikAkunId(widget.idAkun);
    });
  }

  void _navigateToAddPet(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddPetScreen(idAkunPemilik: widget.idAkun)), // Pastikan parameter sesuai dengan konstruktor AddPetScreen
    );

    if (result == true) {
      Provider.of<PetProvider>(context, listen: false).fetchPetsByPemilikAkunId(widget.idAkun);
    }
  }

  void _navigateToEditPet(BuildContext context, models.Pet pet) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditPetScreen(pet: pet)),
    );

    if (result == true) {
      Provider.of<PetProvider>(context, listen: false).fetchPetsByPemilikAkunId(widget.idAkun);
    }
  }

  void _confirmDelete(BuildContext context, int petId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus hewan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await Provider.of<PetProvider>(context, listen: false).hapusPet(petId);
              Provider.of<PetProvider>(context, listen: false).fetchPetsByPemilikAkunId(widget.idAkun);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final petProvider = Provider.of<PetProvider>(context);
  final pets = petProvider.petList;

  return Scaffold(
    appBar: AppBar(
      title: const Text('Hewan Saya', style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.pinkAccent,
    ),
    body: petProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : petProvider.errorMessage != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade400, size: 50),
                    const SizedBox(height: 10),
                    Text(petProvider.errorMessage!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                      onPressed: () => petProvider.fetchPetsByPemilikAkunId(widget.idAkun),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hewan Anda',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: pets.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.pets, size: 100, color: Colors.grey.shade300),
                                const SizedBox(height: 20),
                                Text(
                                  'Belum ada hewan terdaftar',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                                ),
                              ],
                            )
                          : ListView.separated(
                              itemCount: pets.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final pet = pets[index];
                                return Material(
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(16),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(12),
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: (pet.foto != null && pet.foto!.isNotEmpty)
                                          ? Image.network(
                                              '${AppConfig.baseUrlStorage}/${pet.foto!}',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  width: 60,
                                                  height: 60,
                                                  color: Colors.grey[200],
                                                  child: const Icon(Icons.broken_image, color: Colors.red),
                                                );
                                              },
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.pink.shade100,
                                              child: const Icon(Icons.pets, color: Colors.white),
                                            ),
                                    ),
                                    title: Text(
                                      pet.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Jenis: ${pet.jenis}'),
                                        Text('Usia: ${pet.usia} tahun'),
                                        if (pet.kondisi?.isNotEmpty == true)
                                          Text('Kondisi: ${pet.kondisi!}'),
                                        if (pet.catatan?.isNotEmpty == true)
                                          Text('Catatan: ${pet.catatan!}'),
                                      ],
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          _navigateToEditPet(context, pet);
                                        } else if (value == 'delete') {
                                          _confirmDelete(context, pet.id!);
                                        }
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                                        PopupMenuItem(value: 'delete', child: Text('Hapus')),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Tambah Hewan',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () => _navigateToAddPet(context),
                    ),
                  ],
                ),
              ),
  );
}
}