import 'package:cloud_firestore/cloud_firestore.dart';

class SearchController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> searchProfile(String username) async {
    if (username.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('user')
          .where('userType',
              whereIn: ['Barbershop_Salon', 'Hairstylist']).get();

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
}
