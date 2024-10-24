import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';

class WorkingHoursController extends ChangeNotifier {
  // Method to set loading state
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isLoading = false;
  final String email;
  final BuildContext context;

  WorkingHoursController({required this.email, required this.context});

  // Fetch existing working hours from Firestore
  Future<List<WorkingHours>> fetchWorkingHours(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch the document where the email matches the provided user
      final docSnapshot = await firestore
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        // Extract the first document's data
        var docData = docSnapshot.docs.first.data();

        // Check if 'workingHours' field exists and is a Map
        if (docData['workingHours'] != null) {
          List<WorkingHours> workingHoursList = [];
          Map<String, dynamic> hoursData = docData['workingHours'];

          // Loop through each entry (day and status) in the working hours map
          hoursData.forEach((day, availability) {
            workingHoursList.add(WorkingHours(
              day: day,
              status: availability['status'],
            ));
          });

          print('Success: Working hours fetched successfully for email $email');
          return workingHoursList;
        }
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

      String randomUserId = userAvailabilityDoc.id;

      // Convert the list of workingHours into a map format where each day's availability is stored as a field
      Map<String, dynamic> availabilityMap = {};
      for (var hours in workingHours) {
        availabilityMap[hours.day] = hours.toMap();
      }

      // Add the working hours data directly to the 'availability' document
      await userAvailabilityDoc.set({
        'userId': randomUserId,
        'email': workingHoursEmail,
        'workingHours': availabilityMap, // 7 days of availability as fields
      });

      print(
          'Success: Availability added for user $workingHoursEmail with userId $randomUserId.');
    } catch (e) {
      print('Error adding availability: $e');
    } finally {
      setLoading(false);
    }
  }

// Edit working hours in Firestore
  Future<void> editWorkingHours(String day, String newStatus) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Find the document where the email matches
      final docSnapshot = await firestore
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        var docData = docSnapshot.docs.first.data();

        // Get the reference to the document
        DocumentReference docRef = docSnapshot.docs.first.reference;

        // Get the existing working hours map
        Map<String, dynamic> hoursData = docData['workingHours'];

        // Update the status for the given day
        if (hoursData.containsKey(day)) {
          hoursData[day]['status'] = newStatus;

          // Update the document with the new working hours
          await docRef.update({
            'workingHours': hoursData,
          });

          print('Success: Working hours updated for day $day');
        } else {
          print('Error: No entry found for day $day');
        }
      } else {
        print('Error: No availability document found for email $email');
      }
    } catch (e) {
      print('Error editing working hours: $e');
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
}
