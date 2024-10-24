import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String hairstylistEmail;
  final String serviceName;
  final String serviceDescription;
  final double price;
  final int duration;

  Service({
    required this.id,
    required this.hairstylistEmail,
    required this.serviceName,
    required this.serviceDescription,
    required this.price,
    required this.duration,
  });

  factory Service.fromDocument(DocumentSnapshot doc) {
    return Service(
      id: doc.id,
      hairstylistEmail: doc['hairstylistEmail'],
      serviceName: doc['serviceName'],
      serviceDescription: doc['serviceDescription'],
      price: doc['price'],
      duration: doc['duration'],
    );
  }
}
