import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistReviewPage extends StatefulWidget {
  const HairstylistReviewPage({super.key});

  @override
  State<HairstylistReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<HairstylistReviewPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
          ),
          child: Row(
            children: [
              Text(
                'User reviews',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 45, 65, 69),
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: ClipOval(
                // Profile Picture
                child: Container(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 186, 199, 206),
                  ),
                  child: Image.asset(
                    'assets/images/icons/launcher_icon.png',
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                      ),
                      child: Text(
                        // Profile Name
                        'Sample Name',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(screenWidth * 0.015),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.35,
                      ),
                      child: Text(
                        '4.4', // Sample time
                        style: GoogleFonts.poppins(
                            fontSize: screenHeight * 0.014,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 18, 18, 18)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        left: screenWidth * 0.01,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/profile_page/star.svg',
                        width: screenWidth * 0.035,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Client',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 118, 118, 118),
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.008,
                    bottom: screenHeight * 0.010,
                  ),
                  child: Text(
                    'Sample Description, Simeple Description,\nSimple Description.', // Description
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 18, 18, 18),
                      fontSize: screenWidth * 0.030,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}




 
              // OutlinedButton(
              //   onPressed: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     // builder: (context) => const SignupPage(),
              //     // ),
              //     // );
              //   },
              //   style: OutlinedButton.styleFrom(
              //     side: const BorderSide(
              //       color: Color.fromARGB(255, 45, 65, 69),
              //       width: 1,
              //     ),
              //     padding: EdgeInsets.symmetric(
              //       vertical: screenHeight * 0.001,
              //       horizontal: screenWidth * 0.04,
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //   ),
              //   child: Text(
              //     'write a review',
              //     style: GoogleFonts.poppins(
              //       color: const Color.fromARGB(255, 45, 65, 69),
              //       fontSize: screenWidth * 0.025,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ),