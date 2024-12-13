import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_working_hours_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/bottomnav_bar/settings_drawer/manage_availability/bs_edit_availability_date_page.dart';
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
  DateTime? newOpeningTime;
  DateTime? newClosingTime;

  late final WorkingHoursController workingHoursController =
      WorkingHoursController(email: widget.email, context: context);

  late BSAvailabilityController availabilityController;

  @override
  void initState() {
    super.initState();
    workingHoursController;
    availabilityController =
        BSAvailabilityController(email: widget.email, context: context);
    fetchWorkingHours();
  }

  String formatTime(DateTime? dateTime) {
    if (null == dateTime) {
      return 'Not Set';
    }
    return DateFormat('h:mm a').format(dateTime);
  }

  void fetchWorkingHours() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<WorkingHours> fetchedData =
          await availabilityController.fetchWorkingHoursBS(widget.email);

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

  // Function to parse a time string to TimeOfDay
  TimeOfDay parseTimeOfDay(String timeString) {
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
        actions: [
          SizedBox(
            width: screenWidth * 0.15,
            height: screenHeight * 0.03,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BSEditAvailabilityDatePage(
                        email: widget.email,
                      );
                    },
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 48, 65, 69),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.025,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 48, 65, 69),
                ),
              ),
            ),
          ),
          Gap(screenWidth * 0.02),
        ],
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

                                  String openingTime =
                                      formatTime(dayData['openingTime']);
                                  String closingTime =
                                      formatTime(dayData['closingTime']);

                                  return ListTile(
                                    title: Text(
                                      dayData['day'],
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(screenHeight * 0.015),
                                        Row(
                                          children: [
                                            Text(
                                              'Status: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            Text(
                                              ' ${dayData['status'] == true ? 'SHOP OPEN' : 'SHOP CLOSED'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w700,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(screenHeight * 0.01),
                                        Row(
                                          children: [
                                            Text(
                                              'Opening Time: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            Text(
                                              ' $openingTime',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w700,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(screenHeight * 0.01),
                                        Row(
                                          children: [
                                            Text(
                                              'Closing Time: ',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                            Text(
                                              ' $closingTime',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w700,
                                                color: const Color.fromARGB(
                                                    255, 18, 18, 18),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 186, 199, 206),
                                      radius: 20,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          size: 20,
                                          color:
                                              Color.fromARGB(255, 49, 65, 69),
                                        ),
                                        onPressed: () {
                                          deleteAvailability(dayData['day']);
                                        },
                                      ),
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
