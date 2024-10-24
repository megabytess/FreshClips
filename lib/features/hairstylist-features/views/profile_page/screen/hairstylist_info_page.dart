import 'package:flutter/material.dart';
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
  });
  final String email;

  @override
  State<HairstylistInfoPage> createState() => _InfoPageState();
}

HairstylistController hairstylistController = HairstylistController();

class _InfoPageState extends State<HairstylistInfoPage> {
  ServiceController serviceController = ServiceController();

  @override
  void initState() {
    super.initState();
    hairstylistController.getHairstylist(widget.email);
    serviceController.fetchServicesForHairstylist(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: hairstylistController,
        builder: (context, snapshot) {
          // Check if the data is still loading
          if (hairstylistController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.01,
                      ),
                      child: Text(
                        'Username:',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(100, 18, 18, 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.01,
                      ),
                      child: Text(
                        '@${hairstylistController.hairstylist!.username}',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.002),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.001,
                      ),
                      child: Text(
                        'Email:',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(100, 18, 18, 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                      ),
                      child: Text(
                        hairstylistController.hairstylist!.email,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.002),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.001,
                      ),
                      child: Text(
                        'Location:',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(100, 18, 18, 18),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                      ),
                      child: Text(
                        hairstylistController.hairstylist!.location,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.002),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.001,
                      ),
                      child: Text(
                        'Skills:',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(100, 18, 18, 18),
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
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.002),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        top: screenHeight * 0.001,
                      ),
                      child: Text(
                        'Years of experience:',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.032,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(100, 18, 18, 18),
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
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Services',
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 18, 18, 18),
                              fontSize: screenWidth * 0.040,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                                  // Refresh the services after adding a new service
                                  setState(() {
                                    serviceController
                                        .fetchServicesForHairstylist(
                                            widget.email);
                                  });
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 18, 18, 18),
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Add service',
                                style: GoogleFonts.poppins(
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.01),
                      SizedBox(
                        height:
                            screenHeight * 0.5, // Adjust the height as needed
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

                            if (serviceController.services.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                  screenWidth * 0.2, //left
                                  screenHeight * 0.1, //top
                                  screenWidth * 0.1, //right
                                  screenHeight * 0.1, //bottom
                                ),
                                child: Text(
                                  'No services available.',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }
                            // Display the list of services
                            return ListView.builder(
                              itemCount: serviceController.services.length,
                              itemBuilder: (context, index) {
                                final service =
                                    serviceController.services[index];
                                return ListTile(
                                  leading: Container(
                                    width: screenWidth * 0.12,
                                    height: screenWidth * 0.12,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                          'assets/images/icons/launcher_icon.png',
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    service.serviceName,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: screenWidth * 0.030,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.serviceDescription,
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.020,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'P ${service.price.toString()}',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.030,
                                            ),
                                          ),
                                          Gap(screenWidth * 0.02),
                                          Text(
                                            '${service.duration} mins',
                                            style: GoogleFonts.poppins(
                                              fontSize: screenWidth * 0.030,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  50, 18, 18, 18),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditServicePage(
                                                hairstylistEmail: widget.email,
                                                service: service,
                                              ),
                                            ),
                                          ).then((_) {
                                            // Refresh the services after editing a service
                                            setState(() {
                                              serviceController
                                                  .fetchServicesForHairstylist(
                                                      widget.email);
                                            });
                                          });
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          serviceController
                                              .deleteService(service.id,
                                                  service.hairstylistEmail)
                                              .then((_) {
                                            // Refresh the services after deletion
                                            setState(() {
                                              serviceController
                                                  .fetchServicesForHairstylist(
                                                      widget.email);
                                            });
                                          });
                                        },
                                      ),
                                    ],
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
          );
        },
      ),
    );
  }
}
