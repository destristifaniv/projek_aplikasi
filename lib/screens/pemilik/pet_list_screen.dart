// pet_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import 'add_pet_screen.dart';
import 'dart:io';

class PetListScreen extends StatelessWidget {
  const PetListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Hewan'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: petProvider.pets.isEmpty
          ? const Center(child: Text('Belum ada data hewan.'))
          : ListView.builder(
              itemCount: petProvider.pets.length,
              itemBuilder: (context, index) {
                final pet = petProvider.pets[index];
                return ListTile(
                  leading: pet['image'] != null && pet['image']!.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(pet['image']!)),
                        )
                      : const CircleAvatar(child: Icon(Icons.pets)),
                  title: Text(pet['name'] ?? ''),
                  subtitle: Text(pet['type'] ?? ''),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: () async {
          final newPet = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetScreen()),
          );

          if (newPet != null && newPet is Map<String, String>) {
            petProvider.addPet(newPet);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
