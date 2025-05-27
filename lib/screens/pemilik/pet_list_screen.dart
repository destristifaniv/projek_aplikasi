import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import 'add_pet_screen.dart';

class PetListScreen extends StatelessWidget {
  final int pemilikId;
  const PetListScreen({Key? key, required this.pemilikId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final pets = petProvider.petList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Hewan'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: petProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
              ? const Center(child: Text('Belum ada data hewan.'))
              : ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (pet.foto != null && pet.foto?.isNotEmpty == true)
                              ? Image.network(
                                  pet.foto!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.pinkAccent.shade100,
                                  child: const Icon(Icons.pets, color: Colors.white),
                                ),
                        ),
                        title: Text(
                          pet.nama,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Jenis: ${pet.jenis}'),
                            Text('Usia: ${pet.usia} tahun'),
                            Text('Kondisi: ${pet.kondisi}'),
                            if (pet.catatan != null && pet.catatan!.isNotEmpty)
                              Text('Diagnosa: ${pet.catatan}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.pinkAccent,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddPetScreen(pemilikId: pemilikId)),
        );
        if (result == true) {
          await petProvider.fetchPetsByPemilikAkunId(pemilikId);
        }
      },
      child: const Icon(Icons.add),
    ),
    );
  }
}
