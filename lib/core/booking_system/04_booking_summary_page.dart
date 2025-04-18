import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/views/bottomnav_bar/client_bottomnav_bar.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookingSummaryPage extends StatefulWidget {
  final String userEmail;
  // final String accountName;
  // final String userType;
  final List<Service> selectedServices;
  final String clientName;
  final String clientEmail;
  // final String username;
  final String phoneNumber;
  final String note;
  final String title;
  final String description;
  final double price;
  final String profileEmail;
  final String shopName;
  final Map<String, dynamic>? selectedAffiliatedBarber;
  final String selectedTimeSlot;
  final String selectedDay;

  const BookingSummaryPage({
    super.key,
    required this.userEmail,
    // required this.accountName,
    // required this.userType,
    required this.selectedServices,
    required this.clientName,
    required this.phoneNumber,
    required this.note,
    required this.title,
    required this.description,
    required this.price,
    required this.profileEmail,
    // required this.isClient,
    // required this.username,
    required this.clientEmail,
    required this.selectedAffiliatedBarber,
    required this.shopName,
    required this.selectedTimeSlot,
    required this.selectedDay,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String formattedDate = DateFormat('MMMM d, yyyy').format(
      DateFormat('EEEE, MMMM dd, yyyy').parse(widget.selectedDay),
    );
    String time = widget.selectedTimeSlot;

    final barberName = widget.selectedAffiliatedBarber?['barberName'] ?? '';
    final barberRole = widget.selectedAffiliatedBarber?['role'] ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Appointment details',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected barber',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
            ),
            Gap(screenHeight * 0.02),
            Row(
              children: [
                Text(
                  'Affiliated shop: ',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 48, 65, 69),
                  ),
                ),
                Gap(screenWidth * 0.02),
                Text(
                  widget.selectedAffiliatedBarber?['affiliatedShop'] ?? 'N/A',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 48, 65, 69),
                  ),
                ),
              ],
            ),
            Gap(screenHeight * 0.01),
            Row(
              children: [
                widget.selectedAffiliatedBarber != null
                    ? ClipOval(
                        child: widget.selectedAffiliatedBarber?[
                                    'barberImageUrl'] !=
                                null
                            ? Image.network(
                                widget.selectedAffiliatedBarber?[
                                    'barberImageUrl'],
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                                fit: BoxFit.cover,
                              )
                            : const Text(''),
                      )
                    : const Text(''),
                Gap(screenWidth * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barberName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                    Text(
                      barberRole,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(screenHeight * 0.02),
            Divider(
              color: Colors.grey[300],
              thickness: 2,
            ),
            Gap(screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Client\'s name: ',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  Flexible(
                    child: Text(
                      widget.clientName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled date: ',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  Flexible(
                    child: Text(
                      formattedDate,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scheduled time: ',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  Flexible(
                    child: Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone number: ',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  Flexible(
                    child: Text(
                      widget.phoneNumber,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenWidth * 0.02),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note: ',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  Gap(screenWidth * 0.02),
                  Flexible(
                    child: Text(
                      widget.note,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap(screenHeight * 0.02),
            Divider(
              color: Colors.grey[300],
              thickness: 2,
            ),
            Gap(screenHeight * 0.02),
            Text(
              'Selected services',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedServices.length,
                itemBuilder: (context, index) {
                  final service = widget.selectedServices[index];
                  return ListTile(
                    title: Text(
                      service.serviceName,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                    subtitle: Text(
                      service.serviceDescription,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Text(
                      'P ${service.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 48, 65, 69),
                      ),
                    ),
                  );
                },
              ),
            ),
            Gap(screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: () async {
                    final formattedTime = widget.selectedTimeSlot;

                    // Generate a new document reference with a unique ID
                    final docRef = FirebaseFirestore.instance
                        .collection('appointments')
                        .doc();
                    final id = docRef.id;

                    final appointmentData = {
                      'id': id,
                      'bookedUser': widget.userEmail,
                      'clientName': widget.clientName,
                      'phoneNumber': widget.phoneNumber,
                      'selectedTime': formattedTime,
                      'selectedDate': formattedDate,
                      'selectedServices': widget.selectedServices
                          .map((service) => {
                                'title': service.serviceName,
                                'description': service.serviceDescription,
                                'price': service.price,
                              })
                          .toList(),
                      'note': widget.note,
                      'status': 'Pending',
                      'clientEmail': widget.clientEmail,
                      'selectedAffiliateBarber':
                          widget.selectedAffiliatedBarber?['barberName'] ?? '',
                      'shopName': widget.shopName,
                      'barberImageUrl':
                          widget.selectedAffiliatedBarber?['barberImageUrl'] ??
                              '',
                      'timeStamp': FieldValue.serverTimestamp(),
                    };

                    try {
                      await docRef.set(appointmentData);

                      // ✅ DelightToastBar success
                      DelightToastBar(
                        snackbarDuration: const Duration(seconds: 3),
                        autoDismiss: true,
                        builder: (context) => ToastCard(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/images/icons/logo_icon.png',
                            ),
                          ),
                          title: Text(
                            "Appointment booked successfully!",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ),
                      ).show(context);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientBottomNavBarPage(
                            clientEmail: widget.clientEmail,
                            email: widget.clientEmail,
                            initialIndex: 3,
                          ),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      DelightToastBar(
                        snackbarDuration: const Duration(seconds: 3),
                        autoDismiss: true,
                        builder: (context) => ToastCard(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset(
                              'assets/images/icons/logo_icon.png',
                            ),
                          ),
                          title: Text(
                            "Error booking appointment: $e",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ),
                      ).show(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Book appointment',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 248, 248, 248),
                      ),
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





//  onPressed: () async {
//                     // Format date and time
//                     final formattedDate =
//                         DateFormat('yyyy-MM-dd').format(selectedDate);
//                     final formattedTime = selectedTime.format(context);

//                     // Firestore Query
//                     final appointments = await FirebaseFirestore.instance
//                         .collection('appointments')
//                         .where('bookedUser', isEqualTo: userEmail)
//                         .where('selectedDate', isEqualTo: formattedDate)
//                         .where('selectedTime', isEqualTo: formattedTime)
//                         .get();

//                     // Check if any appointment exists for the given time and date
//                     if (appointments.docs.isNotEmpty) {
//                       // Notify the user that the slot is already booked
//                       showDialog(
//                         context: context,
//                         builder: (context) {
//                           return AlertDialog(
//                             title: Text('Time Slot Unavailable'),
//                             content: Text(
//                               'The selected time slot ($formattedTime on $formattedDate) is already booked. Please choose a different time.',
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: Text('OK'),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     } else {
//                       // Proceed with booking
//                       final appointmentData = {
//                         'bookedUser': userEmail,
//                         'clientName': clientName,
//                         'phoneNumber': phoneNumber,
//                         'selectedTime': formattedTime,
//                         'selectedDate': formattedDate,
//                         'selectedServices': selectedServices
//                             .map((service) => {
//                                   'title': service.serviceName,
//                                   'description': service.serviceDescription,
//                                   'price': service.price,
//                                 })
//                             .toList(),
//                         'note': note,
//                         'status': 'Pending',
//                       };

//                       try {
//                         await FirebaseFirestore.instance
//                             .collection('appointments')
//                             .add(appointmentData);
//                         Navigator.pop(context);
//                       } catch (e) {
//                         print('Error booking appointment: $e');
//                       }
//                     }
//                   },
