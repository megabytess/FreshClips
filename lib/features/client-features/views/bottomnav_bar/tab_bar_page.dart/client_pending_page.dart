import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientPendingPage extends StatelessWidget {
  ClientPendingPage({super.key, required this.clientEmail});
  final String clientEmail;
  final bool isClient = true;

  final AppointmentsController appointmentsController =
      AppointmentsController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('clientEmail', isEqualTo: clientEmail)
            .where('status', isEqualTo: 'Pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 189, 41, 71)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No appointments found for userId: $clientEmail');
            return Center(
              child: Text(
                'No pending appointments for today.',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: const Color.fromARGB(255, 120, 120, 120),
                ),
              ),
            );
          }

          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment =
                  appointments[index].data() as Map<String, dynamic>;

              final clientName = appointment['clientName'] ?? 'Unknown';

              final selectedServices = appointment['selectedServices'] ?? [];
              final totalPrice = (selectedServices is List)
                  ? selectedServices.fold<double>(
                      0,
                      // ignore: avoid_types_as_parameter_names
                      (sum, service) =>
                          sum + ((service['price'] ?? 0) as double))
                  : 0.0;
              final selectedTime = appointment['selectedTime'] ?? 'N/A';

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        clientName: clientName,
                        phoneNumber: appointment['phoneNumber'] ?? 'N/A',
                        selectedDate: appointment['selectedDate'] ?? 'N/A',
                        selectedTime: selectedTime,
                        status: appointment['status'] ?? 'N/A',
                        userEmail: appointment['bookedUser'] ?? 'N/A',
                        appointmentId: appointment['id'] ?? 'N/A',
                        selectedServices: selectedServices,
                        note: appointment['note'] ?? '',
                        price: totalPrice.toInt(),
                        clientEmail: clientEmail,
                        isClient: isClient,
                        selectedAffiliateBarber:
                            appointment['selectedAffiliateBarber'] ?? 'N/A',
                        shopName: appointment['shopName'] ?? 'N/A',
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 186, 199, 206),
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                      horizontal: screenWidth * 0.02),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${appointment['selectedDate'] ?? 'N/A'} ',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.028,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),
                                Gap(screenWidth * 0.01),
                                Icon(
                                  Icons.circle,
                                  size: screenWidth * 0.01,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                                Gap(screenHeight * 0.001),
                                Text(
                                  ' $selectedTime',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.028,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Pending',
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
