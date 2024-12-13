import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BSEditAvailabilityDatePage extends StatefulWidget {
  const BSEditAvailabilityDatePage({super.key, required this.email});
  final String email;
  @override
  State<BSEditAvailabilityDatePage> createState() =>
      _BSEditAvailabilityDatePageState();
}

class _BSEditAvailabilityDatePageState
    extends State<BSEditAvailabilityDatePage> {
  bool isLoading = true;
  Map<DateTime, Map<String, dynamic>> availabilityStatus = {};
  List<Map<String, dynamic>> availabilityData = [];
  late BSAvailabilityController bsAvailabilityController;
  @override
  void initState() {
    super.initState();
    bsAvailabilityController =
        BSAvailabilityController(email: widget.email, context: context);
    fetchBSWorkingHours();
  }

  void fetchBSWorkingHours() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<WorkingHours> fetchedData =
          await bsAvailabilityController.fetchWorkingHoursBS(widget.email);

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

  Future<void> pickTime(DateTime date, bool isOpeningTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        // Create a DateTime object using the date and picked time
        final selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Initialize with both opening and closing time fields if not present
        availabilityStatus[date] ??= {
          'status': true,
          'openingTime': null,
          'closingTime': null,
        };

        // Update either opening or closing time based on the boolean flag
        if (isOpeningTime) {
          availabilityStatus[date]!['openingTime'] = selectedDateTime;
        } else {
          availabilityStatus[date]!['closingTime'] = selectedDateTime;
        }
      });
    }
  }

  WorkingHours dateTimeToWorkingHours(DateTime date) {
    String formattedDay = DateFormat('EEEE, MMMM d, yyyy').format(date);
    return WorkingHours(
      day: formattedDay,
      status: availabilityStatus[date]?['status'] ?? false,
      openingTime: availabilityStatus[date]?['openingTime'],
      closingTime: availabilityStatus[date]?['closingTime'],
    );
  }

  String formatTime(DateTime? dateTime) {
    if (null == dateTime) {
      return 'Not Set';
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  Future<void> updateAvailability() async {
    try {
      setState(() {
        isLoading = true;
      });

      for (final dayData in availabilityData) {
        final String email = widget.email;
        final String day = dayData['day']; // MONDAY, TUESDAY, etc.
        final bool status = dayData['status']; // true or false

        // Directly assign if they are already DateTime objects
        final DateTime openingTime = dayData['openingTime'];
        final DateTime closingTime = dayData['closingTime'];

        await bsAvailabilityController.updateWorkingHoursBS(
          email,
          day,
          status,
          openingTime,
          closingTime,
        );
      }

      setState(() {
        isLoading = false;
      });

      print('Availability updated successfully!');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error updating availability: $e');
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
          'Edit availability',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: availabilityData.length,
                    itemBuilder: (context, index) {
                      final dayData = availabilityData[index];
                      final DateTime date =
                          DateTime.parse(dayData['date']); // Parse the date
                      final String formattedDay =
                          DateFormat('EEEE, MMMM d, yyyy').format(date);

                      return Padding(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formattedDay,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(screenHeight * 0.01),
                            Row(
                              children: [
                                Text(
                                  'Status:',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(screenWidth * 0.03),
                                DropdownButton<bool>(
                                  value: dayData['status'] as bool,
                                  items: [
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text('SHOP OPEN',
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                    DropdownMenuItem(
                                      value: false,
                                      child: Text('SHOP CLOSED',
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          )),
                                    ),
                                  ],
                                  onChanged: (newValue) {
                                    setState(() {
                                      dayData['status'] = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Opening Time:',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Gap(screenWidth * 0.03),
                                ElevatedButton(
                                  onPressed: () async {
                                    await pickTime(date, true);
                                    setState(() {
                                      dayData['openingTime'] =
                                          availabilityStatus[date]
                                              ?['openingTime'];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 186, 199, 206),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03),
                                    ),
                                  ),
                                  child: Text(
                                    formatTime(dayData['openingTime']),
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Closing Time:',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                ElevatedButton(
                                  onPressed: () async {
                                    await pickTime(date, false);
                                    setState(() {
                                      dayData['closingTime'] =
                                          availabilityStatus[date]
                                              ?['closingTime'];
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 186, 199, 206),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          screenWidth * 0.03),
                                    ),
                                  ),
                                  child: Text(
                                    formatTime(dayData['closingTime']),
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          const Color.fromARGB(255, 18, 18, 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: ElevatedButton(
                      onPressed: () async {
                        await updateAvailability();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
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
                ),
              ],
            ),
    );
  }
}
