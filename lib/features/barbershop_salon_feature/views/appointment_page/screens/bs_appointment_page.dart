import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_schedule.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_upcoming_appointments.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/widgets/calendar_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSAppointmentPage extends StatefulWidget {
  const BSAppointmentPage({super.key});

  @override
  State<BSAppointmentPage> createState() => _BSAppointmentPageState();
}

class _BSAppointmentPageState extends State<BSAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Column(
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
              'Appointment Details',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 18, 18, 18),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.10,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, pageIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnTheDaySchedulePage(),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.19,
                        height: screenHeight * 0.09,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 248, 248, 248),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(255, 48, 65, 69),
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Gap(screenHeight * 0.02),
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
                      builder: (context) => const BSUpcomingAppointmetnsPage(),
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
        ],
      ),
    );
  }
}
