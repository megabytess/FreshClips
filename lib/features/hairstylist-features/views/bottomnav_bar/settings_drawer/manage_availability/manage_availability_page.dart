import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManageAvailabilityPage extends StatefulWidget {
  const ManageAvailabilityPage({super.key, required this.email});
  final String email;

  @override
  State<ManageAvailabilityPage> createState() => _ManageAvailabilityPageState();
}

class _ManageAvailabilityPageState extends State<ManageAvailabilityPage> {
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
          // Assuming the 'day' field is in the format "Monday, October 28, 2024"
          // Use DateFormat to parse this format into a DateTime object
          DateTime parsedDate;
          try {
            parsedDate =
                DateFormat('EEEE, MMMM dd, yyyy').parse(workingHour.day);
          } catch (e) {
            // If parsing fails, set a default value or handle error
            print('Error parsing date: $e');
            parsedDate = DateTime.now(); // Default to current date
          }

          return {
            'day': workingHour.day,
            'status': workingHour.status,
            'date': parsedDate
                .toIso8601String(), // Store date in ISO format for sorting
          };
        }).toList();

        // Sort by date in ascending order
        availabilityData.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateA.compareTo(dateB); // Ascending order
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
                      child: availabilityData.isEmpty
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

                                // Parse the date string to DateTime format for display
                                DateTime parsedDate =
                                    DateTime.parse(dayData['date']);
                                String formattedDate =
                                    DateFormat('MMMM dd, yyyy').format(
                                        parsedDate); // Format: e.g., October 18, 2024
                                String dayOfWeek = DateFormat('EEEE')
                                    .format(parsedDate); // Format: e.g., Monday

                                return ListTile(
                                  title: Text(
                                    '$formattedDate, $dayOfWeek', // Concatenate date and day of the week
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    dayData['status'],
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            )),
                  availabilityData.isEmpty
                      ? SizedBox(
                          height: screenHeight * 0.07,
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Add Availability Page
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_circle_outlined,
                                  size: screenWidth * 0.06,
                                  color:
                                      const Color.fromARGB(255, 248, 248, 248),
                                ),
                                Gap(screenWidth * 0.02),
                                Text(
                                  'Add availability',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromARGB(
                                        255, 248, 248, 248),
                                  ),
                                ),
                              ],
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
