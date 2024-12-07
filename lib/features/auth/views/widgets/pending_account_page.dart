import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/landing_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingAccountPage extends StatelessWidget {
  const PendingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.05,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Account Pending Verification!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 45, 65, 69),
              ),
            ),
            Gap(screenHeight * 0.02),
            Text(
              'Your account is currently waiting for admin verification. '
              'Our team is reviewing your account. You will be notified once the verification is completed.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                color: Colors.grey[700],
              ),
            ),
            Gap(screenHeight * 0.1),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 45, 65, 69),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.02,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LandingPage(),
                    ),
                  );
                },
                child: Text(
                  'Back to home',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
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
