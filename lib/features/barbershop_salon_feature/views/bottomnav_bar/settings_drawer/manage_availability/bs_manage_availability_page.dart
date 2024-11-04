import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/settings_drawer/manage_availability/add_availability_date_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BSManageAvailabilityPage extends StatefulWidget {
  const BSManageAvailabilityPage({super.key, required this.email});
  final String email;

  @override
  State<BSManageAvailabilityPage> createState() =>
      _ManageAvailabilityPageState();
}

class _ManageAvailabilityPageState extends State<BSManageAvailabilityPage> {
  List<Map<String, dynamic>> availabilityData = [];
  bool isLoading = true;

  late final WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);

  @override
  void initState() {
    super.initState();
    workingHoursController;
    fetchWorkingHours();
  }

  void fetchWorkingHours() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<WorkingHours> fetchedData =
          await workingHoursController.fetchWorkingHours(widget.email);

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
            'openingTime': workingHour.openingTime ?? 'Not Set',
            'closingTime': workingHour.closingTime ?? 'Not Set',
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

  // edit availability functionality
  void editAvailability(String day, String currentStatus,
      String currentOpeningTime, String currentClosingTime) async {
    // Parse the provided times
    TimeOfDay newOpeningTime = _parseTimeOfDay(currentOpeningTime);
    TimeOfDay newClosingTime = _parseTimeOfDay(currentClosingTime);
    String selectedStatus = currentStatus;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Edit Availability',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: ['Shop Open', 'Shop Closed'].map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      setState(() {
                        selectedStatus = newStatus!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Status',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Opening Time: ${newOpeningTime.format(context)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: newOpeningTime,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              newOpeningTime = pickedTime;
                            });
                          }
                        },
                        child: Text(
                          'Change',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 189, 49, 71),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Closing Time: ${newClosingTime.format(context)}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: newClosingTime,
                          );
                          if (pickedTime != null) {
                            setState(() {
                              newClosingTime = pickedTime;
                            });
                          }
                        },
                        child: Text(
                          'Change',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 189, 49, 71),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 18, 18, 18),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    // Format the times for consistent storage
                    String formattedOpeningTime =
                        '${newOpeningTime.hourOfPeriod}:${newOpeningTime.minute.toString().padLeft(2, '0')} ${newOpeningTime.period == DayPeriod.am ? 'AM' : 'PM'}';
                    String formattedClosingTime =
                        '${newClosingTime.hourOfPeriod}:${newClosingTime.minute.toString().padLeft(2, '0')} ${newClosingTime.period == DayPeriod.am ? 'AM' : 'PM'}';

                    await editWorkingHours(
                      day,
                      selectedStatus,
                      formattedOpeningTime,
                      formattedClosingTime,
                    );
                    fetchWorkingHours(); // Refresh the data after edit
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(255, 18, 18, 18),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Function to parse a time string to TimeOfDay
  TimeOfDay _parseTimeOfDay(String timeString) {
    try {
      // Trim and replace any non-breaking spaces
      timeString = timeString.trim().replaceAll('\u00A0', ' ');

      // Split the string to get hours and period (AM/PM)
      final parts = timeString.split(' ');
      final timePart = parts[0].split(':');
      final hour = int.parse(timePart[0]);
      final minute = int.parse(timePart[1]);

      // Determine if it's AM or PM
      final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';

      // Handle conversion to 24-hour format
      return TimeOfDay(
        hour: isPM && hour < 12 ? hour + 12 : (hour == 12 && !isPM ? 0 : hour),
        minute: minute,
      );
    } catch (e) {
      print('Error parsing time: $e');
      return TimeOfDay.now(); // Fallback to current time on error
    }
  }

  // Function to edit working hours
  Future<void> editWorkingHours(
      String day, String status, String openingTime, String closingTime) async {
    try {
      await workingHoursController.updateWorkingHours(
          widget.email, day, status, openingTime, closingTime);
    } catch (e) {
      print('Error editing working hours: $e');
    }
  }

  // Function to handle the delete functionality
  void deleteAvailability(String day) async {
    await workingHoursController.deleteWorkingHours(day);
    fetchWorkingHours();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Manage availability',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 189, 49, 71)),
              )
            : Column(
                children: [
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 189, 49, 71),
                            ),
                          ))
                        : availabilityData.isEmpty
                            ? Center(
                                child: Text(
                                  'No available working hours',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: availabilityData.length,
                                itemBuilder: (context, index) {
                                  var dayData = availabilityData[index];

                                  // // Debug print to check dayData contents
                                  // print('Day Data: $dayData');

                                  String openingTime =
                                      dayData['openingTime'] ?? 'Not set';
                                  String closingTime =
                                      dayData['closingTime'] ?? 'Not set';

                                  return ListTile(
                                    title: Text(
                                      dayData['day'],
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status: ${dayData['status']}',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                          ),
                                        ),
                                        Text(
                                          'Opening Time: $openingTime',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                          ),
                                        ),
                                        Text(
                                          'Closing Time: $closingTime',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_calendar_rounded,
                                            size: 30,
                                            color:
                                                Color.fromARGB(255, 18, 18, 18),
                                          ),
                                          onPressed: () {
                                            editAvailability(
                                              dayData['day'],
                                              dayData['status'],
                                              openingTime,
                                              closingTime,
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Using SizedBox instead of Gap
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            size: 30,
                                            color:
                                                Color.fromARGB(255, 18, 18, 18),
                                          ),
                                          onPressed: () {
                                            deleteAvailability(dayData['day']);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                  availabilityData.isEmpty
                      ? SizedBox(
                          height: screenHeight * 0.07,
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {
                              print('Button pressed');
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  print('Navigating to AvailabilityDatePage');
                                  return AvailabilityDatePage(
                                    email: widget.email,
                                  );
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.05),
                              ),
                              backgroundColor:
                                  const Color.fromARGB(255, 189, 49, 71),
                            ),
                            child: Text(
                              'Add availability',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 248, 248, 248),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Text(
                            'You already have availability set.',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
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
