import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Import screens
import 'screens/welcome_screen.dart';
import 'screens/pemilik/pet_list_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/dokter/home_dokter_screen.dart';
import 'screens/pemilik/home_pemilik_screen.dart';

// Import providers
import 'providers/pasien_provider.dart';
import 'providers/pet_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PasienProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Hewan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),

      // Halaman pertama saat app dibuka
      home: const WelcomeScreen(),

      // Route yang bisa diakses
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/signInPemilik': (context) => const SignInScreen(role: 'pemilik'),
        '/signInDokter': (context) => const SignInScreen(role: 'dokter'),
        '/petList': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final pemilikId = args?['pemilikId'];
          return PetListScreen(pemilikId: pemilikId);
        },
        '/homePemilik': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final akunId = args?['akunId'];
          return HomePemilikScreen(akunId: akunId);
        },
        '/homeDokter': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final akunId = args?['akunId'];
          return HomeDokterScreen(akunId: akunId);
        },
      },
    );
  }
}
