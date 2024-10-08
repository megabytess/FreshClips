import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BSHomePage extends StatelessWidget {
  const BSHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Center(
        child: Text(
          'Home Page',
          style: GoogleFonts.poppins(
            fontSize:
                screenWidth * 0.06, // Text size responsive to screen width
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
