import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sneakers/auth/auth_gate%20.dart';
import 'package:sneakers/auth/login_or_register.dart';
import 'package:sneakers/firebase_options.dart';
import 'package:sneakers/start/login.dart';
import 'package:sneakers/pages/home.dart';
import 'package:sneakers/start/signup.dart'; // Import Firebase options

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShoeHive', // Set the title of the app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // Customize the theme
        useMaterial3: true, // Use Material 3 features
      ),
      home: const AuthGate(),
      debugShowCheckedModeBanner:
          false, // AuthGate widget will decide which screen to show based on auth state
      routes: {
        '/home': (context) => const HomePage(),
        '/AuthGate': (context) => const AuthGate(), // Define route for HomePage
        '/LR': (context) =>
            const LoginOrRegister(), // Define route for HomePage
        '/login': (context) =>
            LoginPage(onTap: () {}), // Define route for LoginPage
        '/signup': (context) =>
            SignUpPage(onTap: () {}), // Define route for SignUpPage
      },
    );
  }
}
