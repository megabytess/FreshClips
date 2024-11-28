import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_appointment_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RescheduledPage extends StatefulWidget {
  const RescheduledPage({
    super.key,
    required this.clientName,
    required this.phoneNumber,
    required this.selectedServices,
    required this.price,
    required this.note,
    required this.status,
    required this.selectedDate,
    required this.selectedTime,
    required this.userEmail,
    required this.appointmentId,
    required this.clientEmail,
  });

  final String clientName;
  final String phoneNumber;
  final List<dynamic> selectedServices;
  final int price;
  final String note;
  final String status;
  final String selectedDate;
  final String selectedTime;
  final String userEmail;
  final String appointmentId;
  final String clientEmail;

  @override
  State<RescheduledPage> createState() => _RescheduledPageState();
}

AppointmentsController appointmentsController = AppointmentsController();

class _RescheduledPageState extends State<RescheduledPage> {
  late String selectedDate;
  late String selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    selectedTime = widget.selectedTime;
  }

  Future<void> selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = DateFormat('MMMM d, yyyy').format(pickedDate);
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final List<TimeOfDay> timeSlots = getTimeSlots();

    showModalBottomSheet(
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
                          selectedTime = ' ${timeSlot.format(context)}';
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

  Future<void> rescheduleAppointment(
    BuildContext context,
    String appointmentId,
    String userEmail,
    String clientEmail,
    String selectedDate,
    String selectedTime,
  ) async {
    // Call the reschedule function from the controller
    await appointmentsController.rescheduleAppointment(
      context,
      appointmentId,
      userEmail,
      clientEmail,
      selectedDate,
      selectedTime,
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
          'Reschedule Appointment',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.035,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 18, 18, 18),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
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
              "Selected Date: $selectedDate",
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(screenHeight * 0.02),
            ElevatedButton(
              onPressed: selectDate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Change Date",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Gap(screenHeight * 0.02),

            Text(
              selectedTime.isNotEmpty ? selectedTime : '',
              style: GoogleFonts.poppins(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w400,
              ),
            ),
            Gap(screenHeight * 0.02),
            ElevatedButton(
              onPressed: () => selectTime(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 48, 65, 69),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.02,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Change Time",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Gap(screenHeight * 0.02),

            // Reschedule Button
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Call the reschedule function
                  await rescheduleAppointment(
                    context,
                    widget.appointmentId,
                    widget.userEmail,
                    widget.clientEmail,
                    selectedDate,
                    selectedTime,
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Confirm Reschedule",
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
