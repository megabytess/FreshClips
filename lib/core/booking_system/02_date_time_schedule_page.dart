import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/03_info_details_page.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/services_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSchedulePage extends StatefulWidget {
  const DateTimeSchedulePage({
    super.key,
    required this.selectedServices,
    // required this.userType,

    required this.userEmail,
    required this.clientEmail,
  });

  final List<Service> selectedServices;
  // final String userType;

  final String userEmail;
  final String clientEmail;

  @override
  State<DateTimeSchedulePage> createState() => _DateTimeSchedulePageState();
}

class _DateTimeSchedulePageState extends State<DateTimeSchedulePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TimeOfDay? selectedTime;
  List<TimeOfDay> unavailableTimeSlots = [];

  List<TimeOfDay> getTimeSlots() {
    List<TimeOfDay> timeSlots = [];
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 15);
    TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0);

    while (startTime.hour < endTime.hour ||
        (startTime.hour == endTime.hour &&
            startTime.minute <= endTime.minute)) {
      timeSlots.add(startTime);
      int newMinute = startTime.minute + 30;
      int newHour = startTime.hour + (newMinute ~/ 60);
      newMinute = newMinute % 60;

      startTime = TimeOfDay(hour: newHour, minute: newMinute);
    }

    return timeSlots;
  }

  Future<void> selectTime(BuildContext context) async {
    getTimeSlots();

    final List<TimeOfDay> timeSlots = getTimeSlots();

    showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          height: MediaQuery.of(context).size.height * 0.5,
          child: GridView.builder(
            itemCount: timeSlots.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: MediaQuery.of(context).size.width * 0.02,
              mainAxisSpacing: MediaQuery.of(context).size.height * 0.02,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              final timeSlot = timeSlots[index];
              final isUnavailable = unavailableTimeSlots.contains(timeSlot);

              return GestureDetector(
                onTap: isUnavailable
                    ? null
                    : () {
                        setState(() {
                          selectedTime = timeSlot;
                        });
                        Navigator.pop(context);
                      },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isUnavailable ? Colors.grey : Colors.grey[400],
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04),
                    border: Border.all(
                      color: const Color.fromARGB(255, 48, 65, 69),
                    ),
                  ),
                  child: Text(
                    timeSlot.format(context),
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: isUnavailable ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> confirmBooking() async {
    if (selectedTime != null) {
      // Prepare the booking data to pass to the next page
      final bookingData = {
        'userId': widget.userEmail,

        'selectedServices':
            widget.selectedServices.map((service) => service.toMap()).toList(),
        // 'userType': widget.userType,
        'selectedDate': _selectedDay,
        // Store hour and minute separately
        'hour': selectedTime!.hour,
        'minute': selectedTime!.minute,
      };

      // Navigate to the confirmation page with the booking data
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => InfoDetailsPage(
            bookingData: bookingData, // Pass the data directly

            selectedDate: _selectedDay,
            selectedTime: selectedTime!,
            selectedServices: widget.selectedServices,
            // userType: widget.userType,
            userEmail: widget.userEmail,
            clientEmail: widget.clientEmail,
          ),
        ),
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
          'Time & Date',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.0001,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    getTimeSlots();
                  },
                  calendarStyle: const CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 48, 65, 69),
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 186, 199, 206),
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gap(screenHeight * 0.02),
                Text(
                  'Select Time',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(screenHeight * 0.01),
                GestureDetector(
                  onTap: () => selectTime(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.05,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : 'Select Time',
                          style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: SizedBox(
                width: double.infinity,
                height: screenHeight * 0.07,
                child: ElevatedButton(
                  onPressed: confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      color: const Color.fromARGB(255, 248, 248, 248),
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
