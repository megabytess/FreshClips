import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    // required this.accountName,
    required this.userEmail,
    required this.clientEmail,
    required this.shopName,
  });

  final String shopName;
  // final String accountName;
  final String userEmail;
  final String clientEmail;

  @override
  State<BookingTemplatePage> createState() => _BookingTemplatePageState();
}

class _BookingTemplatePageState extends State<BookingTemplatePage> {
  late BarbershopSalonController barbershopSalonController;
  late HairstylistController hairstylistController;
  late Future<List<Service>> servicesFuture;
  late final ServiceController serviceController = ServiceController();
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    barbershopSalonController = BarbershopSalonController();
    hairstylistController = HairstylistController();
    servicesFuture = fetchServices();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  Future<List<Service>> fetchServices() {
    return serviceController.fetchServicesForUsers(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select Services',
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
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Services',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 48, 65, 69),
            ),
          ),
          Gap(screenHeight * 0.02),
          Expanded(
            child: FutureBuilder<List<Service>>(
              future: servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(255, 189, 49, 71),
                    ),
                  ));
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
                                                fontWeight: FontWeight.w600,
                                                fontSize: screenWidth * 0.04,
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                              ),
                                            ),
                                            Text(
                                              service.serviceDescription,
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.025,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'P ${service.price}',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                    color: const Color.fromARGB(
                                                        255, 48, 65, 69),
                                                  ),
                                                ),
                                                Gap(screenWidth * 0.04),
                                                Text(
                                                  '${service.duration} mins',
                                                  style: GoogleFonts.poppins(
                                                    fontSize:
                                                        screenWidth * 0.03,
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
                        onPressed: () {
                          final selectedServices = services
                              .where((service) => service.selected)
                              .toList();

                          if (selectedServices.isEmpty) {
                            DelightToastBar(
                              snackbarDuration: const Duration(seconds: 2),
                              autoDismiss: true,
                              position: DelightSnackbarPosition.bottom,
                              builder: (context) => ToastCard(
                                leading: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/icons/logo_icon.png',
                                  ),
                                ),
                                title: Text(
                                  "Please select at least one service.",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.035,
                                    color:
                                        const Color.fromARGB(255, 48, 65, 69),
                                  ),
                                ),
                              ),
                            ).show(context);

                            return;
                          }

                          // if (currentUserEmail == null) {
                          //   DelightToastBar(
                          //     snackbarDuration: const Duration(seconds: 2),
                          //     autoDismiss: true,
                          //     builder: (context) => ToastCard(
                          //       leading: const Icon(
                          //         Icons.flutter_dash_rounded,
                          //         size: 28,
                          //         color: Color.fromARGB(255, 48, 65, 69),
                          //       ),
                          //       title: Text(
                          //         "Please select at least one service.",
                          //         style: GoogleFonts.poppins(
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: screenWidth * 0.035,
                          //           color:
                          //               const Color.fromARGB(255, 48, 65, 69),
                          //         ),
                          //       ),
                          //     ),
                          //   ).show(context);

                          //   return;
                          // }

                          // Proceed with navigation if all values are valid
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DateTimeSchedulePage(
                                shopName: widget.shopName,
                                userEmail: widget.userEmail,
                                clientEmail: currentUserEmail!,
                                selectedServices: selectedServices,
                              ),
                            ),
                          );
                        },
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
