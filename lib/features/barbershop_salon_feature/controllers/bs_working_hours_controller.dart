import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:intl/intl.dart';

class BSAvailabilityController extends ChangeNotifier {
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isLoading = false;
  final String email;
  final BuildContext context;

  BSAvailabilityController({required this.email, required this.context});

  TimeOfDay parseTimeOfDay(String time) {
    final format = DateFormat.jm(); // '5:30 PM'
    final dateTime = format.parse(time);
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  // Fetch existing working hours from Firestore
  Future<List<WorkingHours>> fetchWorkingHoursBS(String email) async {
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
  Future<void> addAvailabilityForBS(
      String email, List<WorkingHours> workingHours) async {
    try {
      setLoading(true);
      final firestore = FirebaseFirestore.instance;

      DocumentReference userAvailabilityDoc =
          firestore.collection('availability').doc();

      String randomUserId = userAvailabilityDoc.id;

      Map<String, dynamic> availabilityMap = {};
      for (var hours in workingHours) {
        availabilityMap[hours.day] = hours.toMap();
      }

      await userAvailabilityDoc.set({
        'userId': randomUserId,
        'email': email,
        'workingHours': availabilityMap, // Stores all 7 days of availability
      });

      print(
          'Success: Availability added for user $email with userId $randomUserId.');
    } catch (e) {
      print('Error adding availability: $e');
    } finally {
      setLoading(false);
    }
  }

// Update working hours BS
  Future<void> updateWorkingHoursBS(String email, String day, bool status,
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

  // Function to display a time picker for start and end times
  Future<TimeOfDay?> pickTime(TimeOfDay initialTime) async {
    return showTimePicker(
      context: context,
      initialTime: initialTime,
    );
  }
}
