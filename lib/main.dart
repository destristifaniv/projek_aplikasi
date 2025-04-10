import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Import semua screen yang kamu gunakan
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientasi ke portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
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
      // Ganti halaman awal sesuai kebutuhan:
      // const WelcomeScreen()
      // const RoleSelectionScreen()
      // const SignInScreen()
      // const RegisterScreen()
      home: const WelcomeScreen(),
    );
  }
}
