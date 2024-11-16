import 'package:cloud_firestore/cloud_firestore.dart';

class SearchController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to search profiles based on query or fetch all users if query is empty
  Future<List<Map<String, dynamic>>> searchProfile(String query) async {
    try {
      Query<Map<String, dynamic>> querySnapshot = _firestore
          .collection('user')
          .where('userType', whereIn: ['Barbershop_Salon', 'Hairstylist']);

      // Filter based on query if it's not empty
      if (query.isNotEmpty) {
        querySnapshot = querySnapshot
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username', isLessThanOrEqualTo: '$query\uf8ff');
      }

      // Fetch the results from Firestore
      QuerySnapshot<Map<String, dynamic>> snapshot = await querySnapshot.get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error during search: $e");
      return [];
    }
  }
}
