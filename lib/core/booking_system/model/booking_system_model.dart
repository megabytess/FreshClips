class BookingAppointment {
  final String appointmentId;
  final String barbershopName;
  final String barbershopEmail;
  final DateTime createdAt;
  final DateTime appointmentDateTime;
  final List<String> servicesPicked;
  final double servicePrice;
  final String appointmentNotes;
  final bool isApproved;
  final String clientName;

  BookingAppointment({
    required this.appointmentId,
    required this.barbershopName,
    required this.barbershopEmail,
    required this.createdAt,
    required this.appointmentDateTime,
    required this.servicesPicked,
    required this.servicePrice,
    required this.appointmentNotes,
    required this.isApproved,
    required this.clientName,
  });

  // Convert the BookingAppointment object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'barbershopName': barbershopName,
      'barbershopEmail': barbershopEmail,
      'createdAt': createdAt.toIso8601String(),
      'appointmentDateTime': appointmentDateTime.toIso8601String(),
      'servicesPicked': servicesPicked,
      'servicePrice': servicePrice,
      'appointmentNotes': appointmentNotes,
      'isApproved': isApproved,
      'clientName': clientName,
    };
  }

  // Create a BookingAppointment object from Firestore data
  factory BookingAppointment.fromMap(Map<String, dynamic> map) {
    return BookingAppointment(
      appointmentId: map['appointmentId'] ?? '',
      barbershopName: map['barbershopName'] ?? '',
      barbershopEmail: map['barbershopEmail'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      appointmentDateTime: DateTime.parse(map['appointmentDateTime']),
      servicesPicked: List<String>.from(map['servicesPicked'] ?? []),
      servicePrice: map['servicePrice']?.toDouble() ?? 0.0,
      appointmentNotes: map['appointmentNotes'] ?? '',
      isApproved: map['isApproved'] ?? false,
      clientName: map['clientName'] ?? '',
    );
  }
}
