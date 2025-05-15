import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PetProvider with ChangeNotifier {
  List<Map<String, dynamic>> _pets = [];

  List<Map<String, dynamic>> get pets => _pets;

  PetProvider() {
    loadPets();
  }

  Future<void> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final petData = prefs.getString('pets');
    if (petData != null) {
      List<dynamic> decoded = jsonDecode(petData);
      // Pastikan decode jadi List<Map<String, dynamic>>
      _pets = decoded.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
      notifyListeners();
    }
  }

  Future<void> savePets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pets', jsonEncode(_pets));
  }

  void addPet(Map<String, dynamic> pet) {
    print("addPet dipanggil dengan id: ${pet['id']}");
    _pets.add(pet);
    savePets();
    notifyListeners();
  }

  void editPet(Map<String, dynamic> pet) {
    int index = _pets.indexWhere((p) => p['id'] == pet['id']);
    if (index != -1) {
      _pets[index] = pet;
      savePets();
      notifyListeners();
    }
  }

  void removePet(String id) {
    _pets.removeWhere((pet) => pet['id'] == id);
    savePets();
    notifyListeners();
  }
}
