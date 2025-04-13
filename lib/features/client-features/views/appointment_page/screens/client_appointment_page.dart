import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/appointment_page/screens/tab_bar_page.dart/client_tab_bar_page.dart';

class ClientAppointmentPage extends StatefulWidget {
  const ClientAppointmentPage(
      {super.key, required this.userEmail, required this.clientEmail});
  final String userEmail;
  final String clientEmail;

  @override
  ClientAppointmentPageState createState() => ClientAppointmentPageState();
}

class ClientAppointmentPageState extends State<ClientAppointmentPage> {
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
