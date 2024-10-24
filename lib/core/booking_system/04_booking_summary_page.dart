import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Sample data

    final String clientName = 'John Doe';
    final String date = 'December 25, 2023';
    final String time = '3:00 PM';
    final String serviceTitle = 'Classic Haircut';
    final String serviceDescription = 'A timeless haircut for all ages.';
    final double price = 300;
    final String appointmentNotes = 'Please be on time.';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Booking Summary',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(screenHeight * 0.02),
              Text(
                'Client\'s Name',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                clientName,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Date',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Time',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                time,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.04),
              Text(
                'Service Details',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(screenHeight * 0.02),
              Text(
                'Service Title',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                serviceTitle,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Service Description',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                serviceDescription,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Price',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                'P $price',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.01),
              Text(
                'Appointment Notes',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Text(
                appointmentNotes,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
              Gap(screenHeight * 0.04),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle booking confirmation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
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
      ),
    );
  }
}
