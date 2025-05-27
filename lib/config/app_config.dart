import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/api';
    } else {
      return 'http://192.168.46.191:8000/api'; // Ganti sesuai IP LAN kamu
    }
  }

  static String get baseUrlStorage {
    if (kIsWeb) {
      return 'http://localhost:8000/storage';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/storage';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:8000/storage';
    } else {
      return 'http://192.168.46.191:8000/storage'; // Ganti sesuai IP LAN kamu
    }
  }
}


// class AppConfig {
//   static String get baseUrl {
//     if (kIsWeb) {
//       // Untuk web (Chrome, Edge)
//       return 'http://localhost:8000/api';
//     } else if (Platform.isAndroid) {
//       // Untuk emulator Android, gunakan IP khusus emulator ke localhost
//       return 'http://10.0.2.2:8000/api';
//     } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       // Untuk desktop Flutter (Windows, Linux, macOS)
//       return 'http://localhost:8000/api';
//     } else {
//       // Untuk iOS atau real device Android
//       return 'http://192.168.46.191:8000/api'; // ⬅️ Ganti dengan IP LAN laptop kamu
//     }
//   }
// }