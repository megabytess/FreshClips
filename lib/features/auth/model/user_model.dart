import 'package:freshclips_capstone/core/enum/enum.dart';

class User {
  final String uid;
  final String email;
  final String displayName;
  final String firstName;
  final String lastName;
  final UserType userType;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userType: UserType.values.byName(json['userType']),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freshclips_capstone/models/user.dart';

// Future<User> getUserById(String userId) async {
//   final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
//   if (userDoc.exists) {
//     return User.fromJson(userDoc.data()!);   

//   } else {
//     throw Exception('User not found');
//   }
// }