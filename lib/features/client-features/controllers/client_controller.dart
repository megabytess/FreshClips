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
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No client found with the given email');
        isLoading = false;
        notifyListeners();
        return;
      }

      final documentSnapshot = querySnapshot.docs.first;
      print('Client found: ${documentSnapshot.data()}');
      client = Client.fromDocument(documentSnapshot);
    } catch (error) {
      print('Error fetching client: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
