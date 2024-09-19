import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.01,
              ),
              child: Text(
                'Username:',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(100, 18, 18, 18)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.01,
              ),
              child: Text(
                '@snyder',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 18, 18, 18)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.001,
              ),
              child: Text(
                'Email:',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(100, 18, 18, 18)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
              ),
              child: Text(
                'sample@gmail.com',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 18, 18, 18)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.001,
              ),
              child: Text(
                'Location:',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(100, 18, 18, 18)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
              ),
              child: Text(
                'Cebu City, Philippines',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 18, 18, 18)),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.001,
              ),
              child: Text(
                'Skills:',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(100, 18, 18, 18)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
              ),
              child: Text(
                'Sample Skills, Sample Skills, Sample Skills',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                top: screenHeight * 0.001,
              ),
              child: Text(
                'Years of Experience:',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(100, 18, 18, 18)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
              ),
              child: Text(
                '5 years',
                style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 18, 18, 18)),
              ),
            ),
          ],
        ),
        Card(
          color: const Color.fromARGB(255, 255, 255, 255),
          elevation: 3,
          margin: EdgeInsets.all(screenWidth * 0.02),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Services',
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 18, 18, 18),
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  children: List.generate(4, (index) {
                    var serviceImage = [
                      // Service Image
                      Container(
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 186, 199, 206),
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/icons/launcher_icon.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      // Service Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Type ${index + 1}', // Replace with actual service type
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 18, 18, 18),
                                fontSize: screenWidth * 0.030,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Short description of the service ${index + 1}.', // Replace with actual description
                              style: GoogleFonts.poppins(
                                color: const Color.fromARGB(255, 18, 18, 18),
                                fontSize: screenWidth * 0.020,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${(index + 1) * 20}', // Sample price
                                  style: GoogleFonts.poppins(
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                    fontSize: screenWidth * 0.030,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.015),
                                // Time Icon and Duration
                                Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.01,
                                      height: screenWidth * 0.01,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 18, 18, 18),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.015),
                                    Text(
                                      '${index + 1}h', // Sample time
                                      style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.030,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                              50, 18, 18, 18)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ];
                    return Container(
                      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: serviceImage,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
