import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/pasien.dart';

class PasienProvider with ChangeNotifier {
  List<Pasien> _pasienList = [];

  List<Pasien> get pasienList => _pasienList;

  // Menambahkan pasien baru
  Future<void> addPasien(Pasien pasienBaru) async {
    _pasienList.add(pasienBaru);
    await _savePasienToPrefs();
    notifyListeners();
  }

  // Menghapus pasien berdasarkan nama hewan dan nama pemilik
  void hapusPasienBerdasarkanNama(String namaHewan, String namaPemilik) {
  _pasienList.removeWhere((pasien) =>
      pasien.namaHewan == namaHewan && pasien.namaPemilik == namaPemilik);
  _savePasienToPrefs();
  notifyListeners();
}

  // Memuat data dari SharedPreferences
  Future<void> loadPasienFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final pasienData = prefs.getString('pasienList');
    if (pasienData != null) {
      List<dynamic> decodedData = jsonDecode(pasienData);
      _pasienList = decodedData.map((item) => Pasien.fromJson(item)).toList();
    }
    notifyListeners();
  }

  // Menyimpan data ke SharedPreferences
  Future<void> _savePasienToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final pasienData =
        jsonEncode(_pasienList.map((item) => item.toJson()).toList());
    prefs.setString('pasienList', pasienData);
  }
}
