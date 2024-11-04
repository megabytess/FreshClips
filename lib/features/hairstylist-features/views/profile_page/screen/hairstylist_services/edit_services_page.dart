import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/services_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class EditServicePage extends StatefulWidget {
  const EditServicePage({
    super.key,
    required this.service,
    required this.userEmail,
  });
  final Service service;
  final String userEmail;

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  final _formKey = GlobalKey<FormState>();
  late String serviceName;
  late String serviceDescription;
  late double price;
  late int duration;

  @override
  void initState() {
    super.initState();
    // Pre-fill the fields with the existing service data
    serviceName = widget.service.serviceName;
    serviceDescription = widget.service.serviceDescription;
    price = widget.service.price;
    duration = widget.service.duration;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final serviceController = ServiceController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit services',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: serviceName,
                decoration: InputDecoration(
                  labelText: 'Service Name',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  serviceName = value;
                },
              ),
              Gap(screenHeight * 0.02),
              TextFormField(
                initialValue: serviceDescription,
                decoration: InputDecoration(
                  labelText: 'Service Description',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  serviceDescription = value;
                },
              ),
              Gap(screenHeight * 0.02),
              TextFormField(
                initialValue: price.toString(),
                decoration: InputDecoration(
                  labelText: 'Price (PHP)',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = double.parse(value);
                },
              ),
              Gap(screenHeight * 0.02),
              TextFormField(
                initialValue: duration.toString(),
                decoration: InputDecoration(
                  labelText: 'Duration (minutes)',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
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
                      final updatedService = Service(
                        id: widget.service.id,
                        serviceName: serviceName,
                        serviceDescription: serviceDescription,
                        price: price,
                        duration: duration,
                        userEmail: widget.userEmail,
                      );
                      serviceController.updateService(updatedService);
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
                    'Update service',
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
