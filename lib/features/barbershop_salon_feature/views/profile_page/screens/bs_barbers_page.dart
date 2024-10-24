import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BSBarbersPage extends StatelessWidget {
  const BSBarbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // List of sample barbers with roles
    final List<Map<String, String>> barbers = [
      {"name": "John Doe", "role": "Master Barber"},
      {"name": "Jane Smith", "role": "Stylist"},
      {"name": "Mike Johnson", "role": "Apprentice"},
      {"name": "Alice Brown", "role": "Color Specialist"},
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: ListView.builder(
          itemCount: barbers.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.010,
              ),
              leading: CircleAvatar(
                radius: screenWidth * 0.07,
                backgroundImage: const AssetImage(
                    'assets/images/profile_page/profile_sample.jpg'),
              ),
              title: Text(
                barbers[index]['name']!,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
              ),
              subtitle: Text(
                barbers[index]['role']!,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
