import 'package:cloud_firestore/cloud_firestore.dart';

class SearchController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Search for users by username
  Future<List<Map<String, dynamic>>> searchByUsername(String username) async {
    try {
      final normalizedUsername = username.toLowerCase();

      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('username', isGreaterThanOrEqualTo: normalizedUsername)
          .where('username', isLessThanOrEqualTo: '$normalizedUsername\uf8ff')
          .get();

      final filteredResults = querySnapshot.docs
          .where((doc) =>
              ['Barbershop_Salon', 'Hairstylist'].contains(doc['userType']))
          .map((doc) => doc.data())
          .toList();

      return filteredResults;
    } catch (e) {
      print("Error fetching search results: $e");
      return [];
    }
  }

// filter the accounts in search page
  Future<List<Map<String, dynamic>>> filterByUsertype(
      String query, String selectedCategory) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('userType', isEqualTo: selectedCategory)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

// Search for hairstylist users for ADD BARBERS
  Future<List<Map<String, dynamic>>> searchHairstylistUser(
      String username) async {
    if (username.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('user')
          .where('userType', whereIn: ['Hairstylist']).get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('user')
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: '$username\uf8ff')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error during search: $e");
      return [];
    }
  }

  //Affiliated Barbers
  Future<List<Map<String, dynamic>>> fetchAffiliatedBarbers(
      String userEmail) async {
    try {
      // Fetching documents where 'userEmail' matches the given parameter
      final barbersSnapshot = await FirebaseFirestore.instance
          .collection('availableBarbers')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      // Map each document's data to a list of maps
      return barbersSnapshot.docs.map((doc) {
        return {
          'affiliatedShop':
              doc['affiliatedShop'] ?? '', // Default to an empty string if null
          'availability': doc['availability'] ?? '',
          'barberEmail': doc['barberEmail'] ?? '',
          'barberImageUrl': doc['barberImageUrl'] ?? '',
          'barberName': doc['barberName'] ?? '',
          'role': doc['role'] ?? '',
          'status': doc['status'] ?? '',
          'userEmail': doc['userEmail'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Error fetching affiliated barbers: $e');
      return [];
    }
  }
}
