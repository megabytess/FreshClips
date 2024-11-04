import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Settings Buttons
Widget buildSettingButton(
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
    title: Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w500,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
      ],
    ),
    trailing: Icon(
      trailingIcon,
      size: screenWidth * 0.04,
      color: const Color.fromARGB(255, 18, 18, 18),
    ),
    onTap: onPressed,
  );
}
