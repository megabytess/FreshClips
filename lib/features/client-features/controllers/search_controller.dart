import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SearchController extends ChangeNotifier {
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
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('availableBarbers')
          .where('userEmail', isEqualTo: userEmail)
          .get();

      // Log the query result for debugging
      print('Fetched Barbers: ${snapshot.docs.length}');

      // Map the results into a list of barbers
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching affiliated barbers: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> filterByNearbyUsertype(
      String query,
      String selectedCategory,
      Position currentPosition,
      double radiusInMeters) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('userType', isEqualTo: selectedCategory)
        .get();

    List<Map<String, dynamic>> filteredUsers = [];
    // final RatingsReviewController ratingsReviewController =
    //     RatingsReviewController(
    //   clientEmail: clientEmail,
    //   reviewController: reviewController,
    // );

    for (var doc in querySnapshot.docs) {
      var data = doc.data();

      if (data.containsKey('location') &&
          data['location'] is Map<String, dynamic> &&
          data['location'].containsKey('latitude') &&
          data['location'].containsKey('longitude')) {
        double userLat = data['location']['latitude'] ?? 0.0;
        double userLng = data['location']['longitude'] ?? 0.0;

        double distance = Geolocator.distanceBetween(
          currentPosition.latitude,
          currentPosition.longitude,
          userLat,
          userLng,
        );

        if (distance <= radiusInMeters) {
          String accountName;
          if (data['userType'] == 'Barbershop_Salon') {
            accountName = data['shopName'] ?? 'Unknown Shop';
          } else if (data['userType'] == 'Hairstylist') {
            accountName =
                '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
          } else {
            accountName = 'Unknown';
          }

          filteredUsers.add({
            'accountName': accountName,
            'userType': data['userType'],
            'distance': double.parse((distance / 1000).toStringAsFixed(2)),
            'imageUrl': data['imageUrl'],
            'email': data['email'],
            'username': data['username'],
            'location': data['location'],
            // 'rating': await ratingsReviewController.computeAverageRating(
            //   data['email'],
            // ),
          });

          debugPrint(
              "User: $accountName, Distance: ${(distance / 1000).toStringAsFixed(2)} km");
        }
      }
    }

    return filteredUsers;
  }
}
