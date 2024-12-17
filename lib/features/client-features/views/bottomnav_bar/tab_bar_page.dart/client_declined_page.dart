import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientDeclinedPage extends StatelessWidget {
  ClientDeclinedPage({super.key, required this.clientEmail});

  final String clientEmail;
  final bool isClient = true;

  final AppointmentsController appointmentsController =
      AppointmentsController();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('clientEmail', isEqualTo: clientEmail)
            .where('status', isEqualTo: 'Declined')
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
                  'No Declined appointments for today.',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    color: const Color.fromARGB(255, 120, 120, 120),
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
              final clientName = appointment['clientName'];
              // final selectedDate = appointment['selectedDate'];
              final selectedTime = appointment['selectedTime'];
              final totalPrice = appointment['selectedServices']
                  // ignore: avoid_types_as_parameter_names
                  .fold(0, (sum, service) => sum + (service['price'] ?? 0))
                  .toInt();

              // final DateTime date = DateTime.parse(selectedDate);
              // final String formattedDate =
              //     DateFormat('MMMM dd, yyyy').format(date);

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
                        isClient: isClient,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 186, 199, 206),
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.04,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 18, 18, 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ' ${appointment['selectedDate']} ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              ),
                            ),
                            Gap(screenWidth * 0.01),
                            Icon(
                              Icons.circle,
                              size: screenWidth * 0.01,
                              color: const Color.fromARGB(255, 18, 18, 18),
                            ),
                            Gap(screenWidth * 0.01),
                            Text(
                              '$selectedTime',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              ),
                            ),
                            Gap(screenWidth * 0.12),
                            Text(
                              'Declined',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
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
