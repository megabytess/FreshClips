import 'package:flutter/material.dart';

class DeclinedPage extends StatelessWidget {
  const DeclinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Center(
        child: Text(
          'No Declined Appointments',
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
      ),
    );
  }
}
