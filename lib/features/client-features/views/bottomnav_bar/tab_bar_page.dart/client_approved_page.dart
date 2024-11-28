import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientApprovedPage extends StatefulWidget {
  const ClientApprovedPage({
    super.key,
    required this.clientEmail,
  });
  final String clientEmail;
  final bool isClient = true;

  @override
  State<ClientApprovedPage> createState() => _ClientApprovedPageState();
}

AppointmentsController appointmentsController = AppointmentsController();

class _ClientApprovedPageState extends State<ClientApprovedPage> {
  final List<Map<String, dynamic>> appointmentDates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApprovedAppointments();
  }

  void fetchApprovedAppointments() async {
    final approvedAppointments =
        await appointmentsController.fetchApprovedAppointments();

    setState(() {
      appointmentDates.addAll(approvedAppointments);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('clientEmail', isEqualTo: widget.clientEmail)
            .where('status', isEqualTo: 'Approved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 41, 71),
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
              ),
              child: Center(
                child: Text(
                  'No approved appointments for today.',
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final clientName = appointment['clientName'] ?? 'Unknown';
              final selectedTime = appointment['selectedTime'] ?? '';
              final totalPrice = appointment['selectedServices']
                  // ignore: avoid_types_as_parameter_names
                  .fold(0, (sum, service) => sum + (service['price'] ?? 0))
                  .toInt();

              //            final DateTime selectedDate = DateTime.now(); // Replace with the actual selected date if available.
              // final String formattedDate = DateFormat('MMMM dd, yyyy').format(selectedDate);

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        clientName: appointment['clientName'] ?? 'Unknown',
                        phoneNumber: appointment['phoneNumber'] ?? '',
                        selectedDate: appointment['selectedDate'] ?? '',
                        selectedTime: appointment['selectedTime'] ?? '',
                        status: appointment['status'] ?? '',
                        userEmail: appointment['bookedUser'] ?? '',
                        appointmentId: appointment.id,
                        selectedServices: appointment['selectedServices'] ?? [],
                        note: appointment['note'] ?? '',
                        price: totalPrice,
                        clientEmail: widget.clientEmail,
                        isClient: widget.isClient,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: const Color.fromARGB(255, 186, 199, 206),
                  margin: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.01,
                    horizontal: screenWidth * 0.02,
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
