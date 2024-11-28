import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/tab_bar_page.dart/client_tab_bar_page.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientNotificationPage extends StatefulWidget {
  const ClientNotificationPage({
    super.key,
    required this.clientEmail,
  });
  final String clientEmail;

  @override
  State<ClientNotificationPage> createState() => _ClientNotificationPageState();
}

class _ClientNotificationPageState extends State<ClientNotificationPage> {
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
      appointmentDates.clear();
      appointmentDates.addAll(approvedAppointments);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Center(
          child: ClientTabBarPage(
            clientEmail: widget.clientEmail,
          ),
        ),
      ),
    );
  }
}
