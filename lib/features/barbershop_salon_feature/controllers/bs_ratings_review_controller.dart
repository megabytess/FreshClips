import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingsReviewController {
  final String clientEmail;
  final TextEditingController reviewController;
  double rating;

  RatingsReviewController({
    required this.clientEmail,
    required this.reviewController,
    this.rating = 0.0,
  });

  // fetch reviews
  Future<List<Map<String, dynamic>>> fetchAccountReviewss(
      String reviewedEmail, String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [];
      for (var doc in snapshot.docs) {
        reviews.add(doc.data() as Map<String, dynamic>);
      }
      reviews.sort((a, b) {
        return (b['timestamp'] as Timestamp)
            .compareTo(a['timestamp'] as Timestamp);
      });
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Rating 5
  Future<List<Map<String, dynamic>>> fetchRatingFive(
      String reviewedEmail, String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isEqualTo: 5)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [];
      for (var doc in snapshot.docs) {
        reviews.add(doc.data() as Map<String, dynamic>);
      }

      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Rating 4
  Future<List<Map<String, dynamic>>> fetchRatingFour(
      String reviewedEmail, String email) async {
    try {
      // ignore: non_constant_identifier_names
      QuerySnapshot ratingFourSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isEqualTo: 4)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      // ignore: non_constant_identifier_names
      QuerySnapshot ratingFourPointFiveSnapshot = await FirebaseFirestore
          .instance
          .collection('reviews')
          .where('rating', isEqualTo: 4.5)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [
        ...ratingFourSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
        ...ratingFourPointFiveSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
      ];
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

// Rating 3
  Future<List<Map<String, dynamic>>> fetchRatingThree(
      String reviewedEmail, String email) async {
    try {
      // ignore: non_constant_identifier_names
      QuerySnapshot ratingThreeSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isEqualTo: 3)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      // ignore: non_constant_identifier_names
      QuerySnapshot ratingThreePointFiveSnapshot = await FirebaseFirestore
          .instance
          .collection('reviews')
          .where('rating', isEqualTo: 3.5)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [
        ...ratingThreeSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
        ...ratingThreePointFiveSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
      ];
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

// Rating 2
  Future<List<Map<String, dynamic>>> fetchRatingTwo(
      String reviewedEmail, String email) async {
    try {
      // ignore: non_constant_identifier_names
      QuerySnapshot ratingTwoSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isEqualTo: 2)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      // ignore: non_constant_identifier_names
      QuerySnapshot ratingTwoPointFiveSnapshot = await FirebaseFirestore
          .instance
          .collection('reviews')
          .where('rating', isEqualTo: 2.5)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [
        ...ratingTwoSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
        ...ratingTwoPointFiveSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
      ];
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Rating 1
  Future<List<Map<String, dynamic>>> fetchRatingOne(
      String reviewedEmail, String email) async {
    try {
      // ignore: non_constant_identifier_names
      QuerySnapshot ratingOneSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('rating', isEqualTo: 1)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      // ignore: non_constant_identifier_names
      QuerySnapshot ratingOnePointFiveSnapshot = await FirebaseFirestore
          .instance
          .collection('reviews')
          .where('rating', isEqualTo: 1.5)
          .where('reviewedEmail', isEqualTo: email)
          .get();

      List<Map<String, dynamic>> reviews = [
        ...ratingOneSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
        ...ratingOnePointFiveSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>),
      ];
      return reviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  // Compute the average rating for the user
  Future<double> computeAverageRating(String email) async {
    try {
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('reviewedEmail', isEqualTo: email)
          .get();

      if (reviewsSnapshot.docs.isEmpty) {
        return 0.0;
      }

      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += doc['rating'];
      }

      return totalRating / reviewsSnapshot.docs.length;
    } catch (e) {
      print('Error computing average rating: $e');
      return 0.0;
    }
  }

  // void sortbyRating(List<Map<String, dynamic>> reviews) {
  //   reviews.sort((a, b) {
  //     if (b['rating'] > a['rating']) {
  //       return 1;
  //     } else if (b['rating'] < a['rating']) {
  //       return -1;
  //     } else {
  //       return 0;
  //     }
  //   });
  // }
}  // reviews.sort((a, b) {
        //   if (b['rating'] > a['rating']) {
        //     return 1;
        //   } else if (b['rating'] < a['rating']) {
        //     return -1;
        //   } else {
        //     return 0;
        //   }
        // });
