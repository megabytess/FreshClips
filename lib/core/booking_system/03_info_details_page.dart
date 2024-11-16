import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/04_booking_summary_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDetailsPage extends StatefulWidget {
  const InfoDetailsPage({
    super.key,
    required this.userId,
    required this.accountName,
    required this.selectedTime,
    required this.userType,
    required this.selectedServices,
    required this.selectedDate,
    required Map<String, Object> bookingData,
  });

  final String userId;
  final String accountName;
  final TimeOfDay selectedTime;
  final String userType;
  final List<Service> selectedServices;
  final DateTime selectedDate;

  @override
  State<InfoDetailsPage> createState() => _InfoDetailsPageState();
}

class _InfoDetailsPageState extends State<InfoDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.accountName,
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Input the necessary information.',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(screenHeight * 0.02),
                  TextFormField(
                    controller: clientNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  Gap(screenHeight * 0.02),
                  TextFormField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  Gap(screenHeight * 0.02),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Note',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingSummaryPage(
                            userId: widget.userId,
                            accountName: widget.accountName,
                            selectedTime: widget.selectedTime,
                            userType: widget.userType,
                            selectedServices: widget.selectedServices,
                            selectedDate: widget.selectedDate,
                            clientName: clientNameController.text,
                            phoneNumber: phoneNumberController.text,
                            note: noteController.text,
                            title: widget.selectedServices[0].serviceName,
                            description:
                                widget.selectedServices[0].serviceDescription,
                            price: widget.selectedServices[0].price,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                  ),
                  child: Text(
                    'Continue',
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
