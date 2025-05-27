import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:klinik_hewan/models/pet.dart';
import 'package:klinik_hewan/providers/pet_provider.dart';

class EditPetScreen extends StatefulWidget {
  final Pet pet;

  const EditPetScreen({Key? key, required this.pet}) : super(key: key);

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaHewanController;
  late TextEditingController _namaPemilikController;
  late TextEditingController _diagnosaController;
  late TextEditingController _jenisController;
  late TextEditingController _warnaController;  // Tambahan controller warna

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaHewanController = TextEditingController(text: widget.pet.nama);
    _namaPemilikController = TextEditingController(text: widget.pet.pemilikId.toString());
    _diagnosaController = TextEditingController(text: widget.pet.catatan);
    _jenisController = TextEditingController(text: widget.pet.jenis);
    _warnaController = TextEditingController(text: widget.pet.warna);  // Inisialisasi warna
  }

  @override
  void dispose() {
    _namaHewanController.dispose();
    _namaPemilikController.dispose();
    _diagnosaController.dispose();
    _jenisController.dispose();
    _warnaController.dispose();  // Dispose controller warna
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedPet = Pet(
        id: widget.pet.id,
        nama: _namaHewanController.text.trim(),
        pemilikId: int.parse(_namaPemilikController.text.trim()),
        catatan: _diagnosaController.text.trim(),
        jenis: _jenisController.text.trim(),
        warna: _warnaController.text.trim(), // Jangan lupa warna diisi
        usia: widget.pet.usia, // Menambahkan usia dari pet lama
        kondisi: widget.pet.kondisi, // Menambahkan kondisi dari pet lama
        foto: widget.pet.foto, // Menambahkan foto dari pet lama
      );

      await Provider.of<PetProvider>(context, listen: false).updatePet(updatedPet);

      Navigator.pop(context, true); // kembali dengan hasil sukses
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit hewan: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaHewanController,
                decoration: const InputDecoration(labelText: 'Nama Hewan'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _namaPemilikController,
                decoration: const InputDecoration(labelText: 'Nama Pemilik'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  if (int.tryParse(value) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              TextFormField(
                controller: _diagnosaController,
                decoration: const InputDecoration(labelText: 'Diagnosa'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(labelText: 'Jenis'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _warnaController,
                decoration: const InputDecoration(labelText: 'Warna'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Simpan Perubahan'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
