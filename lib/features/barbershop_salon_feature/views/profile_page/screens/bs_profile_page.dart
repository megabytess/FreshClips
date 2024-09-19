import 'package:flutter/material.dart';

class BSProfilePage extends StatefulWidget {
  const BSProfilePage({super.key});

  @override
  State<BSProfilePage> createState() => _BSProfilePageState();
}

class _BSProfilePageState extends State<BSProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barbershop Profile Page'),
      ),
      body: Center(
        child: Text('Welcome to the Barbershop Profile Page!'),
      ),
    );
  }
}
