import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/settings_drawer/manage_availability/manage_availability_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/settings_drawer/profile_details/profile_details_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/widget/build_setting_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.email});
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
          buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Profile details',
            Icons.person_rounded,
            Icons.arrow_forward_ios,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileDetailsPage(
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
          buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Manage availability',
            Icons.calendar_month_rounded,
            Icons.arrow_forward_ios,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageAvailabilityPage(email: email),
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
        ],
      ),
    );
  }
}
