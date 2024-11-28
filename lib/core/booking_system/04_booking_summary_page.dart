import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingSummaryPage extends StatelessWidget {
  final String userEmail;
  // final String accountName;
  final TimeOfDay selectedTime;
  // final String userType;
  final List<Service> selectedServices;
  final DateTime selectedDate;
  final String clientName;
  final String clientEmail;
  // final String username;
  final String phoneNumber;
  final String note;
  final String title;
  final String description;
  final double price;
  final String profileEmail;
  // final bool isClient;

  const BookingSummaryPage({
    super.key,
    required this.userEmail,
    // required this.accountName,
    required this.selectedTime,
    // required this.userType,
    required this.selectedServices,
    required this.selectedDate,
    required this.clientName,
    required this.phoneNumber,
    required this.note,
    required this.title,
    required this.description,
    required this.price,
    required this.profileEmail,
    // required this.isClient,
    // required this.username,
    required this.clientEmail,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String formattedDate = DateFormat('MMMM d, yyyy').format(selectedDate);
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
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
        ),
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
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client\'s Name: ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              clientName,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date: ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              formattedDate,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Time: ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              time,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number: ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              phoneNumber,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note: ',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              note,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  onPressed: () async {
                    // final formattedDate =
                    //     DateFormat('MMMM d, yyyy').format(selectedDate);

                    final formattedTime = selectedTime.format(context);

                    // Proceed with booking
                    final appointmentData = {
                      'bookedUser': userEmail,
                      'clientName': clientName,
                      'phoneNumber': phoneNumber,
                      'selectedTime': formattedTime,
                      'selectedDate': formattedDate,
                      'selectedServices': selectedServices
                          .map((service) => {
                                'title': service.serviceName,
                                'description': service.serviceDescription,
                                'price': service.price,
                              })
                          .toList(),
                      'note': note,
                      'status': 'Pending',
                      'clientEmail': clientEmail,
                    };

                    try {
                      await FirebaseFirestore.instance
                          .collection('appointments')
                          .add(appointmentData);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    } catch (e) {
                      print('Error booking appointment: $e');
                    }
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
}





//  onPressed: () async {
//                     // Format date and time
//                     final formattedDate =
//                         DateFormat('yyyy-MM-dd').format(selectedDate);
//                     final formattedTime = selectedTime.format(context);

//                     // Firestore Query
//                     final appointments = await FirebaseFirestore.instance
//                         .collection('appointments')
//                         .where('bookedUser', isEqualTo: userEmail)
//                         .where('selectedDate', isEqualTo: formattedDate)
//                         .where('selectedTime', isEqualTo: formattedTime)
//                         .get();

//                     // Check if any appointment exists for the given time and date
//                     if (appointments.docs.isNotEmpty) {
//                       // Notify the user that the slot is already booked
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('Time Slot Unavailable'),
//                             content: Text(
//                               'The selected time slot ($formattedTime on $formattedDate) is already booked. Please choose a different time.',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     } else {
//                       // Proceed with booking
//                       final appointmentData = {
//                         'bookedUser': userEmail,
//                         'clientName': clientName,
//                         'phoneNumber': phoneNumber,
//                         'selectedTime': formattedTime,
//                         'selectedDate': formattedDate,
//                         'selectedServices': selectedServices
//                             .map((service) => {
//                                   'title': service.serviceName,
//                                   'description': service.serviceDescription,
//                                   'price': service.price,
//                                 })
//                             .toList(),
//                         'note': note,
//                         'status': 'Pending',
//                       };

//                       try {
//                         await FirebaseFirestore.instance
//                             .collection('appointments')
//                             .add(appointmentData);
//                         Navigator.pop(context);
//                       } catch (e) {
//                         print('Error booking appointment: $e');
//                       }
//                     }
//                   },
