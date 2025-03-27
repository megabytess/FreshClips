import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:geolocator/geolocator.dart';

class SearchController extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

// filter the accounts in search page
  Future<List<Map<String, dynamic>>> filterByUsertype(
      String query,
      String selectedCategory,
      RatingsReviewController ratingsReviewController) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('userType', isEqualTo: selectedCategory)
          .get();

      // 🔥 Compute ratings asynchronously for each user
      List<Map<String, dynamic>> filteredResults = await Future.wait(
        querySnapshot.docs.map((doc) async {
          Map<String, dynamic> userData = doc.data();
          userData['rating'] = await ratingsReviewController
              .computeAverageRating(userData['email']);
          return userData;
        }).toList(),
      );

      // 🔥 Sort by rating (Highest first)
      filteredResults.sort((a, b) {
        double ratingA = (a['rating'] ?? 0).toDouble();
        double ratingB = (b['rating'] ?? 0).toDouble();
        return ratingB.compareTo(ratingA); // Descending order
      });

      return filteredResults;
    } catch (e) {
      print("Error fetching filtered results: $e");
      return [];
    }
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

// fetched user by userType
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
