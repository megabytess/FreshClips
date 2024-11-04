import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/services_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class AddServicePage extends StatefulWidget {
  final String hairstylistEmail;

  const AddServicePage({super.key, required this.hairstylistEmail});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  String serviceName = '';
  String serviceDescription = '';
  double price = 0;
  int duration = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final serviceController = ServiceController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add new services',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Service Name',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                  ),
                  onChanged: (value) {
                    serviceName = value;
                  },
                ),
                Gap(screenHeight * 0.02),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Service Description',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                  ),
                  maxLines: 3, // Limit to 3 lines
                  onChanged: (value) {
                    serviceDescription = value;
                  },
                ),
                Gap(screenHeight * 0.02),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price (PHP)',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(screenWidth * 0.04),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    price = double.parse(value);
                  },
                ),
                Gap(screenHeight * 0.02),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Duration (minutes)',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(screenWidth * 0.04),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    duration = int.parse(value);
                  },
                ),
                Gap(screenHeight * 0.04),
                SizedBox(
                  height: screenHeight * 0.07,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        serviceController.addService(
                          userEmail: widget.hairstylistEmail,
                          serviceName: serviceName,
                          serviceDescription: serviceDescription,
                          price: price,
                          duration: duration,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.04,
                        horizontal: screenWidth * 0.2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Add service',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
