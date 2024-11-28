import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/screens/client_booking_histsory_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key, required this.clientEmail});

  final String clientEmail;

  @override
  ClientProfilePageState createState() => ClientProfilePageState();
}

class ClientProfilePageState extends State<ClientProfilePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Client Profile Page',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(screenHeight * 0.02),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientBookingHistoryPage(
                        clientEmail: widget.clientEmail,
                        isClient: true,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
                ),
                child: Text(
                  'Booking history',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 248, 248, 248),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
