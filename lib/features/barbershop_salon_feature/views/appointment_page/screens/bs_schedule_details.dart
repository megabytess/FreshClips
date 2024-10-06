import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ScheduleDetailsPage extends StatelessWidget {
  const ScheduleDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        title: Text(
          'Schedule Details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(screenHeight * 0.02),
            Row(
              children: [
                Container(
                  width: screenWidth * 0.23,
                  height: screenWidth * 0.23,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/icons/logo_icon.png'),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                    Text(
                      '@john_doe', // Replace with actual username
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      '+123 456 7890',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.04),

            // Appointment Details Section
            Text(
              'Appointment Details',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Services, Price, Estimated Time, Date & Time, Client's Note, Booking Status Row
            Column(
              children: [
                buildAppointmentRow(context, 'Service:', 'Haircut & Shave'),
                Gap(screenHeight * 0.01),
                buildAppointmentRow(context, 'Price:', '\$25.00'),
                Gap(screenHeight * 0.01),
                buildAppointmentRow(context, 'Estimated Time:', '45 min'),
                Gap(screenHeight * 0.01),
                buildAppointmentRow(
                    context, 'Date & Time:', 'Oct 5, 2024, 10:00 AM'),
                Gap(screenHeight * 0.01),
                buildAppointmentRow(context, 'Client\'s Note:',
                    'Please trim the beard as well.'),
                Gap(screenHeight * 0.01),
                buildAppointmentRow(context, 'Booking Status:', 'Confirmed'),
              ],
            ),
            Gap(screenHeight * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Reschedule action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Reschedule',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                ),
                Gap(screenWidth * 0.02),
                ElevatedButton(
                  onPressed: () {
                    // Cancel appointment action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                    padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.05),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Cancel Appointment',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a row with title and detail
  Widget buildAppointmentRow(
      BuildContext context, String title, String detail) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
        Gap(screenWidth * 0.02),
        Expanded(
          child: Text(
            detail,
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 48, 65, 69),
            ),
            softWrap: true,
          ),
        )
      ],
    );
  }
}
