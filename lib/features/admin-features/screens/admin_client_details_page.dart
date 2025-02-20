import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminClientDetailsPage extends StatefulWidget {
  const AdminClientDetailsPage({super.key, required this.email});
  final String email;

  @override
  State<AdminClientDetailsPage> createState() => _AdminClientDetailsPageState();
}

class _AdminClientDetailsPageState extends State<AdminClientDetailsPage> {
  final ClientController clientController = ClientController();

  @override
  void initState() {
    super.initState();
    clientController.fetchClientData(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Client details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedBuilder(
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
                      child: Image.network(
                        clientController.client!.imageUrl,
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Gap(screenHeight * 0.02),
                  Text(
                    '${clientController.client?.firstName ?? ''} ${clientController.client?.lastName ?? ''}',
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
                          '@${clientController.client!.username}',
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
                          clientController.client!.email,
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
                            clientController.client!.location['address'],
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
                              color: const Color.fromARGB(255, 18, 18, 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
