import 'package:cloud_firestore/cloud_firestore.dart';

class Hairstylist {
  final String id;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final String location;
  final String skills;
  final int yearsOfExperience;

  Hairstylist({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.location,
    required this.skills,
    required this.yearsOfExperience,
  });

  // Convert Hairstylist instance to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'location': location,
      'skills': skills,
      'yearsOfExperience': yearsOfExperience,
    };
  }

  // Convert Firestore document snapshot to Hairstylist instance
  factory Hairstylist.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Hairstylist(
      id: doc.id,
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      imageUrl: data['imageUrl'],
      password: data['password'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'],
      location: data['location'],
      skills: data['skills'],
      yearsOfExperience: data['yearsOfExperience'] is int
          ? data['yearsOfExperience']
          : int.parse(data['yearsOfExperience']),
    );
  }
}
