import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/barbershop_salon_model.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/working_hours_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarbershopSalonController extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  BarbershopSalon? barbershopsalon;

  // This function fetches and stores the shop status in SharedPreferences
  Future<void> checkAndStoreShopStatus(String email) async {
    final status = await _getShopStatus(email);
    await _storeShopStatus(status);
  }

  // This function gets the shop status from Firestore and compares with the current time
  Future<String> _getShopStatus(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('availability')
          .where('email', isEqualTo: email)
          .get();

      // Check if data exists for the given email
      if (querySnapshot.docs.isNotEmpty) {
        final workingHoursDoc = querySnapshot.docs.first;
        final workingHoursData = WorkingHours.fromMap(workingHoursDoc.data());

        // Ensure openingTime and closingTime are not null
        if (workingHoursData.openingTime != null &&
            workingHoursData.closingTime != null) {
          // Extract hours and minutes directly from DateTime
          final openingTime = TimeOfDay(
            hour: workingHoursData.openingTime!.hour,
            minute: workingHoursData.openingTime!.minute,
          );
          final closingTime = TimeOfDay(
            hour: workingHoursData.closingTime!.hour,
            minute: workingHoursData.closingTime!.minute,
          );

          // Get current time
          final currentTime = TimeOfDay.now();

          // Compare current time with opening and closing time
          if (_isShopOpen(currentTime, openingTime, closingTime)) {
            return 'Shop Open';
          } else {
            return 'Shop Closed';
          }
        } else {
          return 'Working hours are not available'; // Handle case when working hours are null
        }
      } else {
        return 'No availability data available'; // Handle case when no data is found
      }
    } catch (e) {
      print('Error fetching shop status: $e');
      return 'Error fetching status'; // Return a default message if an error occurs
    }
  }

  // Helper function to check if shop is open based on current time
  bool _isShopOpen(
      TimeOfDay currentTime, TimeOfDay openingTime, TimeOfDay closingTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final openingMinutes = openingTime.hour * 60 + openingTime.minute;
    final closingMinutes = closingTime.hour * 60 + closingTime.minute;

    return currentMinutes >= openingMinutes && currentMinutes <= closingMinutes;
  }

  // Store the shop status in SharedPreferences
  Future<void> _storeShopStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('shopStatus', status);
  }

  // Retrieve the shop status from SharedPreferences
  Future<String> getStoredShopStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('shopStatus') ?? 'No status available';
  }

  // Method to fetch barbershopsalon data from Firestore
  void getBarbershopSalon(String email) async {
    isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No barbershopsalon found with the given email');
        isLoading = false;
        notifyListeners();
        return;
      }

      final documentSnapshot = querySnapshot.docs.first;
      // print('BarbershopSalon found: ${documentSnapshot.data()}');
      barbershopsalon = BarbershopSalon.fromDocument(documentSnapshot);
    } catch (error) {
      print('Error fetching barbershopsalon: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
