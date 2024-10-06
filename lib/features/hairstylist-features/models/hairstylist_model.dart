class Hairstylist {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String skills;
  final int yearsOfExperience;
  final String location;
  final String imageUrl;
  final String password; // Store hashed password for security

  Hairstylist({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.skills,
    required this.yearsOfExperience,
    required this.location,
    required this.imageUrl,
    required this.password,
  });

  factory Hairstylist.fromJson(Map<String, dynamic> json) {
    return Hairstylist(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      skills: json['skills'],
      yearsOfExperience: json['yearsOfExperience'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      password:
          json['password'], // Handle password hashing and storage securely
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freshclips_capstone/models/hairstylist.dart';

// Future<Hairstylist> getHairstylistById(String hairstylistId) async {
//   final hairstylistDoc = await FirebaseFirestore.instance.collection('hairstylists').doc(hairstylistId).get();
//   if (hairstylistDoc.exists) {
//     return Hairstylist.fromJson(hairstylistDoc.data()!);
//   } else {
//     throw Exception('Hairstylist not found');
//   }
// }