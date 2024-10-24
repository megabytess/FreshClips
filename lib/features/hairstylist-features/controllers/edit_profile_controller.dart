import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/hairstylist-features/models/hairstylist_model.dart';

class ProfileController extends ChangeNotifier {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Hairstylist? hairstylist;

  // Set loading state
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Method to fetch hairstylist data from Firestore
  Future<DocumentSnapshot?> fetchHairstylist(String email) async {
    _setLoading(true);

    try {
      final querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final documentSnapshot = querySnapshot.docs.first;
        print('Hairstylist found: ${documentSnapshot.data()}');

        // Create a Hairstylist object from the document data
        hairstylist = Hairstylist.fromDocument(documentSnapshot);
        return documentSnapshot;
      } else {
        print('User document not found for email: $email');
        return null;
      }
    } catch (error) {
      print('Error fetching hairstylist: $error');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserProfile(
      String email, Map<String, dynamic> updatedData) async {
    _setLoading(true);

    try {
      final querySnapshot = await _firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final userDoc = querySnapshot.docs.first;
        print('Updating user profile for ${userDoc.id}');

        // Update the Firestore document with the provided data
        await _firestore.collection('user').doc(userDoc.id).update(updatedData);

        print('User profile updated successfully');
      } else {
        print('User document not found for email (fetch): $email');
      }
    } catch (error) {
      print('Error updating user profile: $error');
    } finally {
      _setLoading(false);
    }
  }

  // Delete user profile
  Future<void> deleteUserProfile(String email) async {
    _setLoading(true);

    try {
      // Fetch the user document by email
      DocumentSnapshot? userDoc = await fetchHairstylist(email);

      if (userDoc != null) {
        // Delete Firestore document by document ID
        await _firestore.collection('user').doc(userDoc.id).delete();

        // Clear the profile data after deletion
        hairstylist = null;
        notifyListeners(); // Notify UI that profile has been deleted
        print('User profile deleted successfully');
      } else {
        print('User document not found for email: $email');
      }
    } catch (e) {
      print('Error deleting profile: $e');
    } finally {
      _setLoading(false);
    }
  }
}
