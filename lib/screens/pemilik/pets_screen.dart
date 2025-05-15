import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_pet_screen.dart';
import 'edit_pet_screen.dart';
import '../../../providers/pet_provider.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  void _navigateToAddPet(BuildContext context) async {
  final newPet = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(builder: (context) => const AddPetScreen()),
  );
  if (newPet != null) {
    Provider.of<PetProvider>(context, listen: false).addPet(newPet);
  }
}

void _navigateToEditPet(BuildContext context, Map<String, dynamic> pet) async {
  final editedPet = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(builder: (context) => EditPetScreen(pet: pet)),
  );
  if (editedPet != null) {
    Provider.of<PetProvider>(context, listen: false).editPet(editedPet);
  }
}


  @override
  Widget build(BuildContext context) {
    final pets = Provider.of<PetProvider>(context).pets;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hewan Saya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: pets.isEmpty
                  ? Center(
                      child: Text(
                        'Belum ada hewan. Tambah hewan baru yuk!',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    )
                  : ListView.builder(
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        final pet = pets[index];
                        final imagePath = pet['image'] ?? '';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imagePath.isNotEmpty
                                  ? Image.file(
                                      File(imagePath),
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.pets, color: Colors.white),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.pets, color: Colors.white),
                                    ),
                            ),
                            title: Text(
                              pet['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              pet['type'] ?? '',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _navigateToEditPet(context, pet);
                                } else if (value == 'delete') {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Konfirmasi Hapus'),
                                      content: Text('Yakin ingin menghapus ${pet['name']}?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Provider.of<PetProvider>(context, listen: false)
                                                .removePet(pet['id']!);
                                            Navigator.of(ctx).pop();
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
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
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
