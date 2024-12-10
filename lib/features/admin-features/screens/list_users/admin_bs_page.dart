import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:freshclips_capstone/features/admin-features/screens/admin_bs_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminBSPage extends StatefulWidget {
  const AdminBSPage({super.key, required this.email});
  final String email;

  @override
  State<AdminBSPage> createState() => _AdminBSPageState();
}

final AdminVerifyController adminVerifyController = AdminVerifyController();

class _AdminBSPageState extends State<AdminBSPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: adminVerifyController.fetchAllBarbershopSalon(widget.email),
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
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No barbershop/salon accounts found.',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            final barbershopSalons = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: screenWidth * 0.02,
                mainAxisSpacing: screenHeight * 0.02,
                childAspectRatio: 1,
              ),
              itemCount: barbershopSalons.length,
              itemBuilder: (context, index) {
                final barbershopSalon = barbershopSalons[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminBSDetailsPage(
                          email: barbershopSalon['email'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.08,
                          backgroundImage: NetworkImage(
                            barbershopSalon['imageUrl'] ?? '',
                          ),
                        ),
                        Gap(screenHeight * 0.01),
                        Text(
                          '@${barbershopSalon['username'] ?? 'No username'}',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.03,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 48, 65, 69),
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
