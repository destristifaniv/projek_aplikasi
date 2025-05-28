import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Import screens
import 'screens/welcome_screen.dart';
import 'screens/pemilik/pet_list_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/dokter/home_dokter_screen.dart';
import 'screens/pemilik/home_pemilik_screen.dart';

import 'package:klinik_hewan/screens/pemilik/edit_profile_screen.dart';
import 'package:klinik_hewan/screens/pemilik/change_password_screen.dart';

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
        // Add a general '/login' route that defaults to a sign-in screen.
        // When logging out, we generally want to return to a state where the user
        // can choose their role again or go to a default login.
        // For simplicity, I'm directing it to the 'pemilik' sign-in.
        '/login': (context) => const SignInScreen(role: 'pemilik'), // <--- ADD THIS LINE FOR LOGOUT

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
        // The edit_profile_screen.dart and change_password_screen.dart are pushed
        // using MaterialPageRoute directly from ProfilePemilikScreen, so they
        // don't necessarily need named routes here unless you navigate to them
        // using `Navigator.pushNamed` from other parts of your app.
      },
    );
  }
}