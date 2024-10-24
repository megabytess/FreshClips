import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/hairstylist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HairstylistController extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  Hairstylist? hairstylist;

  String _selectedStatus = 'SHOP OPEN'; // Default value

  // Getter for selectedStatus
  String get selectedStatus => _selectedStatus;

  // Update status and save to SharedPreferences
  void updateStatus(String newStatus) async {
    _selectedStatus = newStatus;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('hairstylist_status', newStatus);
  }

  // Load the status from SharedPreferences when initializing
  Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedStatus = prefs.getString('hairstylist_status') ??
        'SHOP CLOSED'; // Default to 'OPEN NOW'
    notifyListeners();
  }

  // Method to fetch hairstylist data from Firestore
  void getHairstylist(String email) async {
    isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No hairstylist found with the given email');
        isLoading = false;
        notifyListeners();
        return;
      }

      final documentSnapshot = querySnapshot.docs.first;
      print('Hairstylist found: ${documentSnapshot.data()}');
      hairstylist = Hairstylist.fromDocument(documentSnapshot);
    } catch (error) {
      print('Error fetching hairstylist: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
