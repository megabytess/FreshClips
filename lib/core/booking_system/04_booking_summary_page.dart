import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingSummaryPage extends StatelessWidget {
  final String userId;
  final String accountName;
  final TimeOfDay selectedTime;
  final String userType;
  final List<Service> selectedServices;
  final DateTime selectedDate;
  final String clientName;
  final String phoneNumber;
  final String note;
  final String title;
  final String description;
  final double price;

  const BookingSummaryPage({
    super.key,
    required this.userId,
    required this.accountName,
    required this.selectedTime,
    required this.userType,
    required this.selectedServices,
    required this.selectedDate,
    required this.clientName,
    required this.phoneNumber,
    required this.note,
    required this.title,
    required this.description,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String formattedDate = DateFormat('MMMM dd, yyyy').format(selectedDate);
    String time = selectedTime.format(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking Summary',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 1,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDetail('Client\'s Name', clientName, screenWidth),
                    buildDetail('Date', formattedDate, screenWidth),
                    buildDetail('Time', time, screenWidth),
                    buildDetail('Phone Number', phoneNumber, screenWidth),
                    buildDetail('Note', note, screenWidth),
                  ],
                ),
              ),
            ),
            Gap(screenHeight * 0.02),
            Text(
              'Selected Services',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(screenHeight * 0.01),
            Expanded(
              child: ListView.builder(
                itemCount: selectedServices.length,
                itemBuilder: (context, index) {
                  final service = selectedServices[index];
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: ListTile(
                      title: Text(
                        service.serviceName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        service.serviceDescription,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                      trailing: Text(
                        'P ${service.price.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle booking confirmation
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
                    'Book appointment',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetail(String title, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
