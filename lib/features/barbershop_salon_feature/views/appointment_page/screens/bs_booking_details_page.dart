import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/tab_bar_page.dart/rescheduled_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingDetailsPage extends StatefulWidget {
  final String clientName;
  final String phoneNumber;
  final List<dynamic> selectedServices;
  final int price;
  final String note;
  final String status;
  final String selectedDate;
  final String selectedTime;
  final String userEmail;
  final String appointmentId;
  final String clientEmail;
  final bool isClient;

  const BookingDetailsPage({
    super.key,
    required this.clientName,
    required this.phoneNumber,
    required this.selectedServices,
    required this.price,
    required this.note,
    required this.selectedDate,
    required this.selectedTime,
    required this.status,
    required this.userEmail,
    required this.appointmentId,
    required this.clientEmail,
    required this.isClient,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

AppointmentsController appointmentsController = AppointmentsController();
BarbershopSalonController barbershopsalonController =
    BarbershopSalonController();

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final DateTime date = DateTime.now();
  final String formattedDate =
      DateFormat('MMMM dd, yyyy').format(DateTime.now());
  String declineReason = '';

  @override
  void initState() {
    super.initState();
    fetchDeclineReason();
  }

  Future<void> fetchDeclineReason() async {
    QuerySnapshot appointmentSnapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('bookedUser', isEqualTo: widget.userEmail)
        .get();

    setState(() {
      if (appointmentSnapshot.docs.isNotEmpty) {
        declineReason = appointmentSnapshot.docs.first['declinedReason'] ??
            'No reason provided';
      } else {
        declineReason = 'No reason provided';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client information',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  Row(
                    children: [
                      Text(
                        'Client name: ',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        widget.clientName,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.042,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ],
                  ),
                  Gap(screenHeight * 0.01),
                  Row(
                    children: [
                      Text(
                        'Phone number: ',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                      Text(
                        widget.phoneNumber,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Gap(40),
              Text(
                'Appointment Details',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedServices.map((service) {
                          final title = service['title'] ?? 'Service';
                          final description =
                              service['description'] ?? 'No description';

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$title',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromARGB(
                                            255, 18, 18, 18),
                                      ),
                                    ),
                                    Text(
                                      '$description ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        'P ${widget.price}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        widget.selectedTime,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client\'s Note: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        widget.note,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Status: ',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: Text(
                        widget.status,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(screenHeight * 0.01),
              if (widget.status == 'Declined')
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.04,
                        top: screenHeight * 0.02,
                        right: screenWidth * 0.04,
                        bottom: screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Declined Reason:',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Gap(screenHeight * 0.01),
                          Center(
                            child: Text(
                              declineReason,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Gap(screenHeight * 0.04),
              if (widget.status != 'Completed' &&
                  widget.status != 'Pending' &&
                  widget.status != 'Approved' &&
                  widget.status != 'Declined')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      appointmentsController.completeAppointment(
                        context,
                        widget.appointmentId,
                        widget.userEmail,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.024,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Leave a review',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                    ),
                  ),
                ),
              Gap(screenHeight * 0.04),
              if (widget.status == 'Approved' ||
                  widget.status != 'Declined' &&
                      widget.status != 'Pending' &&
                      widget.status != 'Completed')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      appointmentsController.completeAppointment(
                        context,
                        widget.appointmentId,
                        widget.userEmail,
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.024,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Complete appointment',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                    ),
                  ),
                ),
              Gap(screenHeight * 0.02),
              if (widget.status == 'Declined' || widget.status == 'Approved')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RescheduledPage(
                            clientName: widget.clientName,
                            phoneNumber: widget.phoneNumber,
                            selectedServices: widget.selectedServices,
                            price: widget.price,
                            note: widget.note,
                            status: widget.status,
                            selectedDate: widget.selectedDate,
                            selectedTime: widget.selectedTime,
                            userEmail: widget.userEmail,
                            appointmentId: widget.appointmentId,
                            clientEmail: widget.clientEmail,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.024,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Reschedule',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
                    ),
                  ),
                ),
              Gap(screenHeight * 0.02),
              if (widget.status == 'Approved' ||
                  widget.status != 'Declined' &&
                      widget.status != 'Pending' &&
                      widget.status != 'Completed')
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      appointmentsController.declineAppointment(
                        context,
                        widget.appointmentId,
                        widget.userEmail,
                      );
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.024,
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(20),
                      //   side: const BorderSide(
                      //     color: Color.fromARGB(255, 48, 65, 69),
                      //     width: 2,
                      //   ),
                      // ),
                    ),
                    child: Text(
                      'Cancel appointment',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ),
              if (widget.status == 'Pending')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.43,
                      child: ElevatedButton(
                        onPressed: () async {
                          appointmentsController.approveAppointment(
                            context,
                            widget.appointmentId,
                            widget.userEmail,
                          );

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 189, 49, 71),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Approve',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 248, 248, 248),
                          ),
                        ),
                      ),
                    ),
                    Gap(screenHeight * 0.01),
                    SizedBox(
                      width: screenWidth * 0.43,
                      child: ElevatedButton(
                        onPressed: () {
                          appointmentsController.declineAppointment(
                            context,
                            widget.appointmentId,
                            widget.userEmail,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 48, 65, 69),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Decline',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 248, 248, 248),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
