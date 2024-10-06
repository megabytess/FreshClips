import 'package:freshclips_capstone/features/hairstylist-features/models/hairstylist_model.dart';

class BarbershopSalon {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final String location;
  final String imageUrl;
  final List<Hairstylist> hairstylists;

  BarbershopSalon({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.location,
    required this.imageUrl,
    required this.hairstylists,
  });

  factory BarbershopSalon.fromJson(Map<String, dynamic> json) {
    return BarbershopSalon(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      imageUrl: json['imageUrl'],
      hairstylists: (json['hairstylists'] as List<dynamic>)
          .map((e) => Hairstylist.fromJson(e))
          .toList(),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:freshclips_capstone/models/barbershop_salon.dart';

// Future<BarbershopSalon> getBarbershopSalonById(String barbershopSalonId) async {
//   final barbershopSalonDoc = await FirebaseFirestore.instance.collection('barbershops').doc(barbershopSalonId).get();
//   if (barbershopSalonDoc.exists) {
//     return BarbershopSalon.fromJson(barbershopSalonDoc.data()!);
//   } else {
//     throw Exception('Barbershop Salon not found');
//   }
// }