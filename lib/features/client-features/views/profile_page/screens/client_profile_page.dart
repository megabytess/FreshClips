import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_post_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_post_model.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/appointment_page/screens/bs_booking_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/home_page/screens/bs_comments_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/widgets/client_profile_details.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

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
final BSPostController postController = BSPostController();

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
                                  Gap(screenWidth * 0.03),
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
                              SizedBox(height: screenHeight * 0.02),
                              DefaultTabController(
                                length: 2,
                                child: Column(
                                  children: [
                                    TabBar(
                                      labelColor:
                                          const Color.fromARGB(255, 18, 18, 18),
                                      indicatorColor: const Color.fromARGB(
                                          255, 189, 49, 71),
                                      tabs: [
                                        Tab(
                                          child: Text(
                                            'Booking History',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 18, 18, 18),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Timeline',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w600,
                                              color: const Color.fromARGB(
                                                  255, 18, 18, 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.5,
                                      child: TabBarView(
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.4,
                                            child: StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('appointments')
                                                  .where('clientEmail',
                                                      isEqualTo:
                                                          widget.clientEmail)
                                                  .where('status',
                                                      isEqualTo: 'Completed')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Color.fromARGB(
                                                          255, 189, 41, 71),
                                                    ),
                                                  ));
                                                }

                                                if (!snapshot.hasData ||
                                                    snapshot
                                                        .data!.docs.isEmpty) {
                                                  return Center(
                                                    child: Center(
                                                      child: Text(
                                                        'No Appointments for today.',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.035,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              120, 120, 120),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }

                                                final appointments =
                                                    snapshot.data!.docs;
                                                return ListView.builder(
                                                  itemCount:
                                                      appointments.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final appointment =
                                                        appointments[index];

                                                    // final selectedDate = appointment['selectedDate'];
                                                    final selectedTime =
                                                        appointment[
                                                            'selectedTime'];
                                                    final totalPrice = appointment[
                                                            'selectedServices']
                                                        // ignore: avoid_types_as_parameter_names
                                                        .fold(
                                                            0,
                                                            (sum, service) =>
                                                                sum +
                                                                (service[
                                                                        'price'] ??
                                                                    0))
                                                        .toInt();
                                                    final selectedServices =
                                                        appointment[
                                                                'selectedServices']
                                                            .map((service) =>
                                                                service[
                                                                    'title'])
                                                            .join(', ');

                                                    DateTime selectedDate =
                                                        DateFormat(
                                                                'MMMM d, yyyy')
                                                            .parse(appointment[
                                                                'selectedDate']);
                                                    String formattedMonth =
                                                        DateFormat('MMM')
                                                            .format(
                                                                selectedDate)
                                                            .toUpperCase();
                                                    String formattedDay =
                                                        DateFormat('dd').format(
                                                            selectedDate);
                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                BookingDetailsPage(
                                                              clientName:
                                                                  appointment[
                                                                      'clientName'],
                                                              phoneNumber:
                                                                  appointment[
                                                                      'phoneNumber'],
                                                              selectedDate:
                                                                  appointment[
                                                                      'selectedDate'],
                                                              selectedTime:
                                                                  appointment[
                                                                      'selectedTime'],
                                                              status:
                                                                  appointment[
                                                                      'status'],
                                                              userEmail:
                                                                  appointment[
                                                                      'bookedUser'],
                                                              appointmentId:
                                                                  appointment
                                                                      .id,
                                                              selectedServices:
                                                                  appointment[
                                                                      'selectedServices'],
                                                              note: appointment[
                                                                  'note'],
                                                              price: totalPrice,
                                                              clientEmail: widget
                                                                  .clientEmail,
                                                              isClient: widget
                                                                      .isClient ==
                                                                  true,
                                                              selectedAffiliateBarber:
                                                                  appointment[
                                                                          'selectedAffiliateBarber'] ??
                                                                      'N/A',
                                                              shopName: appointment[
                                                                      'shopName'] ??
                                                                  'N/A',
                                                              barberImageUrl:
                                                                  appointment[
                                                                          'barberImageUrl'] ??
                                                                      'N/A',
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          vertical:
                                                              screenHeight *
                                                                  0.01,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 48, 65, 69),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      screenWidth *
                                                                          0.05),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.2),
                                                              spreadRadius: 1,
                                                              blurRadius: 2,
                                                              offset:
                                                                  const Offset(
                                                                      0, 1),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                screenWidth *
                                                                    0.06,
                                                            vertical:
                                                                screenHeight *
                                                                    0.015,
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              // Left Side - Date
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    formattedDay,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.08,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          248,
                                                                          248,
                                                                          248),
                                                                      height: 1,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    formattedMonth,
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                      fontSize:
                                                                          screenWidth *
                                                                              0.04,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          248,
                                                                          248,
                                                                          248),
                                                                      height: 1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Gap(screenWidth *
                                                                  0.08),
                                                              Container(
                                                                width: 1,
                                                                height:
                                                                    screenHeight *
                                                                        0.08,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      248,
                                                                      248,
                                                                      248),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                              Gap(screenWidth *
                                                                  0.15),

                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      height: screenHeight *
                                                                          0.025,
                                                                      width: screenWidth *
                                                                          0.15,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            186,
                                                                            199,
                                                                            206),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            screenWidth *
                                                                                0.02,
                                                                        vertical:
                                                                            screenHeight *
                                                                                0.005,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        appointment[
                                                                            'status'],
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          fontSize:
                                                                              screenWidth * 0.02,
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          color: const Color
                                                                              .fromARGB(
                                                                              255,
                                                                              48,
                                                                              65,
                                                                              69),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Gap(screenHeight *
                                                                        0.01),
                                                                    Row(
                                                                      children: [
                                                                        // Circle
                                                                        Container(
                                                                          width:
                                                                              screenWidth * 0.015,
                                                                          height:
                                                                              screenWidth * 0.015,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                248,
                                                                                248,
                                                                                248),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                        Gap(screenWidth *
                                                                            0.02),
                                                                        // Text
                                                                        Text(
                                                                          'Service: $selectedServices',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                screenWidth * 0.028,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                248,
                                                                                248,
                                                                                248),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Gap(screenHeight *
                                                                        0.01),
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              screenWidth * 0.015,
                                                                          height:
                                                                              screenWidth * 0.015,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                248,
                                                                                248,
                                                                                248),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                        Gap(screenWidth *
                                                                            0.02),
                                                                        Text(
                                                                          'Time: $selectedTime',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                screenWidth * 0.028,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                248,
                                                                                248,
                                                                                248),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
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
                                          StreamBuilder<List<Post>>(
                                            stream: postController
                                                .getSpecificPosts(widget.email),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Color.fromARGB(
                                                          255, 189, 49, 71),
                                                    ),
                                                  ),
                                                );
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return Center(
                                                  child: Text(
                                                    'All posts are displayed here.',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16.0,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              }

                                              final posts = snapshot.data!;

                                              return Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: posts.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final post = posts[index];

                                                    return InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                BSCommentPage(
                                                              email:
                                                                  widget.email,
                                                              postId: post.id,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      screenWidth *
                                                                          0.03,
                                                                  vertical:
                                                                      screenHeight *
                                                                          0.02,
                                                                ),
                                                                child: ClipOval(
                                                                  child:
                                                                      Container(
                                                                    width: 35.0,
                                                                    height:
                                                                        35.0,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          186,
                                                                          199,
                                                                          206),
                                                                    ),
                                                                    child: (post
                                                                            .imageUrl
                                                                            .isNotEmpty)
                                                                        ? Image
                                                                            .network(
                                                                            post.imageUrl,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : const Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                25,
                                                                          ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top: screenHeight *
                                                                              0.02,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          post.authorName ??
                                                                              'Unknown',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                48,
                                                                                65,
                                                                                69),
                                                                            fontSize:
                                                                                screenWidth * 0.035,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Gap(screenWidth *
                                                                          0.02),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top: screenHeight *
                                                                              0.02,
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              screenWidth * 0.01,
                                                                          height:
                                                                              screenHeight * 0.01,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color: Color.fromARGB(
                                                                                100,
                                                                                48,
                                                                                65,
                                                                                69),
                                                                            shape:
                                                                                BoxShape.circle,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Gap(screenWidth *
                                                                          0.015),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(
                                                                          top: screenHeight *
                                                                              0.02,
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          DateFormat('h:mm a')
                                                                              .format(post.datePublished),
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontSize:
                                                                                screenWidth * 0.025,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            color: const Color.fromARGB(
                                                                                100,
                                                                                48,
                                                                                65,
                                                                                69),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Gap(screenWidth *
                                                                          0.2),
                                                                      PopupMenuButton<
                                                                          String>(
                                                                        icon: SvgPicture
                                                                            .asset(
                                                                          'assets/images/profile_page/menu_btn.svg',
                                                                          width:
                                                                              20.0,
                                                                          height:
                                                                              20.0,
                                                                          colorFilter: const ColorFilter
                                                                              .mode(
                                                                              Color.fromARGB(100, 48, 65, 69),
                                                                              BlendMode.srcIn),
                                                                        ),
                                                                        onSelected:
                                                                            (String
                                                                                result) async {
                                                                          if (result ==
                                                                              'Delete') {
                                                                            bool
                                                                                confirmDelete =
                                                                                await showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: Text(
                                                                                    'Delete Post',
                                                                                    style: GoogleFonts.poppins(
                                                                                      fontSize: screenWidth * 0.05,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      color: const Color.fromARGB(255, 48, 65, 69),
                                                                                    ),
                                                                                  ),
                                                                                  content: Text(
                                                                                    'Are you sure you want to delete this post?',
                                                                                    style: GoogleFonts.poppins(
                                                                                      fontSize: screenWidth * 0.035,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      color: const Color.fromARGB(255, 48, 65, 69),
                                                                                    ),
                                                                                  ),
                                                                                  actions: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context, false);
                                                                                      },
                                                                                      child: Text(
                                                                                        'Cancel',
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontSize: screenWidth * 0.035,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.grey[800],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context, true);
                                                                                      },
                                                                                      child: Text(
                                                                                        'Delete',
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontSize: screenWidth * 0.035,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          color: Colors.red,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            );

                                                                            if (confirmDelete) {
                                                                              try {
                                                                                await postController.deletePost(post.id);
                                                                              } catch (e) {
                                                                                print("Error deleting post: $e");
                                                                              }
                                                                            }
                                                                          }
                                                                        },
                                                                        itemBuilder:
                                                                            (BuildContext context) =>
                                                                                <PopupMenuEntry<String>>[
                                                                          PopupMenuItem<
                                                                              String>(
                                                                            value:
                                                                                'Delete',
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                const Icon(
                                                                                  Icons.delete,
                                                                                  color: Color.fromARGB(255, 48, 65, 69),
                                                                                  size: 20.0,
                                                                                ),
                                                                                Gap(screenWidth * 0.02),
                                                                                Text(
                                                                                  'Delete',
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 14.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                    color: const Color.fromARGB(255, 48, 65, 69),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            248,
                                                                            248,
                                                                            248),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20.0),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      top: screenHeight *
                                                                          0.005,
                                                                      bottom:
                                                                          screenHeight *
                                                                              0.01,
                                                                    ),
                                                                    child: Text(
                                                                      post.content,
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            255,
                                                                            48,
                                                                            65,
                                                                            69),
                                                                        fontSize:
                                                                            screenWidth *
                                                                                0.030,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: post.postImageUrl !=
                                                                                null &&
                                                                            post
                                                                                .postImageUrl!.isNotEmpty
                                                                        ? Image
                                                                            .network(
                                                                            post.postImageUrl!,
                                                                            width:
                                                                                screenWidth * 0.75,
                                                                            height:
                                                                                screenHeight * 0.3,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )
                                                                        : const SizedBox
                                                                            .shrink(),
                                                                  ),
                                                                  Gap(screenHeight *
                                                                      0.008),
                                                                  post.tags?.isNotEmpty ==
                                                                          true
                                                                      ? Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                screenWidth * 0.03,
                                                                            vertical:
                                                                                screenHeight * 0.005,
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                217,
                                                                                217,
                                                                                217),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            post.tags!,
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: screenWidth * 0.023,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color.fromARGB(255, 86, 99, 111),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : const SizedBox
                                                                          .shrink(),
                                                                  Gap(screenHeight *
                                                                      0.01),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          LikeButton(
                                                                            size:
                                                                                20,
                                                                            likeCount:
                                                                                post.likedBy.length,
                                                                            isLiked:
                                                                                post.likedBy.contains(widget.email),
                                                                            likeBuilder:
                                                                                (bool isLiked) {
                                                                              return SvgPicture.asset(
                                                                                isLiked ? 'assets/images/profile_page/heart_true.svg' : 'assets/images/profile_page/heart.svg',
                                                                                colorFilter: ColorFilter.mode(
                                                                                  isLiked ? Colors.red : const Color.fromARGB(255, 86, 99, 111),
                                                                                  BlendMode.srcIn,
                                                                                ),
                                                                              );
                                                                            },
                                                                            onTap:
                                                                                (isLiked) async {
                                                                              try {
                                                                                final postId = post.id;
                                                                                if (postId.isNotEmpty) {
                                                                                  await postController.likePost(postId, widget.email);
                                                                                  return !isLiked;
                                                                                } else {
                                                                                  print("Invalid post ID");
                                                                                  return isLiked;
                                                                                }
                                                                              } catch (e) {
                                                                                print("Error updating like status: $e");
                                                                                return isLiked;
                                                                              }
                                                                            },
                                                                          ),
                                                                          Gap(screenHeight *
                                                                              0.02),
                                                                          SvgPicture
                                                                              .asset(
                                                                            'assets/images/profile_page/comment.svg',
                                                                            width:
                                                                                20.0,
                                                                            height:
                                                                                20.0,
                                                                          ),
                                                                          Gap(screenWidth *
                                                                              0.005),
                                                                          StreamBuilder<
                                                                              QuerySnapshot>(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('posts').doc(post.id).collection('comments').snapshots(),
                                                                            builder:
                                                                                (context, snapshot) {
                                                                              int commentCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

                                                                              return Text(
                                                                                '$commentCount',
                                                                                style: GoogleFonts.poppins(
                                                                                  fontSize: 12.0,
                                                                                  color: Colors.grey[500],
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
