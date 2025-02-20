import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/hairstylist_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/services_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_services/add_services_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_services/edit_services_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class HairstylistInfoPage extends StatefulWidget {
  const HairstylistInfoPage({
    super.key,
    required this.email,
    required this.isClient,
    required this.userEmail,
  });
  final String email;
  final bool isClient;
  final String userEmail;

  @override
  State<HairstylistInfoPage> createState() => _InfoPageState();
}

final HairstylistController hairstylistController = HairstylistController();
final ServiceController serviceController = ServiceController();
BSAddBarberController bsAddBarberController = BSAddBarberController();

class _InfoPageState extends State<HairstylistInfoPage> {
  String? currentUserEmail;
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    _fetchDataFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    await hairstylistController.getHairstylist(widget.email);
    await serviceController.fetchServicesForUsers(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<void>(
        future: _fetchDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading data',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 18, 18, 18),
                ),
              ),
            );
          } else {
            final hairstylist = hairstylistController.hairstylist;
            if (hairstylist == null) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 189, 49, 71),
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.015,
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('availableBarbers')
                          .where('barberEmail', isEqualTo: widget.userEmail)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 189, 49, 71),
                              ),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Error loading barbers.",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "No affiliated shop",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }

                        final barber = snapshot.data!.docs.first;
                        final data = barber.data() as Map<String, dynamic>;
                        final shopName =
                            data['affiliatedShop'] ?? 'Not available';

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.02,
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
                                  Text(
                                    'Affiliated shop:     ',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(100, 48, 65, 69),
                                    ),
                                  ),
                                  Text(
                                    shopName,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 48, 65, 69),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Username:     ',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(100, 48, 65, 69),
                                    ),
                                  ),
                                  Text(
                                    '@${hairstylistController.hairstylist!.username}',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 48, 65, 69),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.001,
                                    ),
                                    child: Text(
                                      'Email:     ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            100, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    hairstylistController.hairstylist!.email,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 48, 65, 69),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.001,
                                    ),
                                    child: Text(
                                      'Location:     ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            100, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      hairstylistController
                                          .hairstylist!.location['address'],
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.001,
                                    ),
                                    child: Text(
                                      'Phone number:     ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            100, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    hairstylistController
                                        .hairstylist!.phoneNumber,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          const Color.fromARGB(255, 48, 65, 69),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.001,
                                    ),
                                    child: Text(
                                      'Skills:     ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            100, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.02,
                                    ),
                                    child: Text(
                                      hairstylistController.hairstylist!.skills,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.001,
                                    ),
                                    child: Text(
                                      'Years of experience:     ',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.032,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            100, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.02,
                                    ),
                                    child: Text(
                                      '${hairstylistController.hairstylist!.yearsOfExperience} years',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.034,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Gap(screenHeight * 0.012),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.01,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Services',
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 48, 65, 69),
                                  fontSize: screenWidth * 0.040,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (currentUserEmail == widget.email)
                                SizedBox(
                                  height: screenHeight * 0.03,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddServicePage(
                                            hairstylistEmail: widget.email,
                                          ),
                                        ),
                                      ).then((_) {
                                        setState(() {
                                          serviceController
                                              .fetchServicesForUsers(
                                                  widget.email);
                                        });
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 48, 65, 69),
                                        width: 1,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03,
                                      ),
                                    ),
                                    child: Text(
                                      'Add service',
                                      style: GoogleFonts.poppins(
                                        color: const Color.fromARGB(
                                            255, 48, 65, 69),
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Gap(screenHeight * 0.02),
                          SizedBox(
                            height: screenHeight * 0.5,
                            child: AnimatedBuilder(
                              animation: serviceController,
                              builder: (context, snapshot) {
                                if (serviceController.isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromARGB(255, 189, 49, 71),
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: serviceController.services.length,
                                  itemBuilder: (context, index) {
                                    final service =
                                        serviceController.services[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: screenWidth * 0.12,
                                              height: screenWidth * 0.12,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/icons/for_servicess.jpg'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Gap(screenWidth * 0.03),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    service.serviceName,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize:
                                                          screenWidth * 0.034,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 48, 65, 69),
                                                    ),
                                                  ),
                                                  Text(
                                                    service.serviceDescription,
                                                    style: GoogleFonts.poppins(
                                                      fontSize:
                                                          screenWidth * 0.025,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 48, 65, 69),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'P ${service.price.toString()}',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              screenWidth *
                                                                  0.030,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 48, 65, 69),
                                                        ),
                                                      ),
                                                      Gap(screenWidth * 0.02),
                                                      Text(
                                                        '${service.duration} mins',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontSize:
                                                              screenWidth *
                                                                  0.030,
                                                          fontWeight:
                                                              FontWeight.w500,
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
                                            if (currentUserEmail ==
                                                widget.email)
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 186, 199, 206),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        size: 20,
                                                        color: Color.fromARGB(
                                                            255, 49, 65, 69),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditServicePage(
                                                              userEmail:
                                                                  widget.email,
                                                              service: service,
                                                            ),
                                                          ),
                                                        ).then((_) {
                                                          setState(() {
                                                            serviceController
                                                                .fetchServicesForUsers(
                                                                    widget
                                                                        .email);
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Gap(screenWidth * 0.05),
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 186, 199, 206),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 20,
                                                        color: Color.fromARGB(
                                                            255, 49, 65, 69),
                                                      ),
                                                      onPressed: () {
                                                        serviceController
                                                            .deleteService(
                                                                service.id,
                                                                service
                                                                    .userEmail)
                                                            .then((_) {
                                                          setState(() {
                                                            serviceController
                                                                .fetchServicesForUsers(
                                                                    widget
                                                                        .email);
                                                          });
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        Gap(screenHeight * 0.02),
                                      ],
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
            );
          }
        },
      ),
    );
  }
}
