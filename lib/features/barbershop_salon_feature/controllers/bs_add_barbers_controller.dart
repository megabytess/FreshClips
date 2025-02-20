import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BSAddBarberController extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final CollectionReference barberCollection =
  //     FirebaseFirestore.instance.collection('availableBarbers');

  bool isLoading = false;
  BSAddBarberController? bsAddBarber;
  String? affiliatedShop;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

// Get Barbers added by a specific user in Firestore
  // Future<List<BSAddBarbers>> fetchUserBarbers(String userEmail) async {
  //   try {
  //     // Query Firestore collection
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('availableBarbers')
  //         .where('userEmail', isEqualTo: userEmail)
  //         .get();

  //     // Map documents to BSAddBarbers model
  //     return querySnapshot.docs
  //         .map(
  //             (doc) => BSAddBarbers.fromMap(doc.data() as Map<String, dynamic>))
  //         .toList();
  //   } catch (e) {
  //     print('Error retrieving barbers for user $userEmail: $e');
  //     return [];
  //   }
  // }

  // Add Barber
  Future<void> addBarber({
    required String userEmail,
    required Map<String, dynamic> selectedBarber,
    required String role,
    required String status,
    required String availability,
  }) async {
    try {
      // Fetch the shopName from the barbershop account
      QuerySnapshot shopQuerySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: userEmail)
          .get();

      DocumentSnapshot shopSnapshot = shopQuerySnapshot.docs.first;

      String shopName = shopSnapshot['shopName'] ?? 'Unknown Shop';

      await FirebaseFirestore.instance.collection('availableBarbers').add({
        'barberName': selectedBarber['username'],
        'barberEmail': selectedBarber['email'],
        'barberImageUrl': selectedBarber['imageUrl'],
        'affiliatedShop': shopName,
        'role': role,
        'status': status,
        'availability': availability,
        'userEmail': userEmail,
      });
    } catch (e) {
      print('Error adding barber: $e');
    }
  }

  // Edit Barber
  Future<void> editBarber(
      {required String userEmail,
      required String barberName,
      required String role,
      required String status,
      required String availability}) async {
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
          'availability': availability,
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
