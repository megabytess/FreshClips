import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/03_info_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateTimeSchedulePage extends StatefulWidget {
  const DateTimeSchedulePage({
    super.key,
    required this.selectedServices,
    required this.userEmail,
    required this.clientEmail,
    required this.shopName,
  });

  final List<Service> selectedServices;
  final String userEmail;
  final String clientEmail;
  final String shopName;
  final String userType = 'Barbershop/Salon';

  @override
  State<DateTimeSchedulePage> createState() => _DateTimeSchedulePageState();
}

class _DateTimeSchedulePageState extends State<DateTimeSchedulePage> {
  late BSAvailabilityController availabilityController;
  List<Map<String, dynamic>> availabilityData = [];

  Map<String, dynamic> workingHours = {};
  bool isLoading = false;
  String? selectedDay;
  String? selectedTimeSlot;
  List<String> timeSlots = [];

  @override
  void initState() {
    super.initState();
    availabilityController = BSAvailabilityController(
      email: widget.userEmail,
      context: context,
    );
    fetchAvailabilityData();
  }

  // fetch availability data method
  void fetchAvailabilityData() async {
    try {
      setState(() => isLoading = true);

      // Step 1: Get data and process it
      final fetchedData =
          await availabilityController.fetchWorkingHoursBS(widget.userEmail);
      final today = DateTime.now();

      // Step 2: Convert, filter and sort in one operation
      availabilityData = fetchedData.map((hour) {
        // Convert working hour to map with parsed date
        DateTime parsedDate;
        try {
          parsedDate = DateFormat('EEEE, MMMM dd, yyyy').parse(hour.day);
        } catch (e) {
          print('Error parsing date: $e');
          parsedDate = DateTime.now();
        }

        return {
          'day': hour.day,
          'status': hour.status,
          'date': parsedDate.toIso8601String(),
          'openingTime': hour.openingTime,
          'closingTime': hour.closingTime,
        };
      }).where((data) {
        // Keep only today and future dates
        final date = DateTime.parse(data['date'] as String);
        return date.year > today.year ||
            (date.year == today.year && date.month > today.month) ||
            (date.year == today.year &&
                date.month == today.month &&
                date.day >= today.day);
      }).toList();
      availabilityData.sort((a, b) {
        DateTime dateA = DateTime.parse(a['date']);
        DateTime dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

      setState(() => isLoading = false);
    } catch (e) {
      print('Error fetching working hours: $e');
      setState(() => isLoading = false);
    }
  }

// Generate time slots based on opening and closing times
  List<String> generateTimeSlots(DateTime openingTime, DateTime closingTime) {
    try {
      List<String> slots = [];
      DateTime currentTime = openingTime;

      while (currentTime.isBefore(closingTime)) {
        slots.add(DateFormat('h:mm a').format(currentTime));
        currentTime = currentTime.add(const Duration(minutes: 30));
      }

      return slots;
    } catch (e) {
      print('Error generating time slots: $e');
      return [];
    }
  }

  // Parse time string to DateTime object
  DateTime? parseTime(String time) {
    try {
      final format = DateFormat.jm(); // Format: 9:00 AM, 10:30 PM
      return format.parse(time);
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Select time & date',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 65, 69),
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dates',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
            ),
            Gap(screenHeight * 0.01),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 189, 49, 71),
                        ),
                      ),
                    )
                  : availabilityData.isEmpty
                      ? Center(
                          child: Text(
                            'No working hours available',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                            ),
                          ),
                        )
                      : Builder(
                          builder: (context) {
                            final filteredData = availabilityData
                                .where((data) =>
                                    data['openingTime'] != null &&
                                    data['closingTime'] != null &&
                                    data['openingTime'].toString().isNotEmpty &&
                                    data['closingTime'].toString().isNotEmpty)
                                .toList();

                            return filteredData.isEmpty
                                ? const Center(
                                    child: Text(
                                        'No valid working hours available'),
                                  )
                                : GridView.builder(
                                    itemCount: filteredData.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 2,
                                    ),
                                    itemBuilder: (context, index) {
                                      final data = filteredData[index];
                                      final isSelected =
                                          selectedDay == data['day'];

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDay = data['day'];
                                            timeSlots = generateTimeSlots(
                                                data['openingTime'],
                                                data['closingTime']);
                                          });
                                          print(
                                              'Selected day: ${data['day']} with slots: $timeSlots');
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color.fromARGB(
                                                    255, 186, 199, 206)
                                                : const Color.fromARGB(
                                                    255, 248, 248, 248),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 186, 199, 206),
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                data['day'],
                                                style: GoogleFonts.poppins(
                                                  fontSize:
                                                      screenHeight * 0.015,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color.fromARGB(
                                                      255, 48, 65, 69),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
            ),
            Text(
              'Time slots',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 48, 65, 69),
              ),
            ),
            Gap(screenHeight * 0.02),
            Expanded(
              child: timeSlots.isEmpty
                  ? Center(
                      child: Text(
                        'Select a day to view time slots',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                        ),
                      ),
                    )
                  : GridView.builder(
                      itemCount: timeSlots.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        final isSelected = selectedTimeSlot == timeSlots[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTimeSlot = timeSlots[index];
                              print('Selected Time Slot: $selectedTimeSlot');
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color.fromARGB(255, 186, 199, 206)
                                  : const Color.fromARGB(255, 248, 248, 248),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 186, 199, 206),
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              timeSlots[index],
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                color: const Color.fromARGB(255, 48, 65, 69),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Gap(screenHeight * 0.02),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedDay != null && selectedTimeSlot != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoDetailsPage(
                            userEmail: widget.userEmail,
                            shopName: widget.shopName,
                            selectedServices: widget.selectedServices,
                            bookingData: {
                              'day': selectedDay!,
                              'timeSlot': selectedTimeSlot!,
                            },
                            clientEmail: widget.clientEmail,
                            userType: widget.userType,
                            bookedUser: widget.userEmail,
                            selectedDay: selectedDay!,
                            selectedTimeSlot: selectedTimeSlot!,
                          ),
                        ),
                      );
                    } else {
                      DelightToastBar(
                        snackbarDuration: const Duration(seconds: 2),
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
                            "Opss! Please select a date and time slot.",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.035,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ),
                      ).show(context);

                      return;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
            Gap(screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
