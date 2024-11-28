import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/widgets/tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class BSUpcomingAppointmetnsPage extends StatelessWidget {
  const BSUpcomingAppointmetnsPage({
    super.key,
    required this.userEmail,
    required this.clientEmail,
    // required this.userType,
  });
  final String userEmail;
  final String clientEmail;
  // final String userType;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        title: Text(
          'Upcoming Appointments',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: BSTabBarPage(
          userEmail: userEmail,
          clientEmail: clientEmail,
          // userType: userType,
        ),
      ),
    );
  }
}
