import 'package:cloud_firestore/cloud_firestore.dart';

class BSProfileController {
  // Method to fetch barbershop/salon profile data from Firebase
  Future<DocumentSnapshot> fetchProfileData(String userId) async {
    try {
      // Fetch the profile document from the 'barbershops' collection
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('user') // Adjust the collection name as per your database
          .doc(userId)
          .get();

      return profileSnapshot;
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }
}
