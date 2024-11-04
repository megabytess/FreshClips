import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/barbershop_salon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarbershopSalonController extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  BarbershopSalon? barbershopsalon;

  String _selectedStatus = 'SHOP OPEN'; // Default value

  // Getter for selectedStatus
  String get selectedStatus => _selectedStatus;

  // Update status and save to SharedPreferences
  void updateStatus(String newStatus) async {
    _selectedStatus = newStatus;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('bs_status', newStatus);
  }

  // Load the status from SharedPreferences when initializing
  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedStatus = prefs.getString('bs_status') ?? 'SHOP CLOSED';
    notifyListeners();
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
      print('BarbershopSalon found: ${documentSnapshot.data()}');
      barbershopsalon = BarbershopSalon.fromDocument(documentSnapshot);
    } catch (error) {
      print('Error fetching barbershopsalon: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
