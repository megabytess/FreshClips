import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:freshclips_capstone/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'FreshClips',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const FreshClips());
}

class FreshClips extends StatelessWidget {
  const FreshClips({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreshClips',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 248, 248, 248),
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 248, 248),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 248, 248, 248),
        ),
      ),
      home: const LandingPage(),
    );
  }
}
