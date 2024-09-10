import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/auth/views/screens/login/login_page.dart';
import 'package:freshclips_capstone/features/auth/views/screens/signup/signup_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/landing_page/background_pic.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/landing_page/freshclips_logo.svg',
                height: screenHeight * 0.20,
                width: screenWidth * 0.3,
              ),
              Gap(
                screenHeight * 0.45,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                child: Text(
                  'Empowering Barbers, Simplifying Haircuts.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w800,
                    color: const Color.fromARGB(255, 48, 65, 69),
                  ),
                ),
              ),
              Gap(
                screenHeight * 0.10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.07,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 189, 49, 70),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                    horizontal: screenWidth * 0.09),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: screenWidth * 0.040,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.4,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 45, 65, 69),
                                  width: 1,
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Signup',
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 45, 65, 69),
                                  fontSize: screenWidth * 0.040,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: screenHeight * 0.02), // Space below the buttons
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
