import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class BSAvailabilityDatePage extends StatefulWidget {
  final String email;

  const BSAvailabilityDatePage({super.key, required this.email});

  @override
  State<BSAvailabilityDatePage> createState() => _AvailabilityDatePageState();
}

class _AvailabilityDatePageState extends State<BSAvailabilityDatePage> {
  List<DateTime> availableDates = [];
  Map<DateTime, Map<String, dynamic>> availabilityStatus = {};
  bool isAvailable = true;
  late WorkingHoursController workingHoursController;
  late BSAvailabilityController bsAvailibilityController;

  @override
  void initState() {
    super.initState();
    availableDates = generateNextWeekDates();
    workingHoursController = workingHoursController =
        WorkingHoursController(email: widget.email, context: context);
    bsAvailibilityController =
        BSAvailabilityController(email: widget.email, context: context);
    for (var date in availableDates) {
      availabilityStatus[date] = {'status': true};
    }
  }

  // Function to generate the next 7 days starting from today
  List<DateTime> generateNextWeekDates() {
    DateTime today = DateTime.now();
    return List.generate(7, (index) => today.add(Duration(days: index)));
  }

  // Function to convert a DateTime object to a WorkingHours object
  WorkingHours dateTimeToWorkingHours(DateTime date) {
    String formattedDay = DateFormat('EEEE, MMMM d, yyyy').format(date);
    return WorkingHours(
      day: formattedDay,
      status: availabilityStatus[date]?['status'],
      openingTime: availabilityStatus[date]?['openingTime'],
      closingTime: availabilityStatus[date]?['closingTime'],
    );
  }

  //Format Time
  String formatTime(DateTime? dateTime) {
    if (null == dateTime) {
      return 'Not Set';
    }
    return DateFormat('h:mma').format(dateTime);
  }

  // Function to save the availability status to Firestore
  Future<void> saveAvailability() async {
    try {
      List<WorkingHours> workingHours = availableDates.map((date) {
        return dateTimeToWorkingHours(date);
      }).toList();

      await bsAvailibilityController.addAvailabilityForBS(
          widget.email, workingHours);

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;

          return AlertDialog(
            title: Text(
              'Success',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Availability Updated!',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: const Color.fromARGB(255, 23, 23, 23),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      print('Success: Working Hours updated in Firestore.');
    } catch (e) {
      print('Error: Failed to update availability. $e');

      // Show error dialog
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;

          return AlertDialog(
            title: Text(
              'Error',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'Failed to update availability.',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'OK',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    color: const Color.fromARGB(255, 23, 23, 23),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _pickTime(DateTime date, bool isOpeningTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        final formattedTime = pickedTime.format(context);

        // Initialize with both opening and closing time fields if not present
        availabilityStatus[date] ??= {
          'status': true, // dapat TRUE daan
          'openingTime': '',
          'closingTime': ''
        };

        // Update either opening or closing time based on the boolean flag
        if (isOpeningTime) {
          (availabilityStatus[date] as Map<String, String>)['openingTime'] =
              formattedTime;
        } else {
          (availabilityStatus[date] as Map<String, String>)['closingTime'] =
              formattedTime;
        }
      });
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
          'Weekly availability',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: availableDates.length,
                itemBuilder: (context, index) {
                  DateTime date = availableDates[index];
                  String formattedDate =
                      DateFormat('EEEE, MMMM d, yyyy').format(date);

                  // Ensure each date entry in availabilityStatus has a default map
                  availabilityStatus[date] ??= {'status': true};

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gap(screenHeight * 0.01),
                      DropdownButtonFormField<bool>(
                        value: availabilityStatus[date]!['status'],
                        items: [true, false].map((bool status) {
                          return DropdownMenuItem<bool>(
                            value: status,
                            child: Text(
                              status ? 'Shop Open' : 'Shop Closed',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            availabilityStatus[date]!['status'] = newValue!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Status',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                          ),
                        ),
                      ),
                      Gap(screenHeight * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Opening Time:',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Closing Time:',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () => _pickTime(date, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 199, 206),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                ),
                                child: Text(
                                  availabilityStatus[date]?['openingTime'] ??
                                      'Not Set',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => _pickTime(date, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 199, 206),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        screenWidth * 0.03),
                                  ),
                                ),
                                child: Text(
                                  availabilityStatus[date]?['closingTime'] ??
                                      'Not Set',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    color:
                                        const Color.fromARGB(255, 18, 18, 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(screenHeight * 0.03),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: screenHeight * 0.07,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  saveAvailability();
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
                  'Save data',
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
    );
  }
}
