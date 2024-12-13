import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:intl/intl.dart';

class WorkingHoursController extends ChangeNotifier {
  // Method to set loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Placeholder for availability status
  Map<DateTime, Map<String, dynamic>> availabilityStatus = {};

  bool isLoading = false;
  final String email;
  final BuildContext context;

  WorkingHoursController({required this.email, required this.context});

  // Fetch existing working hours from Firestore
  Future<List<WorkingHours>> fetchWorkingHours(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final docRef =
          firestore.collection('availability').where('email', isEqualTo: email);
      final docSnapshot = await docRef.get();

      if (docSnapshot.docs.isNotEmpty) {
        var docData = docSnapshot.docs.first.data();

        if (docData['workingHours'] != null) {
          List<WorkingHours> workingHoursList = [];
          Map<String, dynamic> hoursData = docData['workingHours'];

          // Loop through each entry (day and availability) in the working hours map
          hoursData.forEach((day, availability) {
            final openingDateTime = availability['openingTime'] != null
                ? (availability['openingTime'] as Timestamp).toDate()
                : null;
            final closingDateTime = availability['closingTime'] != null
                ? (availability['closingTime'] as Timestamp).toDate()
                : null;

            workingHoursList.add(WorkingHours(
              day: day,
              status: availability['status'],
              openingTime: openingDateTime,
              closingTime: closingDateTime,
            ));
          });

          print('Success: Working hours fetched successfully for email $email');
          return workingHoursList;
        } else {
          print('No workingHours data found for email: $email');
        }
      } else {
        print('No document found for email: $email');
      }

      return [];
    } catch (e) {
      print('Error fetching working hours: $e');
      return [];
    }
  }

  // Add or Update working hours in Firestore
  Future<void> addAvailabilityForHairstylist(
      String workingHoursEmail, List<WorkingHours> workingHours) async {
    try {
      setLoading(true);
      final firestore = FirebaseFirestore.instance;

      // Reference to the 'availability' collection
      DocumentReference userAvailabilityDoc =
          firestore.collection('availability').doc();

      // Generate a unique user ID for this availability entry
      String randomUserId = userAvailabilityDoc.id;

      // Convert the list of WorkingHours into a map format where each day's availability is stored as a field
      Map<String, dynamic> availabilityMap = {};
      for (var hours in workingHours) {
        availabilityMap[hours.day] =
            hours.toMap(); // Convert each WorkingHours to a map
      }

      // Add the working hours data directly to the 'availability' document
      await userAvailabilityDoc.set({
        'userId': randomUserId,
        'email': workingHoursEmail,
        'workingHours': availabilityMap, // Stores all 7 days of availability
      });

      print(
          'Success: Availability added for user $workingHoursEmail with userId $randomUserId.');
    } catch (e) {
      print('Error adding availability: $e');
    } finally {
      setLoading(false);
    }
  }

  // Method to update working hours in Firestore
  Future<void> updateWorkingHours(String email, String day, bool status,
      DateTime newOpeningTime, DateTime newClosingTime) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch the document for the given email
      final querySnapshot = await firestore
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;

        // Update the specific day's data in the workingHours map
        await docRef.update({
          'workingHours.$day': {
            'status': status,
            'openingTime': Timestamp.fromDate(newOpeningTime),
            'closingTime': Timestamp.fromDate(newClosingTime),
          }
        });

        print('Working hours updated successfully!');
      } else {
        print('No matching document found for email: $email');
      }
    } catch (e) {
      print('Error updating working hours: $e');
    }
  }

  // Delete working hours for a specific day
  Future<void> deleteWorkingHours(String day) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Find the document where the email matches
      final docSnapshot = await firestore
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        var docData = docSnapshot.docs.first.data();

        DocumentReference docRef = docSnapshot.docs.first.reference;

        // Get the existing working hours map
        Map<String, dynamic> hoursData = docData['workingHours'];

        // Check if the day exists in the working hours map
        if (hoursData.containsKey(day)) {
          hoursData.remove(day);

          // If no working hours remain, delete the entire document
          if (hoursData.isEmpty) {
            await docRef.delete();
            print('Success: All working hours deleted, document removed');
          } else {
            // Otherwise, update the document with the new working hours (without the deleted day)
            await docRef.update({
              'workingHours': hoursData,
            });
            print('Success: Working hours for $day deleted');
          }
        } else {
          print('Error: No entry found for day $day');
        }
      } else {
        print('Error: No availability document found for email $email');
      }
    } catch (e) {
      print('Error deleting working hours: $e');
    }
  }

  // Function to display a time picker for start and end times
  Future<TimeOfDay?> pickTime(TimeOfDay initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }

  WorkingHours dateTimeToWorkingHours(DateTime date) {
    String formattedDay = DateFormat('EEEE, MMMM d, yyyy').format(date);
    return WorkingHours(
      day: formattedDay,
      status: availabilityStatus[date]?['status'] ?? true,
      openingTime: availabilityStatus[date]?['openingTime'],
      closingTime: availabilityStatus[date]?['closingTime'],
    );
  }
}




// // Edit working hours in Firestore
//   Future<void> editUserAvailability({
//     required String email,
//     required String day,
//     required String status,
//     required String openingTime,
//     required String closingTime,
//   }) async {
//     try {
//       // Fetch the document for the specific user based on email
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('availability')
//           .where('email', isEqualTo: email)
//           .limit(1) // Only fetch one document
//           .get();

//       // Check if the document exists
//       if (querySnapshot.docs.isNotEmpty) {
//         final docRef = querySnapshot.docs.first.reference;

//         // Update working hours for the specified day
//         await docRef.update({
//           'workingHours.$day': {
//             'status': status,
//             'openingTime': openingTime,
//             'closingTime': closingTime,
//           },
//         });

//         print('Working hours updated successfully');
//       } else {
//         print('Error: No availability document found for email $email');
//       }
//     } catch (e) {
//       print('Error updating working hours in Firestore: $e');
//     }
//   }