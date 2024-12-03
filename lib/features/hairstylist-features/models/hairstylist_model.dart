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
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return Hairstylist(
      id: doc.id,
      email: data['email'] ?? '', // Default to an empty string if missing
      phoneNumber: data['phoneNumber'] ?? '', // Default to empty
      imageUrl: data['imageUrl'] ?? '', // Default to empty
      password: data['password'] ?? '', // Default to empty
      firstName: data['firstName'] ?? 'Unknown', // Default to 'Unknown'
      lastName: data['lastName'] ?? 'Unknown', // Default to 'Unknown'
      username: data['username'] ?? 'Unknown', // Default to 'Unknown'
      location: data['location'] ?? 'Unknown', // Default to 'Unknown'
      skills: data['skills'] ?? '', // Default to empty
      yearsOfExperience: data['yearsOfExperience'] is int
          ? data['yearsOfExperience']
          : data['yearsOfExperience'] is String
              ? int.tryParse(data['yearsOfExperience']) ??
                  0 // Parse or default to 0
              : 0, // Default to 0 if missing or invalid
    );
  }
}
