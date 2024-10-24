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
}
