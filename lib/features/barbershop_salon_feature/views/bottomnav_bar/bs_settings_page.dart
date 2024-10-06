import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BSSettingsPage extends StatelessWidget {
  const BSSettingsPage({super.key});

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
          _buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Services',
            Icons.arrow_forward_ios,
            onPressed: () {
              // Navigate to the Services page
            },
          ),
          const Divider(
            color: Color.fromARGB(255, 189, 189, 189), // Custom line color
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          _buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Profile details',
            Icons.arrow_forward_ios,
            onPressed: () {
              // Navigate to the Profile details page
            },
          ),
          const Divider(
            color: Color.fromARGB(255, 189, 189, 189), // Custom line color
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          _buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Manage availability',
            Icons.arrow_forward_ios,
            onPressed: () {
              // Navigate to the Working hours page
            },
          ),
          const Divider(
            color: Color.fromARGB(255, 189, 189, 189), // Custom line color
            thickness: 1.0,
            indent: 20.0,
            endIndent: 20.0,
          ),
          _buildSettingButton(
            context,
            screenWidth,
            screenHeight,
            'Booking system',
            Icons.arrow_forward_ios,
            onPressed: () {
              // Navigate to the Working hours page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    String title,
    IconData trailingIcon, {
    required VoidCallback onPressed,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.01,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(255, 18, 18, 18),
        ),
      ),
      trailing: Icon(
        trailingIcon,
        size: screenWidth * 0.04,
        color: const Color.fromARGB(255, 18, 18, 18),
      ),
      onTap: onPressed,
    );
  }
}
