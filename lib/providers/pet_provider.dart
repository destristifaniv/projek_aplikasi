import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async'; // For TimeoutException
import 'package:shared_preferences/shared_preferences.dart';
import 'package:klinik_hewan/config/app_config.dart';
import 'package:klinik_hewan/models/pet.dart'; // Import model Pet

class PetProvider with ChangeNotifier {
  List<Pet> _petList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pet> get petList => _petList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    if (_isLoading != value) { // Only notify if state actually changes
      _isLoading = value;
      notifyListeners();
    }
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setErrorMessage(String message) { // Public method to set error
    _setError(message);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // --- REVAMPED: Helper untuk fetch data dari endpoint generik ---
  // Metode ini akan mengembalikan data yang sudah di-unwrap dari kunci 'data'
  // atau langsung list jika responsnya adalah list.
  Future<dynamic> _fetchDataFromEndpoint(String endpoint) async {
    final String? token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please login again.');
    }

    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    print('DEBUG: Fetching data from endpoint: $endpoint');
    print('DEBUG: Request URL: $url');
    print('DEBUG: Token available: ${token.isNotEmpty}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedResponse = jsonDecode(response.body);

        // Kasus 1: Respon adalah objek dengan kunci 'data' yang berisi list (Laravel Resource / API umum)
        if (decodedResponse is Map<String, dynamic> && decodedResponse.containsKey('data')) {
          // Jika 'data' itu sendiri null (misal: {"data": null}), kembalikan list kosong
          return decodedResponse['data'] ?? [];
        }
        // Kasus 2: Respon adalah list langsung (array JSON)
        else if (decodedResponse is List) {
          return decodedResponse;
        }
        // Kasus 3: Respon adalah objek tunggal (bukan list, bukan wrapped list)
        else if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        }
        // Kasus lainnya, format tidak terduga
        else {
          throw Exception('Unexpected response format: ${response.body}');
        }
      } else if (response.statusCode == 404) {
        String message = 'Resource not found.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            message = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(message);
      } else if (response.statusCode == 401) {
          throw Exception('Unauthorized: Invalid or expired token.');
      } else {
        String message = 'Failed to fetch data: ${response.statusCode}.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            message = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(message);
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on TimeoutException {
      throw Exception('Request timed out. Please check your internet connection.');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // --- Metode Fetch untuk Dokter ---

  // Mengambil daftar hewan yang sudah didiagnosa oleh dokter (untuk HomeDokterScreen)
  Future<void> fetchPetsByDiagnosaDokter(int dokterId) async {
    _setLoading(true);
    _setError(null);
    try {
      // Endpoint: GET api/diagnosa-by-dokter/{akunId}
      final data = await _fetchDataFromEndpoint('/diagnosa-by-dokter/$dokterId');

      if (data is List) { // _fetchDataFromEndpoint sudah memastikan ini List atau []
        final Map<int, Pet> petMap = {};
        for (var diagnosaJson in data) {
          if (diagnosaJson is Map<String, dynamic> && diagnosaJson.containsKey('pasien') && diagnosaJson['pasien'] != null) {
            final petJson = diagnosaJson['pasien'] as Map<String, dynamic>;
            petJson['catatan'] = diagnosaJson['catatan'] ?? diagnosaJson['catatan_diagnosa'] ?? '';

            final pet = Pet.fromJson(petJson);
            if (pet.id != null) {
              petMap[pet.id!] = pet;
            }
          }
        }
        _petList = petMap.values.toList();
        print('Successfully fetched ${_petList.length} pets (from diagnoses) for dokter ID: $dokterId');
      } else {
        // Jika _fetchDataFromEndpoint tidak mengembalikan List, ini adalah error format
        throw Exception('Format data tidak sesuai untuk diagnosa berdasarkan dokter. Diharapkan list.');
      }
    } catch (e) {
      print('Error fetching pets (from diagnoses): $e');
      _setError('Gagal memuat data pasien: ${e.toString()}');
      _petList = [];
    } finally {
      _setLoading(false);
    }
  }

  // Mengambil hewan berdasarkan dokter (untuk dropdown di TambahDiagnosaScreen)
  Future<void> fetchPetsByDokter(int dokterId) async {
    _setLoading(true);
    _setError(null);
    try {
      final data = await _fetchDataFromEndpoint('/pets/by-dokter/$dokterId'); // Route GET api/pets/by-dokter/{dokterId}

      if (data is List) { // _fetchDataFromEndpoint sudah memastikan ini List atau []
        _petList = data.map((json) => Pet.fromJson(json)).toList();
        print('Successfully fetched ${_petList.length} pets for dropdown for dokter ID: $dokterId');
      } else {
        throw Exception('Format data tidak sesuai untuk hewan berdasarkan dokter. Diharapkan list.');
      }
    } catch (e) {
      print('Error fetching pets for dropdown: $e');
      _setError('Gagal memuat daftar hewan: ${e.toString()}');
      _petList = [];
    } finally {
      _setLoading(false);
    }
  }

  // --- Metode Fetch untuk Pemilik ---

  // Mengambil daftar hewan berdasarkan ID AKUN PEMILIK (untuk PetsScreen pemilik)
  Future<void> fetchPetsByPemilikAkunId(int akunId) async {
    _setLoading(true);
    _setError(null);

    try {
      final data = await _fetchDataFromEndpoint('/pets/by-pemilik-akun/$akunId'); // Route GET api/pets/by-pemilik-akun/{akun_id}

      if (data is List) { // _fetchDataFromEndpoint sudah memastikan ini List atau []
        _petList = data.map((json) => Pet.fromJson(json)).toList();
        print('Successfully fetched ${_petList.length} pets for owner with Akun ID: $akunId');
      } else {
        throw Exception('Unexpected data format for pets by owner akun ID. Expected a list.');
      }
    } catch (e) {
      print('Error fetching pets for owner: $e');
      _setError('Gagal memuat daftar hewan Anda: ${e.toString()}');
      _petList = [];
    } finally {
      _setLoading(false);
    }
  }

  // --- Metode CRUD umum untuk Pet ---

  // Menambah pet baru
  Future<void> addPet(Pet pet) async {
    _setLoading(true);
    _setError(null);
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }
      final url = Uri.parse('${AppConfig.baseUrl}/pets'); // Route POST api/pets
      print('DEBUG: Add Pet Request URL: $url');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(pet.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final newPet = Pet.fromJson(responseData['data'] ?? responseData);
        print('Successfully added pet: ${newPet.nama}');
      } else {
        String message = 'Failed to add pet: ${response.statusCode}.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            message = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      print('Error adding pet: $e');
      _setError('Gagal menambahkan hewan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Mengupdate pet
  Future<void> updatePet(Pet pet) async {
    _setLoading(true);
    _setError(null);
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }
      final url = Uri.parse('${AppConfig.baseUrl}/pets/${pet.id}'); // Route PUT api/pets/{id}
      print('DEBUG: Update Pet Request URL: $url');
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(pet.toJson()),
      ).timeout(const Duration(seconds: 10));

      print('DEBUG: Update Pet Response status: ${response.statusCode}');
      print('DEBUG: Update Pet Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final updatedPet = Pet.fromJson(responseData['data'] ?? responseData);
        print('Successfully updated pet: ${updatedPet.nama}');
      } else {
        String message = 'Failed to update pet: ${response.statusCode}.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            message = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      print('Error updating pet: $e');
      _setError('Gagal mengedit hewan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Menghapus pet
  Future<void> hapusPet(int petId) async {
    _setLoading(true);
    _setError(null);
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }
      final url = Uri.parse('${AppConfig.baseUrl}/pets/$petId'); // Route DELETE api/pets/{id}
      print('DEBUG: Delete Pet Request URL: $url');
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('DEBUG: Delete Pet Response status: ${response.statusCode}');
      print('DEBUG: Delete Pet Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Successfully deleted pet with ID: $petId');
      } else {
        String message = 'Failed to delete pet: ${response.statusCode}.';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody.containsKey('message')) {
            message = errorBody['message'];
          }
        } catch (_) {}
        throw Exception(message);
      }
    } catch (e) {
      print('Error deleting pet: $e');
      _setError('Gagal menghapus hewan: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
}