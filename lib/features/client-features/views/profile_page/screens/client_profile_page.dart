import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/screens/client_booking_history_page.dart';
import 'package:freshclips_capstone/features/client-features/views/profile_page/widgets/client_profile_details.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage(
      {super.key, required this.email, required this.clientEmail});

  final String email;
  final String clientEmail;

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

        // Null check for client data
        final client = clientController.client;
        if (client == null) {
          return const Center(
            child: Text('No client data available'),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 248),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Reduced padding
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
                        SizedBox(height: screenHeight * 0.02), // Added spacing
                        Padding(
                          padding: EdgeInsets.only(
                              left: screenWidth * 0.03), // Added left padding
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
                                  Text(
                                    clientController.client!.location,
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              SizedBox(
                                width: double.infinity,
                                height: screenHeight * 0.07,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientBookingHistoryPage(
                                          clientEmail: widget.clientEmail,
                                          isClient: true,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 48, 65, 69),
                                    minimumSize: Size(
                                        screenWidth * 0.9, screenHeight * 0.06),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'Booking History',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
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
