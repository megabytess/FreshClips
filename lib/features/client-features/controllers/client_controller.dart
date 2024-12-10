import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/client-features/models/client_model.dart';

class ClientController extends ChangeNotifier {
  Client? client;
  bool isLoading = false;
  String? email;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchClientData(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No document found for email: $email');
        throw Exception('User not found');
      } else {
        for (var documentSnapshot in querySnapshot.docs) {
          print(
              "Document ID: ${documentSnapshot.id}, Data: ${documentSnapshot.data()}");
          client = Client.fromDocument(documentSnapshot);
        }
      }
    } catch (e) {
      print("Error fetching client data: $e");
      client = null;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateClientProfile(
      String email, Map<String, dynamic> updatedData) async {
    setLoading(true);

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        print('Updating user profile for ${userDoc.id}');

        // Update the Firestore document with the provided data
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userDoc.id)
            .update(updatedData);
        print('User profile updated successfully');
      } else {
        print('User document not found for email (fetch): $email');
      }
    } catch (error) {
      print('Error updating user profile: $error');
    } finally {
      setLoading(false);
    }
  }
}
