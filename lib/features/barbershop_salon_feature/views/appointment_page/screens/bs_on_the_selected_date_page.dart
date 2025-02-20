import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // For date formatting

class OnTheDaySchedulePage extends StatelessWidget {
  final String selectedDate; // ISO string for the selected date
  final List<Map<String, dynamic>> appointments; // List of appointments

  const OnTheDaySchedulePage({
    super.key,
    required this.selectedDate,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Parse and format the date
    final parsedDate = DateTime.parse(selectedDate);
    final formattedDate = DateFormat('MMMM d, yyyy').format(parsedDate);

    // Filter approved appointments
    final approvedAppointments = appointments
        .where((appointment) => appointment['status'] == 'approved')
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        title: Text(
          'Today\'s Schedule',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Text(
              formattedDate, // Display the selected date
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
            ),
          ),
          approvedAppointments.isEmpty
              ? Center(
                  child: Text(
                    'No approved appointments for this date.',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: approvedAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = approvedAppointments[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.01,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ScheduleDetailsPage(
                            //         // appointmentDetails: appointment,
                            //         ),
                            //   ),
                            // );
                          },
                          child: Container(
                            width: double.infinity,
                            height: screenHeight * 0.08,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 186, 199, 206),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text(
                                appointment['barberName'], // Barber's name
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                              ),
                              subtitle: Text(
                                '${appointment['startTime']} - ${appointment['endTime']}', // Time range
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
