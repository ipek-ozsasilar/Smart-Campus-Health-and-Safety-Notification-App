import 'package:flutter/material.dart';
import 'package:mobil_proje/feature/login/login_screen.dart';
import 'package:mobil_proje/feature/home/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobil_proje/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindMate',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700), // Golden yellow
          surface: Color(0xFF1A1A2E),
          background: Color(0xFF1A1A2E),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

// Kullanıcı giriş durumunu kontrol eden widget
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Yükleniyor durumu
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Kullanıcı giriş yapmışsa (uid varsa) HomeScreen'e git
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Kullanıcı giriş yapmamışsa LogInView'e git
        return const LogInView();
      },
    );
  }
}
