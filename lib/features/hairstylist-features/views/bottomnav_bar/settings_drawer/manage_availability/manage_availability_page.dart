import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/controllers/working_hours_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/bottomnav_bar/settings_drawer/manage_availability/add_availability_date_page.dart';
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

  // // edit availability functionality
  // void editAvailability(String day, bool currentStatus,
  //     DateTime currentOpeningTime, DateTime currentClosingTime) async {
  //   // Parse the provided times

  //   bool selectedStatus = currentStatus;

  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //             title: Text(
  //               'Edit Availability',
  //               style: GoogleFonts.poppins(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 DropdownButtonFormField<bool>(
  //                   value: selectedStatus,
  //                   items: [true, false].map((bool status) {
  //                     return DropdownMenuItem<bool>(
  //                       value: status,
  //                       child: Text(status ? 'Shop Open' : 'Shop Closed'),
  //                     );
  //                   }).toList(),
  //                   onChanged: (newStatus) {
  //                     setState(() {
  //                       selectedStatus = newStatus!;
  //                     });
  //                   },
  //                   decoration: InputDecoration(
  //                     labelText: 'Status',
  //                     hintStyle: GoogleFonts.poppins(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Opening Time: ${formatTime(currentOpeningTime)}',
  //                       style: GoogleFonts.poppins(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     TextButton(
  //                       onPressed: () async {
  //                         final pickedTime = await showTimePicker(
  //                           context: context,
  //                           initialTime: TimeOfDay.now(),
  //                         );
  //                         DateTime newOpeningTime = DateTime(
  //                           DateTime.now().year,
  //                           DateTime.now().month,
  //                           DateTime.now().day,
  //                           pickedTime?.hour ?? TimeOfDay.now().hour,
  //                           pickedTime?.minute ?? TimeOfDay.now().minute,
  //                         );
  //                         if (pickedTime != null) {
  //                           setState(() {
  //                             newOpeningTime = newOpeningTime;
  //                           });
  //                         }
  //                       },
  //                       child: Text(
  //                         'Change',
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                           color: const Color.fromARGB(255, 189, 49, 71),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text(
  //                       'Closing Time:  ${formatTime(currentOpeningTime)}',
  //                       style: GoogleFonts.poppins(
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                     TextButton(
  //                       onPressed: () async {
  //                         final pickedTime = await showTimePicker(
  //                           context: context,
  //                           initialTime: TimeOfDay.now(),
  //                         );
  //                         DateTime newClosingTime = DateTime(
  //                           DateTime.now().year,
  //                           DateTime.now().month,
  //                           DateTime.now().day,
  //                           pickedTime?.hour ?? TimeOfDay.now().hour,
  //                           pickedTime?.minute ?? TimeOfDay.now().minute,
  //                         );
  //                         if (pickedTime != null) {
  //                           setState(() {
  //                             newClosingTime = newClosingTime;
  //                           });
  //                         }
  //                       },
  //                       child: Text(
  //                         'Change',
  //                         style: GoogleFonts.poppins(
  //                           fontSize: 12,
  //                           fontWeight: FontWeight.w500,
  //                           color: const Color.fromARGB(255, 189, 49, 71),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text(
  //                   'Cancel',
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: const Color.fromARGB(255, 18, 18, 18),
  //                   ),
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () async {
  //                   await editWorkingHours(
  //                     day,
  //                     selectedStatus,
  //                     // formattedOpeningTime,
  //                     currentOpeningTime,
  //                     currentClosingTime,
  //                   );
  //                   fetchWorkingHours(); // Refresh the data after edit
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(
  //                   'Save',
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                     color: const Color.fromARGB(255, 18, 18, 18),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Function to edit working hours
  // Future<void> editWorkingHours(String day, bool status, DateTime openingTime,
  //     DateTime closingTime) async {
  //   try {
  //     await workingHoursController.updateWorkingHours(
  //         widget.email, day, status, openingTime, closingTime);
  //   } catch (e) {
  //     print('Error editing working hours: $e');
  //   }
  // }

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
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AvailabilityDatePage(
                      email: widget.email,
                    );
                  },
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              ),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.025,
                  fontWeight: FontWeight.w500,
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
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Status: ${dayData['status'] == true ? 'Shop Open' : 'Shop Closed'}',
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
                                          icon: const Icon(Icons.delete_rounded,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 189, 49, 71)),
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
