import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/02_date_time_schedule_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingTemplatePage extends StatefulWidget {
  const BookingTemplatePage({super.key});

  @override
  State<BookingTemplatePage> createState() => _BookingTemplatePageState();
}

class _BookingTemplatePageState extends State<BookingTemplatePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'BarberShop Name ni dapat',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Services',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(screenHeight * 0.02),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/icons/launcher_icon.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Gap(screenWidth * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Service Name',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          Text(
                            'Service Description',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.025,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'P 200',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Gap(screenWidth * 0.04),
                              Text(
                                '60 mins',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(50, 18, 18, 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(screenHeight * 0.02),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DateTimeSchedulePage(),
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
                  'Continue',
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
