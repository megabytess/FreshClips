import 'package:flutter/material.dart';

class AdminVerifyPage extends StatefulWidget {
  const AdminVerifyPage({super.key, required this.email});
  final String email;

  @override
  State<AdminVerifyPage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminVerifyPage> {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 248, 248),
      body: const Center(
        child: Text('Verify Page'),
      ),
    );
  }
}
