import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/pet_provider.dart';

class EditPetScreen extends StatefulWidget {
  final Map<String, dynamic> pet;

  const EditPetScreen({super.key, required this.pet});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet['name'] ?? '');
    _typeController = TextEditingController(text: widget.pet['type'] ?? '');
    _imageController = TextEditingController(text: widget.pet['image'] ?? '');
  }

  void _updatePet() {
    if (_nameController.text.isEmpty || _typeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Jenis Hewan wajib diisi')),
      );
      return;
    }

    final updatedPet = {
      'id': widget.pet['id'],
      'name': _nameController.text,
      'type': _typeController.text,
      'image': _imageController.text.isNotEmpty
          ? _imageController.text
          : 'assets/images/default_pet.png',
    };

    Provider.of<PetProvider>(context, listen: false).editPet(updatedPet);
    Navigator.pop(context, updatedPet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Hewan'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Hewan'),
            ),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Jenis Hewan'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Path Gambar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _updatePet,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
