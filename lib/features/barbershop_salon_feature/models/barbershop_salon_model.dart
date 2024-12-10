import 'package:cloud_firestore/cloud_firestore.dart';

class BarbershopSalon {
  final String id;
  final String shopName;
  final String email;
  final String username;
  final String phoneNumber;
  final Map<String, dynamic> location;
  final String imageUrl;
  final String password;

  BarbershopSalon({
    required this.id,
    required this.shopName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.location,
    required this.imageUrl,
    required this.password,
  });

  // Factory method to create a BarbershopSalon from a Firestore document
  factory BarbershopSalon.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BarbershopSalon(
      id: doc.id,
      shopName: data['shopName'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      location: data['location'] as Map<String, dynamic>,
      imageUrl: data['imageUrl'] ?? '',
      password: data['password'] ?? '',
    );
  }

  // Method to convert BarbershopSalon instance to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'location': location,
      'imageUrl': imageUrl,
      'password': password,
    };
  }
}
