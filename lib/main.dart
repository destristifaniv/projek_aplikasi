import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'providers/pasien_provider.dart';
import 'providers/pet_provider.dart';
import 'screens/pemilik/pet_list_screen.dart';

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
      ),
      home: const WelcomeScreen(),
    );
  }
}
