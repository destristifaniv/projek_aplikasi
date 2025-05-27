import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:klinik_hewan/config/app_config.dart';
import 'package:klinik_hewan/models/diagnosa.dart' as diagnosa_model; // Assuming you have this model
import 'package:klinik_hewan/models/pet.dart';     // Assuming you have this model
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

const Color primaryColor = Color(0xFFF8A5B3);
const Color primaryLight = Color(0xFFFDc4D0);
const Color backgroundColor = Color(0xFFFEE2E4);
const Color accentColor = Color(0xFFFF7096);

class TambahDiagnosaScreen extends StatefulWidget {
  final int akunId;

  const TambahDiagnosaScreen({Key? key, required this.akunId}) : super(key: key);

  @override
  _TambahDiagnosaScreenState createState() => _TambahDiagnosaScreenState();
}

class _TambahDiagnosaScreenState extends State<TambahDiagnosaScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController tanggalDiagnosaController = TextEditingController();
  final TextEditingController catatanController = TextEditingController();
  int? selectedHewanId;
  List<Pet> petList = [];
  bool _isLoading = false;
  String? _fetchError; // To store error messages for fetching pets

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Set tanggal default ke hari ini
    tanggalDiagnosaController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Ambil daftar hewan
    _fetchPets();
  }

  @override
  void dispose() {
    tanggalDiagnosaController.dispose();
    catatanController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchPets() async {
    setState(() {
      _isLoading = true;
      _fetchError = null; // Clear previous error
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Ensure the URL is correct based on your Laravel route list
      // If your route is `api/{panel}/pets/by-dokter/{id}` then it should be:
      // final url = '${AppConfig.baseUrl}/dokter/pets/by-dokter/${widget.akunId}';
      // Assuming 'pets' is your resource name, not 'diagnosas' for fetching pets
      final url = '${AppConfig.baseUrl}/pets/by-dokter/${widget.akunId}'; // Adjust 'dokter' if your panel is different
      print('Fetching pets from: $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status for pets: ${response.statusCode}');
      print('Response body for pets: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is List) { // Check if the response is a List (array)
          setState(() {
            petList = decodedData.map((json) => Pet.fromJson(json)).toList();
          });
        } else if (decodedData is Map<String, dynamic> && decodedData.containsKey('data') && decodedData['data'] is List) {
          // If the response is an object with a 'data' key that is a list
          setState(() {
            petList = (decodedData['data'] as List).map((json) => Pet.fromJson(json)).toList();
          });
        }
        else {
          // Handle cases where 200 OK but response is not a list as expected
          throw Exception('Unexpected response format for pets: ${response.body}');
        }
      } else {
        String errorMsg = 'Failed to load pets. Status: ${response.statusCode}.';
        try {
          final Map<String, dynamic> errorBody = json.decode(response.body);
          if (errorBody.containsKey('message')) {
            errorMsg = errorBody['message'];
          }
        } catch (e) {
          // Fallback if error body is not valid JSON
        }
        throw Exception(errorMsg);
      }
    } catch (e) {
      setState(() {
        _fetchError = 'Error fetching pets: ${e.toString()}';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_fetchError!)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: backgroundColor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        tanggalDiagnosaController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveDiagnosa() async {
    if (_formKey.currentState!.validate()) {
      if (selectedHewanId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih hewan terlebih dahulu')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');
        if (token == null) {
          throw Exception('Authentication token not found. Please login again.');
        }

        final diagnosa = diagnosa_model.Diagnosa(
          hewanId: selectedHewanId!,
          dokterId: widget.akunId,
          tanggalDiagnosa: tanggalDiagnosaController.text,
          catatan: catatanController.text,
        );

        // Ensure this URL is correct for creating a new diagnosis
        // Based on your route list, it might be /api/dokter/diagnosas
        final url = '${AppConfig.baseUrl}/dokter/diagnosas';
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(diagnosa.toJson()),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Diagnosa berhasil ditambahkan')),
          );
          Navigator.pop(context); // Kembali ke screen sebelumnya
        } else {
          String errorMsg = 'Gagal menambahkan diagnosa. Status: ${response.statusCode}.';
          try {
            final Map<String, dynamic> errorBody = json.decode(response.body);
            if (errorBody.containsKey('message')) {
              errorMsg = errorBody['message'];
            }
          } catch (e) {
            // Fallback if error body is not valid JSON
          }
          throw Exception(errorMsg);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget buildInputField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text, bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: type,
                readOnly: readOnly,
                onTap: onTap,
                validator: (value) {
                  if (value == null || value.isEmpty) return '$label tidak boleh kosong';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                  prefixIcon: label.contains('Tanggal')
                      ? const Icon(Icons.calendar_today, color: primaryColor)
                      : const Icon(Icons.note_outlined, color: primaryColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Tambah Diagnosa',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 4,
        shadowColor: accentColor.withOpacity(0.4),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.pets, color: primaryColor, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Pilih Hewan',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: primaryLight.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: _isLoading
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(color: primaryColor),
                                        ),
                                      )
                                    : _fetchError != null // Show error message if fetching failed
                                        ? Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              children: [
                                                Text(_fetchError!, style: TextStyle(color: Colors.red.shade700)),
                                                TextButton(
                                                  onPressed: _fetchPets,
                                                  child: const Text('Coba Lagi', style: TextStyle(color: primaryColor)),
                                                ),
                                              ],
                                            ),
                                          )
                                        : petList.isEmpty && !_isLoading && _fetchError == null // Show empty state if no pets
                                            ? Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Tidak ada hewan ditemukan untuk dokter ini. Pastikan Anda memiliki pasien.',
                                                  style: GoogleFonts.montserrat(color: Colors.grey[600]),
                                                ),
                                              )
                                            : DropdownButtonFormField<int>(
                                                decoration: InputDecoration(
                                                  labelText: 'Nama Hewan',
                                                  labelStyle: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 14),
                                                  prefixIcon: const Icon(Icons.pets, color: primaryColor),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: BorderSide.none,
                                                  ),
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(15),
                                                    borderSide: const BorderSide(color: primaryColor, width: 2),
                                                  ),
                                                ),
                                                value: selectedHewanId,
                                                items: petList.map((pet) {
                                                  return DropdownMenuItem<int>(
                                                    value: pet.id,
                                                    child: Text('${pet.nama} (${pet.jenis}, ${pet.warna})', style: GoogleFonts.montserrat()),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedHewanId = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Mohon pilih hewan';
                                                  }
                                                  return null;
                                                },
                                              ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.medical_services_outlined, color: primaryColor, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              'Detail Diagnosa',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        buildInputField(
                          'Tanggal Diagnosa',
                          tanggalDiagnosaController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                        ),
                        buildInputField(
                          'Catatan Diagnosa',
                          catatanController,
                          type: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: primaryColor))
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 6,
                            shadowColor: accentColor.withOpacity(0.4),
                          ),
                          onPressed: _saveDiagnosa,
                          child: Text(
                            'Simpan Diagnosa',
                            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}