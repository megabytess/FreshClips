import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.05,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
            ),
            child: Text(
              'Welcome back!\nStay Fresh, Stay Confident',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.03,
            ),
            child: TextFormField(
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 23, 23, 23),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 23, 23, 23),
                  ),
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.03,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
            ),
            child: TextFormField(
              obscureText: true,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 23, 23, 23),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 23, 23, 23),
                  ),
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.03,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                ),
              ),
            ),
          ),
          Gap(screenHeight * 0.02),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 23, 23, 23),
                ),
              ),
            ),
          ),
          Gap(screenHeight * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
            ),
            child: SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
