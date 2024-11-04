import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/settings_drawer/manage_availability/bs_manage_availability_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/settings_drawer/profile_details/bs_profile_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_build_settings_button.dart';
import 'package:google_fonts/google_fonts.dart';

class BSSettingsPage extends StatelessWidget {
  const BSSettingsPage({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          buildSettingButtonBS(
            context,
            screenWidth,
            screenHeight,
            'Profile details',
            Icons.arrow_forward_ios,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BSProfileDetailsPage(
                    email: email,
                  ),
                ),
              );
            },
          ),
          const Divider(
            color: Color.fromARGB(50, 189, 189, 189),
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          buildSettingButtonBS(
            context,
            screenWidth,
            screenHeight,
            'Manage availability',
            Icons.arrow_forward_ios,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BSManageAvailabilityPage(email: email),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
