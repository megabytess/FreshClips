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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Upcoming Appointments',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
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
