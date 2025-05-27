import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:klinik_hewan/models/pasien.dart';
import 'package:klinik_hewan/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PasienProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> addPasien(Pasien pasien, int dokterId) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Tambah hewan ke tabel pets
      final petResponse = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/pets'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nama': pasien.namaHewan,
          'jenis': pasien.jenis,
          'warna': pasien.warna,
          'usia': pasien.umur,
          'pemilik_id': 1, // Ganti dengan logika untuk mendapatkan pemilik_id
          'foto': '',
        }),
      );

      if (petResponse.statusCode != 201) {
        throw Exception('Gagal menambahkan hewan: ${petResponse.body}');
      }

      final petData = jsonDecode(petResponse.body);
      final int hewanId = petData['id'];

      // Tambah diagnosa
      final diagnosaResponse = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/dokter/diagnosas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'hewan_id': hewanId,
          'dokter_id': dokterId,
          'tanggal_diagnosa': DateTime.now().toIso8601String().split('T')[0],
          'catatan': 'Pasien baru ditambahkan',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        }),
      );

      if (diagnosaResponse.statusCode != 201) {
        throw Exception('Gagal menambahkan diagnosa: ${diagnosaResponse.body}');
      }
    } catch (e) {
      _setError('Error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
}