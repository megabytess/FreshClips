class Client {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String location;
  final String imageUrl;
  final String password;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.location,
    required this.imageUrl,
    required this.password,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      password: json['password'],
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freshclips_capstone/models/client.dart';

// Future<Client> getClientById(String clientId) async {
//   final clientDoc = await FirebaseFirestore.instance.collection('clients').doc(clientId).get();
//   if (clientDoc.exists) {
//     return Client.fromJson(clientDoc.data()!);
//   } else {
//     throw Exception('Client not found');
//   }
// }