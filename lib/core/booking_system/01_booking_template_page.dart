import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/02_date_time_schedule_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/hairstylist_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/services_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingTemplatePage extends StatefulWidget {
  const BookingTemplatePage({
    super.key,
    required this.userType,
    required this.accountName,
    required this.userId,
  });
  final String userType;
  final String accountName;
  final String userId;

  @override
  State<BookingTemplatePage> createState() => _BookingTemplatePageState();
}

class _BookingTemplatePageState extends State<BookingTemplatePage> {
  late BarbershopSalonController barbershopSalonController;
  late HairstylistController hairstylistController;
  late Future<List<Service>> servicesFuture;
  late final ServiceController serviceController = ServiceController();

  bool isAnyServiceSelected = false; // Track if any service is selected

  @override
  void initState() {
    super.initState();
    barbershopSalonController = BarbershopSalonController();
    hairstylistController = HairstylistController();
    servicesFuture = fetchServices();
  }

  Future<List<Service>> fetchServices() {
    return serviceController.fetchServicesForUsers(widget.userId);
  }

  // Function to check if any service is selected and update the state
  void updateSelectionStatus(List<Service> services) {
    setState(() {
      isAnyServiceSelected = services.any((service) => service.selected);
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
          widget.accountName,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Services',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(screenHeight * 0.02),
          Expanded(
            child: FutureBuilder<List<Service>>(
              future: servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return const Center(child: Text('Error loading services.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  print(
                      'No services available. Snapshot data: ${snapshot.data}');
                  return const Center(child: Text('No services available.'));
                }

                final services = snapshot.data!;
                print('Services loaded: ${services.length}');
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                service.selected = !service.selected;
                                updateSelectionStatus(
                                    services); // Update the button state
                              });
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        Gap(screenWidth * 0.04),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.serviceName,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700,
                                                fontSize: screenWidth * 0.04,
                                              ),
                                            ),
                                            Text(
                                              service.serviceDescription,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.025,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'P ${service.price}',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                  ),
                                                ),
                                                Gap(screenWidth * 0.04),
                                                Text(
                                                  '${service.duration} mins',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Checkbox(
                                      value: service.selected,
                                      activeColor:
                                          const Color.fromARGB(255, 48, 65, 69),
                                      onChanged: (value) {
                                        setState(() {
                                          service.selected = value ?? false;
                                          updateSelectionStatus(
                                            services,
                                          ); // Update the button state
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Gap(screenHeight * 0.02),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isAnyServiceSelected
                            ? () {
                                final selectedServices = services
                                    .where((service) => service.selected)
                                    .toList();

                                // Print the selected services to the console
                                print(
                                    'Selected Services to pass to next screen:');
                                selectedServices.forEach((service) {
                                  print(
                                      'Service: ${service.serviceName}, Price: ${service.price}');
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DateTimeSchedulePage(
                                      selectedServices: selectedServices,
                                      userType: widget.userType,
                                      accountName: widget.accountName,
                                      userId: widget.userId,
                                    ),
                                  ),
                                );
                              }
                            : null, // Disable button if no service is selected
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 48, 65, 69),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 248, 248, 248),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
