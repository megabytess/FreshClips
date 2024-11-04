import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/services_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_services/add_services_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_services/edit_services_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key, required this.userEmail});
  final String userEmail;

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  ServiceController serviceController = ServiceController();

  @override
  void initState() {
    super.initState();

    serviceController.fetchServicesForUsers(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Services',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: serviceController,
              builder: (context, _) {
                // Show a loading spinner while fetching services
                if (serviceController.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 189, 49, 71),
                      ),
                    ),
                  );
                }

                // Check if the services list is empty
                if (serviceController.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No services available.',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(screenHeight * 0.02),
                      ],
                    ),
                  );
                }

                // Display the services as a list
                return ListView.builder(
                  itemCount: serviceController.services.length,
                  itemBuilder: (context, index) {
                    final service = serviceController.services[index];
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  color: const Color.fromARGB(50, 18, 18, 18),
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
                                  builder: (context) => EditServicePage(
                                    userEmail: widget.userEmail,
                                    service: service,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              serviceController
                                  .deleteService(service.id, service.userEmail)
                                  .then((_) {
                                // Refresh the services after deletion
                                setState(() {
                                  serviceController
                                      .fetchServicesForUsers(widget.userEmail);
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
          // Always visible "Add Service" button at the bottom
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddServicePage(
                      hairstylistEmail: widget.userEmail,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 189, 49, 70),
                  width: 2,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.04,
                  horizontal: screenWidth * 0.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'Add service',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 18, 18, 18),
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
