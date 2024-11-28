import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_upcoming_appointments.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/widgets/calendar_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSAppointmentPage extends StatefulWidget {
  const BSAppointmentPage({
    super.key,
    required this.userEmail,
    required this.clientEmail,
    required this.isClient,
  });
  final String userEmail;
  final String clientEmail;

  final bool isClient;

  @override
  State<BSAppointmentPage> createState() => _BSAppointmentPageState();
}

class _BSAppointmentPageState extends State<BSAppointmentPage> {
  AppointmentsController appointmentsController = AppointmentsController();
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
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.44,
              child: const CalendarPage(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
              ),
              child: Text(
                'Upcoming Appointments',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.01,
                vertical: screenHeight * 0.01,
              ),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BSUpcomingAppointmetnsPage(
                          userEmail: widget.userEmail,
                          clientEmail: widget.clientEmail,
                          // userType: widget.userType,
                        ),
                      ),
                    );
                  },
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                  ),
                  child: Text(
                    'View all appointments',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 248, 248, 248),
                    ),
                  ),
                ),
              ),
            ),
            Gap(screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
              ),
              child: Text(
                'Today\'s Schedule',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('bookedUser', isEqualTo: widget.userEmail)
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
                    child: Text(
                      'No approved appointments for today.',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        color: const Color.fromARGB(255, 120, 120, 120),
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
                    // final selectedDate = appointment['selectedDate'] ?? '';
                    final totalPrice = appointment['selectedServices']
                        // ignore: avoid_types_as_parameter_names
                        .fold(
                            0, (sum, service) => sum + (service['price'] ?? 0))
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
                              clientName:
                                  appointment['clientName'] ?? 'Unknown',
                              phoneNumber: appointment['phoneNumber'] ?? '',
                              selectedDate: appointment['selectedDate'] ?? '',
                              selectedTime: appointment['selectedTime'] ?? '',
                              status: appointment['status'] ?? '',
                              userEmail: appointment['bookedUser'] ?? '',
                              appointmentId: appointment.id,
                              selectedServices:
                                  appointment['selectedServices'] ?? [],
                              note: appointment['note'] ?? '',
                              price: totalPrice,
                              clientEmail: widget.userEmail,
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
                                    '${appointment['selectedDate']} ',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.028,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
                                    ),
                                  ),
                                  Icon(
                                    Icons.circle,
                                    size: screenWidth * 0.01,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                  Gap(screenWidth * 0.01),
                                  Text(
                                    '$selectedTime',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.028,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
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
          ],
        ),
      ),
    );
  }
}
