import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/widgets/client_profile_details.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage(
      {super.key,
      required this.email,
      required this.clientEmail,
      required this.isClient});

  final String email;
  final String clientEmail;
  final bool isClient;

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

final ClientController clientController = ClientController();

class _ClientProfilePageState extends State<ClientProfilePage> {
  String? userEmail;
  String? userLocation;

  @override
  void initState() {
    super.initState();
    clientController.fetchClientData(widget.email);
  }

  Future<String?> fetchUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: clientController,
      builder: (context, snapshot) {
        if (clientController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        final client = clientController.client;
        if (client == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 189, 49, 71),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                  width: screenWidth * 0.3,
                                  height: screenWidth * 0.3,
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 186, 199, 206),
                                  ),
                                  child: Image.network(
                                    clientController.client!.imageUrl,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${clientController.client!.firstName} ${clientController.client!.lastName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),
                                Text(
                                  '@${clientController.client!.username}',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),

                                SizedBox(
                                    height: screenHeight *
                                        0.005), // Reduced spacing
                                SizedBox(
                                  width: screenWidth * 0.3,
                                  height: screenHeight * 0.04,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClientProfileDetailsPage(
                                            email: widget.email,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 48, 65, 69),
                                        width: 1,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01,
                                        vertical: screenHeight * 0.01,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      'Edit profile',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Email:',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Text(
                                    clientController.client!.email,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Row(
                                children: [
                                  Text(
                                    'Location:',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: screenWidth * 0.02,
                                      ),
                                      child: Text(
                                        clientController
                                            .client!.location['address'],
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 18, 18, 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Row(
                                children: [
                                  Text(
                                    'Phone number:',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: screenWidth * 0.02,
                                      ),
                                      child: Text(
                                        clientController.client!.phoneNumber,
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 18, 18, 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Booking History',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.4,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('appointments')
                                      .where('clientEmail',
                                          isEqualTo: widget.clientEmail)
                                      .where('status', isEqualTo: 'Completed')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 189, 41, 71),
                                        ),
                                      ));
                                    }

                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                        child: Center(
                                          child: Text(
                                            'No Appointments for today.',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.035,
                                              color: const Color.fromARGB(
                                                  255, 120, 120, 120),
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
                                        final clientName =
                                            appointment['clientName'];
                                        // final selectedDate = appointment['selectedDate'];
                                        final selectedTime =
                                            appointment['selectedTime'];
                                        final totalPrice = appointment[
                                                'selectedServices']
                                            // ignore: avoid_types_as_parameter_names
                                            .fold(
                                                0,
                                                (sum, service) =>
                                                    sum +
                                                    (service['price'] ?? 0))
                                            .toInt();

                                        // final DateTime date = DateTime.parse(selectedDate);
                                        // final String formattedDate =
                                        //     DateFormat('MMMM dd, yyyy').format(date);

                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BookingDetailsPage(
                                                  clientName:
                                                      appointment['clientName'],
                                                  phoneNumber: appointment[
                                                      'phoneNumber'],
                                                  selectedDate: appointment[
                                                      'selectedDate'],
                                                  selectedTime: appointment[
                                                      'selectedTime'],
                                                  status: appointment['status'],
                                                  userEmail:
                                                      appointment['bookedUser'],
                                                  appointmentId: appointment.id,
                                                  selectedServices: appointment[
                                                      'selectedServices'],
                                                  note: appointment['note'],
                                                  price: totalPrice,
                                                  clientEmail:
                                                      widget.clientEmail,
                                                  isClient: widget.isClient,
                                                  selectedAffiliateBarber:
                                                      appointment[
                                                              'selectedAffiliateBarber'] ??
                                                          'N/A',
                                                  shopName:
                                                      appointment['shopName'] ??
                                                          'N/A',
                                                ),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            color: const Color.fromARGB(
                                                255, 186, 199, 206),
                                            margin: EdgeInsets.symmetric(
                                              vertical: screenHeight * 0.01,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  screenWidth * 0.03),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    clientName,
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.04,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 18, 18, 18),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '${appointment['selectedDate']} ',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.028,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 18, 18, 18),
                                                        ),
                                                      ),
                                                      Gap(screenWidth * 0.01),
                                                      Icon(
                                                        Icons.circle,
                                                        size:
                                                            screenWidth * 0.01,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 18, 18, 18),
                                                      ),
                                                      Gap(screenWidth * 0.01),
                                                      Text(
                                                        '$selectedTime',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.028,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 18, 18, 18),
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        'Completed',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.04,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 48, 65, 69),
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
