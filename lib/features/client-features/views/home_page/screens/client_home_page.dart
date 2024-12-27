import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/views/home_page/widgets/client_search_filter_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage(
      {super.key,
      required this.email,
      required this.isClient,
      required this.clientEmail});
  final String email;
  final bool isClient;
  final String clientEmail;

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: screenHeight * 0.05,
                color: Colors.grey[200],
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientSearchFilterPage(
                          email: widget.email,
                          isClient: widget.isClient,
                          clientEmail: widget.clientEmail),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                        size: 24,
                      ),
                      const Gap(10),
                      Text(
                        'Search barbers or shops',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Gap(screenHeight * 0.02),
          Text(
            'Create Post',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(screenHeight * 0.02),
          Text(
            'Posts will be displayed here',
            style: GoogleFonts.poppins(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
