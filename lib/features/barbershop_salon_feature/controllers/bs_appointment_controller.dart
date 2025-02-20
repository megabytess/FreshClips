// appointments_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentsController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getPendingAppointments(String userEmail) {
    return firestore
        .collection('appointments')
        .where('bookedUser', isEqualTo: userEmail)
        .where('status', isEqualTo: 'Pending')
        .snapshots();
  }

  void approveAppointment(
      BuildContext context, String appointmentId, String userEmail) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'status': 'Approved',
      });

      print("Appointment approved successfully!");
    } catch (e) {
      print("Error approving appointment: $e");
    }
  }

  void declineAppointment(
      BuildContext context, String appointmentId, String userEmail) async {
    TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(
            'Input a Valid Reason',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextFormField(
            controller: reasonController,
            decoration: InputDecoration(
              labelText: 'Reason for declining',
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  try {
                    await firestore
                        .collection('appointments')
                        .doc(appointmentId)
                        .update({
                      'status': 'Declined',
                      'declinedReason': reason,
                    });
                    print("Appointment declined successfully!");
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Error declining appointment: $e");
                  }
                } else {
                  print("Reason cannot be empty");
                }
              },
              child: Text(
                'Submit',
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
  }

  void completeAppointment(
      BuildContext context, String appointmentId, String userEmail) async {
    try {
      await firestore.collection('appointments').doc(appointmentId).update({
        'status': 'Completed',
      });

      print("Appointment completed successfully!");
    } catch (e) {
      print("Error completing appointment: $e");
    }
  }

  // void deleteAppointment(BuildContext context, String appointmentId) async {
  //   try {
  //     await firestore.collection('appointments').doc(appointmentId).delete();

  //     print("Appointment deleted successfully!");

  //     Navigator.pop(context);
  //   } catch (e) {
  //     print("Error deleting appointment: $e");
  //   }
  // }

  Future<void> rescheduleAppointment(
      BuildContext context,
      String appointmentId,
      String userEmail,
      String clientEmail,
      String newDate,
      String newTime) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('appointments').doc(appointmentId).update({
        'status': 'Pending',
        'selectedDate': newDate,
        'selectedTime': newTime,
      });

      print("Appointment rescheduled successfully!");
    } catch (e) {
      print("Error rescheduling appointment: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchApprovedAppointments() async {
    try {
      // Query Firestore to get the approved appointments
      final snapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: 'Approved')
          .get();

      // Map the query result to a list of maps
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching approved appointments: $e");
      return []; // Return an empty list on error
    }
  }

  /// Checks if a time slot is available for a given user on a specific date.
  // Future<bool> isTimeSlotAvailable({
  //   required String userEmail,
  //   required DateTime selectedDate,
  //   required TimeOfDay selectedTime,
  // }) async {
  //   // Format date and time for Firestore query
  //   final formattedDate =
  //       '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
  //   final formattedTime = '${selectedTime.hour}:${selectedTime.minute}';

  //   // Query Firestore for matching appointments
  //   final querySnapshot = await firestore
  //       .collection('appointments')
  //       .where('bookedUser', isEqualTo: userEmail)
  //       .where('selectedDate', isEqualTo: formattedDate)
  //       .where('selectedTime', isEqualTo: formattedTime)
  //       .get();

  //   // Return true if no conflicts are found
  //   return querySnapshot.docs.isEmpty;
  // }

  /// Blocks a time slot by adding it to the unavailable slots collection.
  // Future<void> blockTimeSlot({
  //   required String userEmail,
  //   required DateTime selectedDate,
  //   required TimeOfDay selectedTime,
  //   String? reason, // Optional reason for blocking
  // }) async {
  //   // Format date and time
  //   final formattedDate =
  //       '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
  //   final formattedTime = '${selectedTime.hour}:${selectedTime.minute}';

  //   // Add the blocked slot to Firestore
  //   await firestore.collection('unavailableTimeSlots').add({
  //     'userEmail': userEmail,
  //     'selectedDate': formattedDate,
  //     'selectedTime': formattedTime,
  //     'reason': reason ?? 'Time already booked',
  //     'timestamp': FieldValue.serverTimestamp(),
  //   });
  // }

  /// Automatically blocks a time slot if it's already used.
  // Future<void> checkAndBlockTimeSlot({
  //   required String userEmail,
  //   required DateTime selectedDate,
  //   required TimeOfDay selectedTime,
  //   String? reason,
  // }) async {
  //   final isAvailable = await isTimeSlotAvailable(
  //     userEmail: userEmail,
  //     selectedDate: selectedDate,
  //     selectedTime: selectedTime,
  //   );

  //   if (!isAvailable) {
  //     // Block the time slot if it's unavailable
  //     await blockTimeSlot(
  //       userEmail: userEmail,
  //       selectedDate: selectedDate,
  //       selectedTime: selectedTime,
  //       reason: reason ?? 'Time slot unavailable due to booking',
  //     );
  //   }
  // }

  /// Retrieves all unavailable time slots for a user on a specific date.
  Future<List<Map<String, dynamic>>> getUnavailableSlots({
    required String userEmail,
    required DateTime selectedDate,
  }) async {
    final formattedDate =
        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';

    final querySnapshot = await firestore
        .collection('unavailableTimeSlots')
        .where('userEmail', isEqualTo: userEmail)
        .where('selectedDate', isEqualTo: formattedDate)
        .get();

    // Convert Firestore documents to a list of maps
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
