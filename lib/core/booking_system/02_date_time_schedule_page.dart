import 'package:flutter/material.dart';
import 'package:freshclips_capstone/core/booking_system/03_info_details_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class DateTimeSchedulePage extends StatefulWidget {
  const DateTimeSchedulePage({super.key});

  @override
  State<DateTimeSchedulePage> createState() => _DateTimeSchedulePageState();
}

class _DateTimeSchedulePageState extends State<DateTimeSchedulePage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  TimeOfDay? selectedTime;

  List<TimeOfDay> getTimeSlots() {
    List<TimeOfDay> timeSlots = [];
    TimeOfDay startTime = const TimeOfDay(hour: 10, minute: 0); // 10:00 AM
    TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM

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

  Future<void> _selectTime(BuildContext context) async {
    final List<TimeOfDay> timeSlots = getTimeSlots();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02),
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
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTime = timeSlots[index];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.02),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Text(
                    timeSlots[index].format(context),
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'BarberShop Name ni dapat',
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
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Date',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(screenHeight * 0.02),
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
              onTap: () => _selectTime(context),
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
            Gap(screenHeight * 0.05),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoDetailsPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                  ),
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
          ],
        ),
      ),
    );
  }
}
