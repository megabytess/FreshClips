import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminBSDetailsPage extends StatefulWidget {
  const AdminBSDetailsPage({super.key, required this.email});
  final String email;

  @override
  State<AdminBSDetailsPage> createState() => _AdminBSDetailsPageState();
}

final BarbershopSalonController barbershopsalonController =
    BarbershopSalonController();

class _AdminBSDetailsPageState extends State<AdminBSDetailsPage> {
  @override
  void initState() {
    super.initState();
    barbershopsalonController.getBarbershopSalon(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Shop details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: barbershopsalonController,
        builder: (context, snapshot) {
          // Check if the data is still loading
          if (barbershopsalonController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                children: [
                  Center(
                    child: ClipOval(
                      child: Container(
                        width: screenWidth * 0.35,
                        height: screenWidth * 0.35,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 186, 199, 206),
                        ),
                        child: (barbershopsalonController
                                    .barbershopsalon?.imageUrl !=
                                null)
                            ? Image.network(
                                barbershopsalonController
                                    .barbershopsalon!.imageUrl,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                  Gap(screenHeight * 0.02),
                  Text(
                    barbershopsalonController.barbershopsalon!.shopName,
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 18, 18, 18),
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
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
                            fontSize: screenWidth * 0.035,
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
                          '@${barbershopsalonController.barbershopsalon!.username}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 18, 18, 18),
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
                          left: screenWidth * 0.02,
                          top: screenHeight * 0.001,
                        ),
                        child: Text(
                          'Email:',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
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
                          barbershopsalonController.barbershopsalon!.email,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 18, 18, 18),
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
                          left: screenWidth * 0.02,
                          top: screenHeight * 0.001,
                        ),
                        child: Text(
                          'Location:',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(100, 18, 18, 18),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.02,
                          ),
                          child: Text(
                            barbershopsalonController
                                .barbershopsalon!.location['address'],
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 18, 18, 18),
                            ),
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
                          left: screenWidth * 0.02,
                          top: screenHeight * 0.001,
                        ),
                        child: Text(
                          'Phone number:',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
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
                          barbershopsalonController
                              .barbershopsalon!.phoneNumber,
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color.fromARGB(255, 18, 18, 18),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Gap(screenHeight * 0.04),
                  // OutlinedButton(
                  //   onPressed: () {
                  //     // Call delete method from ProfileController
                  //     profileController.deleteUserProfile(widget.email);

                  //     // Optionally, navigate to another page or show a success message
                  //     Navigator.pop(context); // or any other page
                  //   },
                  //   style: OutlinedButton.styleFrom(
                  //     side: const BorderSide(
                  //       color: Color.fromARGB(255, 189, 49, 70),
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //   ),
                  //   child: Text(
                  //     'Delete account',
                  //     style: GoogleFonts.poppins(
                  //       color: const Color.fromARGB(255, 189, 49, 70),
                  //       fontSize: screenWidth * 0.035,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
