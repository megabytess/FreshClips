import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String userEmail;
  final String serviceName;
  final String serviceDescription;
  final double price;
  final int duration;
  bool selected;

  Service({
    required this.id,
    required this.userEmail,
    required this.serviceName,
    required this.serviceDescription,
    required this.price,
    required this.duration,
    this.selected = false,
  });

  factory Service.fromDocument(DocumentSnapshot doc) {
    return Service(
      id: doc.id,
      userEmail: doc['userEmail'],
      serviceName: doc['serviceName'],
      serviceDescription: doc['serviceDescription'],
      price: doc['price'],
      duration: doc['duration'],
      selected: false,
    );
  }

  // Convert Service object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'serviceName': serviceName,
      'serviceDescription': serviceDescription,
      'price': price,
      'duration': duration,
      'selected': selected,
    };
  }
}
