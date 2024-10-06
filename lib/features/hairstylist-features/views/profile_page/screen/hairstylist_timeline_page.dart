import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistTimelinePage extends StatefulWidget {
  const HairstylistTimelinePage({super.key});

  @override
  State<HairstylistTimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<HairstylistTimelinePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Gap(screenWidth * 0.02),
                    // Time Icon and Duration
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                      ),
                      child: Container(
                        width: screenWidth * 0.01,
                        height: screenHeight * 0.01,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 118, 118, 118),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Gap(screenWidth * 0.015),
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                      ),
                      child: Text(
                        '23mins', // Sample time
                        style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.032,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(100, 118, 118, 118)),
                      ),
                    ),
                  ],
                ),
                Text(
                  '@sampleusername', // Working Hours
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: screenWidth * 0.75,
                    height: screenHeight * 0.2,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 186, 199, 206),
                    ),
                    child: Image.asset(
                        'assets/images/profile_page/sample_pic.jpg',
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.3,
                        fit: BoxFit.fill),
                  ),
                ),
                Gap(screenHeight * 0.008),
                Container(
                  width: screenWidth * 0.22,
                  height: screenHeight * 0.03,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 217, 217, 217),
                  ),
                  child: Center(
                    child: Text(
                      'Trim Haircut', // Sample Tag
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 86, 99, 111),
                        fontSize: screenWidth * 0.022,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/profile_page/heart.svg',
                            width: screenWidth * 0.023,
                            height: screenHeight * 0.023,
                          ),
                          onPressed: () {
                            // Heart Button
                          },
                        ),
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/images/profile_page/comment.svg',
                            width: screenWidth * 0.023,
                            height: screenHeight * 0.023,
                          ),
                          onPressed: () {
                            // Comment Button
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Container(
          height: screenHeight * 0.0004,
          width: double.infinity,
          color: const Color.fromARGB(255, 209, 216, 221),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
      ],
    );
  }
}
