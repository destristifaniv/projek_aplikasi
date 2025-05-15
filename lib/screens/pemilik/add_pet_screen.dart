import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  String _gender = 'Jantan';
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _savePet() {
  if (_nameController.text.isEmpty || _typeController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nama dan Jenis Hewan wajib diisi')),
    );
    return;
  }

  final newPet = {
    'id': const Uuid().v4(), // ← ini penting agar tiap pet punya ID unik
    'name': _nameController.text,
    'type': _typeController.text,
    'color': _colorController.text,
    'birthdate': _birthdateController.text,
    'gender': _gender,
    'image': _imageFile?.path ?? '',
  };

  Navigator.pop(context, newPet);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Hewan'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
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
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Warna Hewan'),
              ),
              TextField(
                controller: _birthdateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (yyyy-mm-dd)',
                ),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _birthdateController.text =
                        picked.toIso8601String().split('T').first;
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Jantan', 'Betina']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Pilih Gambar dari Galeri'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              if (_imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _imageFile!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
