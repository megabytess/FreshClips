import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/admin-features/controller/admin_controller.dart';
import 'package:freshclips_capstone/features/auth/views/widgets/rectange_image_picker.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class DeclinedAccountPage extends StatefulWidget {
  final String rejectionReason;
  final String email;
  const DeclinedAccountPage({
    super.key,
    required this.rejectionReason,
    required this.email,
  });

  @override
  State<DeclinedAccountPage> createState() => _DeclinedAccountPageState();
}

class _DeclinedAccountPageState extends State<DeclinedAccountPage> {
  bool _isSubmitting = false;
  File? verifyImage;

  TextStyle headerStyle(double fontSize, {Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? const Color.fromARGB(255, 23, 23, 23),
    );
  }

  TextStyle bodyStyle(double fontSize, {Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      color: color ?? Colors.grey[800],
    );
  }

  void submitVerification() async {
    if (_isSubmitting || verifyImage == null) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      AdminVerifyController().submitAnotherVerification(
        widget.email,
        verifyImage!.path,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: SvgPicture.asset(
          'assets/images/landing_page/freshclips_logo.svg',
          height: screenHeight * 0.05,
          width: screenWidth * 0.3,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Account has been Rejected.',
              style: headerStyle(screenWidth * 0.08,
                  color: const Color.fromARGB(255, 189, 49, 70)),
            ),
            const Gap(20),
            Row(
              children: [
                Text('Reason:', style: headerStyle(screenWidth * 0.045)),
                const Gap(10),
                Text(
                  widget.rejectionReason.isNotEmpty
                      ? widget.rejectionReason
                      : 'No specific reason provided.',
                  style: bodyStyle(screenWidth * 0.045),
                ),
              ],
            ),
            const Gap(50),
            Text(
              'Upload another ID to verify your account.',
              style: bodyStyle(screenWidth * 0.035, color: Colors.black),
            ),
            const Gap(20),
            Center(
              child: RectanglePickerImage(
                onImagePick: (File pickedImage) {
                  setState(
                    () {
                      verifyImage = pickedImage;
                    },
                  );
                },
              ),
            ),
            const Gap(40),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.08,
                child: ElevatedButton(
                  onPressed: submitVerification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 248, 248, 248),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
