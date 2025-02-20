import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BSCompletedAppointmentPage extends StatelessWidget {
  const BSCompletedAppointmentPage(
      {super.key,
      required this.clientEmail,
      required this.isClient,
      required this.userEmail});
  final String clientEmail;
  final bool isClient;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('bookedUser', isEqualTo: clientEmail)
            .where('status', isEqualTo: 'Completed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 41, 71),
              ),
            ));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Center(
                child: Text(
                  'Completed appointments will appear here',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            );
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final selectedServices = appointment['selectedServices']
                  .map((service) => service['title'])
                  .join(', ');
              final totalPrice = appointment['selectedServices']
                  .fold(0, (sum, service) => sum + (service['price'] ?? 0))
                  .toInt();

              final selectedTime = appointment['selectedTime'];
              DateTime selectedDate =
                  DateFormat('MMMM d, yyyy').parse(appointment['selectedDate']);
              String formattedMonth =
                  DateFormat('MMM').format(selectedDate).toUpperCase();
              String formattedDay = DateFormat('dd').format(selectedDate);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        clientName: appointment['clientName'],
                        phoneNumber: appointment['phoneNumber'],
                        selectedDate: appointment['selectedDate'],
                        selectedTime: appointment['selectedTime'],
                        status: appointment['status'],
                        userEmail: appointment['bookedUser'],
                        appointmentId: appointment.id,
                        selectedServices: appointment['selectedServices'],
                        note: appointment['note'],
                        price: totalPrice,
                        clientEmail: clientEmail,
                        isClient: isClient == true,
                        selectedAffiliateBarber:
                            appointment['selectedAffiliateBarber'] ?? 'N/A',
                        shopName: appointment['shopName'] ?? 'N/A',
                        barberImageUrl: appointment['barberImageUrl'] ?? 'N/A',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 48, 65, 69),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenHeight * 0.015,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Side - Date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              formattedDay,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.08,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 248, 248, 248),
                                height: 1,
                              ),
                            ),
                            Text(
                              formattedMonth,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w300,
                                color: const Color.fromARGB(255, 248, 248, 248),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        Gap(screenWidth * 0.08),
                        Container(
                          width: 1,
                          height: screenHeight * 0.08,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 248, 248, 248),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Gap(screenWidth * 0.15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: screenHeight * 0.025,
                                width: screenWidth * 0.175,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 186, 199, 206),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.005,
                                ),
                                child: Text(
                                  appointment['status'],
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.02,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        const Color.fromARGB(255, 48, 65, 69),
                                  ),
                                ),
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  // Circle
                                  Container(
                                    width: screenWidth * 0.015,
                                    height: screenWidth * 0.015,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 248, 248, 248),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Gap(screenWidth * 0.02),
                                  // Text
                                  Text(
                                    'Service: $selectedServices',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.028,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 248, 248, 248),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  Container(
                                    width: screenWidth * 0.015,
                                    height: screenWidth * 0.015,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 248, 248, 248),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Gap(screenWidth * 0.02),
                                  Text(
                                    'Time: $selectedTime',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.028,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromARGB(
                                          255, 248, 248, 248),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
