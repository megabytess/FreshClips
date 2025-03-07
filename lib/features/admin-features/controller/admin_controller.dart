import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminVerifyController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Get pending accounts
  Future<List<Map<String, dynamic>>> getPendingAccounts(String email) async {
    try {
      final QuerySnapshot hairstylistsQuery = await _firestore
          .collection('user')
          .where('userType', isEqualTo: 'Hairstylist')
          .where('accountStatus', isEqualTo: 'Pending')
          .get();

      final QuerySnapshot barbershopSalonQuery = await _firestore
          .collection('user')
          .where('userType', isEqualTo: 'Barbershop_Salon')
          .where('accountStatus', isEqualTo: 'Pending')
          .get();

      List<Map<String, dynamic>> pendingAccounts = [];
      pendingAccounts.addAll(hairstylistsQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>));
      pendingAccounts.addAll(barbershopSalonQuery.docs
          .map((doc) => doc.data() as Map<String, dynamic>));

      print('Pending accounts: $pendingAccounts');

      return pendingAccounts;
    } catch (e) {
      print("Error fetching pending accounts: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> pendingAccountsDetails(
      String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: email)
        .where('accountStatus', isEqualTo: 'Pending')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Approve account
  void approveAccount(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'accountStatus': 'Approved'});
      }
    } catch (e) {
      print("Error approving account: $e");
    }
  }

  // Reject account
  void rejectAccount({required String email, required String reason}) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          'accountStatus': 'Declined',
          'rejectionReason': reason,
        });
      }
      print('Account status updated to Declined.');
    } catch (error) {
      print('Error updating account status: $error');
    }
  }

  // Submit another Image for verification
  void submitAnotherVerification(
      String email, String newVerifyImagePath) async {
    try {
      // Fetch the user document based on the email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user') // Your collection name
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("User not found");
        return;
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('verifications/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(File(newVerifyImagePath));

      final snapshot = await uploadTask.whenComplete(() => null);
      final verifyImageUrl = await snapshot.ref.getDownloadURL();

      for (var doc in querySnapshot.docs) {
        final updateData = {
          'accountStatus': 'Pending',
          'verifyImageUrl': verifyImageUrl,
        };

        await doc.reference.update(updateData);

        print("Account verification resubmitted successfully.");
      }
    } catch (e) {
      print("Error submitting another verification: $e");
    }
  }

  // Fetch all hairstylists
  Future<List<Map<String, dynamic>>> fetchAllHairstylist(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      Query query = firestore
          .collection('user')
          .where('userType', isEqualTo: 'Hairstylist');

      final querySnapshot = await query.get();

      // Optional filtering by email
      if (email.isNotEmpty) {
        query = query.where('email', isEqualTo: email);
      }

      // Map documents to a list of Maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching hairstylists: $e');
      return [];
    }
  }

  // Fetch all clients
  Future<List<Map<String, dynamic>>> fetchAllClients(String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      Query query =
          firestore.collection('user').where('userType', isEqualTo: 'Client');

      final querySnapshot = await query.get();

      // Optional filtering by email
      if (email.isNotEmpty) {
        query = query.where('email', isEqualTo: email);
      }

      // Map documents to a list of Maps
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching clients: $e');
      return [];
    }
  }

  // Fetch all barbershop/salon
  Future<List<Map<String, dynamic>>> fetchAllBarbershopSalon(
      String email) async {
    try {
      final firestore = FirebaseFirestore.instance;

      Query query = firestore
          .collection('user')
          .where('userType', isEqualTo: 'Barbershop_Salon');

      final querySnapshot = await query.get();

      if (email.isNotEmpty) {
        query = query.where('email', isEqualTo: email);
      }

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching barbershop/salon: $e');
      return [];
    }
  }

  // Fetch all reported accounts
  Future<List<Map<String, dynamic>>> fetchReportedAccounts() async {
    try {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore.collection('reports').get();

      final reportedAccounts = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      return reportedAccounts;
    } catch (e) {
      print('Failed to fetch reported accounts: $e');
      throw Exception('Failed to fetch reported accounts: $e');
    }
  }
}
