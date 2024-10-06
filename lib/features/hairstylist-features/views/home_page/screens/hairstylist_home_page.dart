import 'package:flutter/material.dart';

class HairstylistHomePage extends StatefulWidget {
  const HairstylistHomePage({super.key});

  @override
  State<HairstylistHomePage> createState() => _HairstylistHomePageState();
}

class _HairstylistHomePageState extends State<HairstylistHomePage> {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Container(
        child: Center(
          child: Text(
            'Home Page',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
