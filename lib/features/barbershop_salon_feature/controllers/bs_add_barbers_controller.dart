import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_add_barbers_model.dart';

class BSAddBarberController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference barberCollection =
      FirebaseFirestore.instance.collection('availableBarbers');

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners(); // Notify listeners when the loading state changes
  }

// Get Barbers added by a specific user in Firestore
  Future<List<BSAddBarbers>> fetchUserBarbers(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('availableBarbers')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      return querySnapshot.docs
          .map(
              (doc) => BSAddBarbers.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error retrieving barbers for user $userEmail: $e');
      return [];
    }
  }

  // Add Barber
  Future<void> addBarber({
    required String userEmail,
    required String barberName,
    required String role,
    required String status,
    required List<String> availability,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('availableBarbers').add({
        'barberName': barberName,
        'role': role,
        'status': status,
        'availability': availability.join(', '),
        'userEmail': userEmail,
      });
    } catch (e) {
      print('Error adding barber: $e');
    }
  }

  // Edit Barber
  Future<void> editBarber(
    BSAddBarbers updatedService, {
    required String userEmail,
    required String barberName,
    required String role,
    required String status,
    required List<String> availability,
  }) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('availableBarbers')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.update({
          'barberName': barberName,
          'role': role,
          'status': status,
          'availability': availability.join(', '),
        });
      }
    } catch (e) {
      print('Error updating barber: $e');
    }
  }

  Future<void> deleteBarbers(String userEmail, String barberId) async {
    await FirebaseFirestore.instance
        .collection('availableBarbers')
        .doc(barberId)
        .delete();
  }
}
