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
    try {
      // Query the Firestore collection
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      // Check if any documents were found
      if (querySnapshot.docs.isEmpty) {
        print('No document found for email: $email');
        throw Exception('User not found');
      } else {
        for (var documentSnapshot in querySnapshot.docs) {
          print(
              "Document ID: ${documentSnapshot.id}, Data: ${documentSnapshot.data()}");
          documentSnapshot.data();

          hairstylist = Hairstylist.fromDocument(documentSnapshot);
        }
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching hairstylist: $e');
    }
  }
}
