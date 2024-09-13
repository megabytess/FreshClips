import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientSignupPage extends StatefulWidget {
  const ClientSignupPage({super.key});

  @override
  State<ClientSignupPage> createState() => _ClientSignupPageState();
}

class _ClientSignupPageState extends State<ClientSignupPage> {
  bool obscureText = true;
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          children: [
            Text(
              'Become a Client and Book Your Perfect Haircut!',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
            ),
            Gap(screenHeight * 0.03),
            ClipOval(
              child: Container(
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 186, 199, 206),
                ),
                child: Image.asset(
                  'assets/images/landing_page/background_pic.jpg',
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Gap(screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.43,
                  height: screenHeight * 0.08,
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: const Color.fromARGB(255, 23, 23, 23),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 186, 199, 206),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.03,
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
                Gap(screenWidth * 0.02),
                SizedBox(
                  width: screenWidth * 0.43,
                  height: screenHeight * 0.08,
                  child: TextFormField(
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      color: const Color.fromARGB(255, 23, 23, 23),
                    ),
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 186, 199, 206),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.03,
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
              ],
            ),
            TextFormField(
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.03,
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
            Gap(screenHeight * 0.01),
            TextFormField(
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.03,
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
            Gap(screenHeight * 0.01),
            TextFormField(
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 186, 199, 206),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.03,
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
            Gap(screenHeight * 0.01),
            const Divider(
              color: Color.fromARGB(255, 209, 216, 221),
              thickness: 1,
            ),
            Gap(screenHeight * 0.01),
            TextFormField(
              obscureText: true,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
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
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Adjust the internal height
                  horizontal:
                      screenWidth * 0.03, // Adjust internal width padding
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                ),
              ),
            ),
            Gap(screenHeight * 0.01),
            TextFormField(
              obscureText: true,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                color: const Color.fromARGB(255, 23, 23, 23),
              ),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
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
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // Adjust the internal height
                  horizontal:
                      screenWidth * 0.03, // Adjust internal width padding
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
                      obscureText = !obscureText;
                    });
                  },
                  child: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: const Color.fromARGB(255, 186, 199, 206),
                  ),
                ),
              ),
            ),
            Gap(screenHeight * 0.05),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.07,
              child: FloatingActionButton(
                onPressed: () {
                  // Your action here
                },
                backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    screenWidth * 0.03,
                  ),
                ),
                child: Text(
                  'Signup',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
