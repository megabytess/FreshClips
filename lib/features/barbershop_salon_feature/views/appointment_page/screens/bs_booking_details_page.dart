import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/appointment_page/screens/tab_bar_page.dart/rescheduled_page.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/widgets/client_add_review_booking_details.dart';
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
  final String shopName;
  final bool isClient;
  final dynamic selectedAffiliateBarber;
  final String barberImageUrl;

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
    required this.selectedAffiliateBarber,
    required this.shopName,
    required this.barberImageUrl,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

AppointmentsController appointmentsController = AppointmentsController();
BarbershopSalonController barbershopsalonController =
    BarbershopSalonController();

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  // final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final DateTime date = DateTime.now();
  final String formattedDate =
      DateFormat('MMMM dd, yyyy').format(DateTime.now());
  String declinedReason = '';

  @override
  void initState() {
    super.initState();
    fetchDeclineReason();
  }

  Future<void> fetchDeclineReason() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .get();

      if (!snapshot.exists) {
        print('Document does not exist');
        setState(() => declinedReason = 'No reason provided (doc not found)');
        return;
      }

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('declinedReason')) {}

      setState(() {
        if (data.containsKey('declinedReason') &&
            data['declinedReason'] != null) {
          declinedReason = data['declinedReason'];
        } else {
          declinedReason = 'No reason provided';
        }
      });

      print('Final declined reason: $declinedReason');
    } catch (e) {
      print('Error fetching decline reason: $e');
      setState(() => declinedReason = 'Error fetching reason');
    }
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
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          // vertical: screenHeight * 0.01,
          horizontal: screenWidth * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   width: 1.5,
                      // ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Appointment id: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.appointmentId,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
                        ),
                        Gap(screenHeight * 0.015),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appointment status:',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.status,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   width: 1.5,
                      // ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Affiliated shop: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.shopName,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
                        ),
                        Gap(screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              'Selected barber: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            if (widget.barberImageUrl.isNotEmpty)
                              ClipOval(
                                child: Image.network(
                                  widget.barberImageUrl,
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (widget.barberImageUrl.isNotEmpty)
                              Gap(screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                (widget.selectedAffiliateBarber
                                            is Map<String, dynamic> &&
                                        (widget.selectedAffiliateBarber[
                                                    'selectedAffiliateBarber'] ??
                                                '')
                                            .isNotEmpty)
                                    ? widget.selectedAffiliateBarber[
                                        'selectedAffiliateBarber']
                                    : (widget.selectedAffiliateBarber
                                                is String &&
                                            widget.selectedAffiliateBarber
                                                .isNotEmpty)
                                        ? widget.selectedAffiliateBarber
                                        : 'N/A',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   width: 1.5,
                      // ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client information',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 48, 65, 69),
                          ),
                        ),
                        Gap(screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              'Client name: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.clientName,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
                        ),
                        Gap(screenHeight * 0.02),
                        Row(
                          children: [
                            Text(
                              'Phone number: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              widget.phoneNumber,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ],
                        ),
                        Gap(screenHeight * 0.02),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client\'s Note: ',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            Gap(screenHeight * 0.15),
                            Expanded(
                              child: Text(
                                widget.note,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(screenHeight * 0.015),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(20),
                      // border: Border.all(
                      //   width: 1.5,
                      // ),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Details',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 48, 65, 69),
                          ),
                        ),
                        Gap(screenHeight * 0.01),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Service: ',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      widget.selectedServices.map((service) {
                                    final title = service['title'] ?? 'Service';
                                    final description =
                                        service['description'] ??
                                            'No description';

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '$title',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color.fromARGB(
                                                        255, 48, 65, 69),
                                                  ),
                                                ),
                                                Text(
                                                  '$description ',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(
                                flex: 4,
                              ),
                              Text(
                                'P ${widget.price}',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
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
                                'Appointment time:',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.selectedTime,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
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
                                'Appointment date:',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                formattedDate,
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(screenHeight * 0.015),
                  if (widget.status == 'Declined')
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Color.fromARGB(255, 248, 248, 248),
                        borderRadius: BorderRadius.circular(20),
                        // border: Border.all(
                        //   width: 1.5,
                        // ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Declined Reason:',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                          Gap(screenHeight * 0.01),
                          Center(
                            child: Text(
                              declinedReason,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Gap(screenHeight * 0.02),
              if (widget.status == 'Pending' &&
                  widget.clientEmail == widget.userEmail)
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
              if (widget.status == 'Completed' &&
                  widget.clientEmail != widget.userEmail)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientRatingsReviewPage(
                            clientEmail: widget.clientEmail,
                            userEmail: widget.userEmail,
                          ),
                        ),
                      );
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
              if (widget.status == 'Approved' &&
                  widget.userEmail == widget.clientEmail)
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
              if ((widget.status == 'Declined' ||
                      widget.status == 'Approved') &&
                  widget.clientEmail != widget.userEmail)
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
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                        vertical: screenHeight * 0.024,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
