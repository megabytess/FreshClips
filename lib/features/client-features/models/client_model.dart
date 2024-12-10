import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String id;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final String password;
  final String firstName;
  final String lastName;
  final String username;
  final Map<String, dynamic> location;

  Client({
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.location,
  });

  // Convert client instance to Map<String, dynamic>
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
    };
  }

  // Convert Firestore document snapshot to client instance
  factory Client.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Client(
      id: doc.id,
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      imageUrl: data['imageUrl'],
      password: data['password'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'],
      location: data['location'] as Map<String, dynamic>,
    );
  }
}
