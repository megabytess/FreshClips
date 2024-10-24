import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AvailabilityDatePage extends StatefulWidget {
  final String email;

  const AvailabilityDatePage({super.key, required this.email});

  @override
  State<AvailabilityDatePage> createState() => _AvailabilityDatePageState();
}

class _AvailabilityDatePageState extends State<AvailabilityDatePage> {
  List<DateTime> availableDates = [];
  Map<DateTime, String> availabilityStatus = {};
  late WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);

  @override
  void initState() {
    super.initState();
    availableDates = generateNextWeekDates();
    workingHoursController =
        WorkingHoursController(email: widget.email, context: context);

    for (var date in availableDates) {
      availabilityStatus[date] = 'Shop Open'; // Default status for all dates
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
      status: availabilityStatus[date] ?? 'Shop Open',
    );
  }

  // Function to save the availability status to Firestore
  Future<void> saveAvailability() async {
    try {
      List<WorkingHours> workingHours = availableDates.map((date) {
        return dateTimeToWorkingHours(date);
      }).toList();

      await workingHoursController.addAvailabilityForHairstylist(
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
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
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
                      DropdownButtonFormField<String>(
                        value: availabilityStatus[date],
                        items:
                            ['Shop Open', 'Shop Closed'].map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            availabilityStatus[date] = newValue!;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_rounded,
                        size: screenWidth * 0.06, // Adjust the size as needed
                        color: const Color.fromARGB(
                            255, 248, 248, 248), // Set the color
                      ),
                      SizedBox(
                          width: screenWidth *
                              0.02), // Add some spacing between the icon and text
                      Text(
                        'Save data',
                        style: GoogleFonts.poppins(
                          color: const Color.fromARGB(255, 248, 248, 248),
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
