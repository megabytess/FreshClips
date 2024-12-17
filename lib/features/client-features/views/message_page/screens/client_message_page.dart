import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientMessagePage extends StatefulWidget {
  final String email;

  const ClientMessagePage({super.key, required this.email});

  @override
  ClientMessagePageState createState() => ClientMessagePageState();
}

class ClientMessagePageState extends State<ClientMessagePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          children: [
            Gap(screenHeight * 0.02),
            Center(
              child: Text(
                'Message here',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
