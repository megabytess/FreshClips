import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/04_booking_summary_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom;
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDetailsPage extends StatefulWidget {
  const InfoDetailsPage({
    super.key,
    required this.userEmail,
    required this.shopName,
    required this.selectedTime,
    required this.selectedServices,
    required this.selectedDate,
    required Map<String, Object> bookingData,
    required this.clientEmail,
  });

  final String clientEmail;
  final String userEmail;
  final String shopName;
  final TimeOfDay selectedTime;
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
  final TextEditingController searchInputController = TextEditingController();

  final custom.SearchController searchController = custom.SearchController();
  List<Map<String, dynamic>> searchResults = [];
  final List<Map<String, dynamic>> selectedBarbers = [];
  final TextEditingController reviewController = TextEditingController();
  late final RatingsReviewController ratingsReviewController =
      RatingsReviewController(
    clientEmail: widget.clientEmail,
    reviewController: reviewController,
  );

  void showSearchModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.08,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchInputController,
                decoration: InputDecoration(
                  hintText: 'Search user',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 18, 18, 18)),
                onChanged: (value) {
                  setState(() async {
                    if (value.trim().isNotEmpty) {
                      final results = await searchController
                          .fetchAffiliatedBarbers(value.trim());
                      setState(() {
                        searchResults = results;
                      });
                    } else {
                      setState(() {
                        searchResults = [];
                      });
                    }
                  });
                },
              ),
              Gap(screenHeight * 0.02),
              Flexible(
                child: searchResults.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: screenWidth * 0.2, color: Colors.grey),
                          Text(
                            'No results found',
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final barber = searchResults[index];
                          return InkWell(
                            onTap: () {
                              // Navigate or show details for the selected barber
                              Navigator.pop(context, barber);
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  barber['barberImageUrl'] ?? '',
                                ),
                                backgroundColor: Colors.grey[200],
                                onBackgroundImageError: (_, __) {
                                  // Show placeholder image
                                },
                              ),
                              title: Text(
                                barber['barberName'] ?? 'Unknown Barber',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: ${barber['barberEmail'] ?? 'No email'}',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Text(
                                    'Status: ${barber['status'] ?? 'N/A'}',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking Details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Please provide the necessary information for the booking.',
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
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
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
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
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
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                        ),
                        maxLines: 3,
                      ),
                      Gap(screenHeight * 0.01),
                      Text(
                        'Note: Please provide any additional information that the stylist should know.',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.03,
                          color: Colors.grey,
                        ),
                      ),
                      Gap(screenHeight * 0.03),
                      Text(
                        'You may choose your desired barber.',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 48, 65, 69),
                        ),
                      ),
                      Gap(screenHeight * 0.02),
                      SizedBox(
                        height: screenHeight * 0.05,
                        child: OutlinedButton(
                          onPressed: () => showSearchModal(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey[600]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search_rounded,
                                color: Colors.grey,
                                size: 20,
                              ),
                              const Gap(5),
                              Text(
                                'Search hairstylist',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                            userEmail: widget.userEmail,
                            selectedTime: widget.selectedTime,
                            selectedServices: widget.selectedServices,
                            selectedDate: widget.selectedDate,
                            clientName: clientNameController.text,
                            phoneNumber: phoneNumberController.text,
                            note: noteController.text,
                            title: widget.selectedServices[0].serviceName,
                            description:
                                widget.selectedServices[0].serviceDescription,
                            price: widget.selectedServices[0].price,
                            clientEmail: widget.clientEmail,
                            profileEmail: widget.clientEmail,
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
