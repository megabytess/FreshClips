import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/barbershop_salon_model.dart';

class BarbershopSalonController extends ChangeNotifier {
  bool isLoading = false;
  String? email;
  BarbershopSalon? barbershopsalon;

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
