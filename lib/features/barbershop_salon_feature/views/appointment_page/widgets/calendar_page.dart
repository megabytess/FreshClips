import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_upcoming_appointments.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage(
      {super.key, required this.userEmail, required this.clientEmail});
  final String userEmail;
  final String clientEmail;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDay = DateTime.now();

  Stream<int> getPendingAppointmentsCount(String userEmail) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('bookedUser', isEqualTo: userEmail)
        .where('status', isEqualTo: 'Pending')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(
        screenWidth * 0.01,
        screenHeight * 0.01,
        screenWidth * 0.01,
        screenHeight * 0.01,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.03,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE').format(DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.032,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 48, 65, 69),
                      height: 1,
                    ),
                  ),
                  // Year
                  Text(
                    DateFormat('dd').format(DateTime.now()),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.15,
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Text(
                    DateFormat('MMMM').format(DateTime.now()).toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 48, 65, 69),
                      height: 0.1,
                    ),
                  ),
                ],
              ),
              Gap(screenWidth * 0.13),
              Container(
                width: 1,
                height: screenHeight * 0.12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Gap(screenWidth * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder<int>(
                    stream: getPendingAppointmentsCount(widget.userEmail),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          '...',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.1,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 48, 65, 69),
                            height: 1,
                          ),
                        );
                      }

                      int countPending = snapshot.data ?? 0;
                      String pendingCount =
                          NumberFormat("00").format(countPending);

                      return Text(
                        pendingCount,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.1,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 48, 65, 69),
                          height: 1,
                        ),
                      );
                    },
                  ),
                  Text(
                    ' Pending \n Appointments',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.025,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  SizedBox(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.03,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BSUpcomingAppointmetnsPage(
                              userEmail: widget.userEmail,
                              clientEmail: widget.clientEmail,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 189, 49, 71),
                        ),
                        backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.006,
                        ),
                      ),
                      child: Text(
                        'View details',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.02,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
