import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/03_info_details_page.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
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

  void fetchAvailabilityData() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<WorkingHours> fetchedData =
          await availabilityController.fetchWorkingHoursBS(widget.userEmail);

      setState(() {
        availabilityData = fetchedData.map((workingHour) {
          DateTime parsedDate;
          try {
            parsedDate =
                DateFormat('EEEE, MMMM dd, yyyy').parse(workingHour.day);
          } catch (e) {
            print('Error parsing date: $e');
            parsedDate = DateTime.now();
          }

          return {
            'day': workingHour.day,
            'status': workingHour.status,
            'date': parsedDate.toIso8601String(),
            'openingTime': workingHour.openingTime,
            'closingTime': workingHour.closingTime,
          };
        }).toList();

        availabilityData.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB);
        });

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching working hours: $e');
    }
  }

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
          'Time & Date',
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
              'Select a day',
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
              'Select a Time slot',
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
                      // Show an error message if no day or time slot is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Please select a day and time slot before continuing.'),
                        ),
                      );
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
