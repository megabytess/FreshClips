class WorkingHours {
  String day;
  String status; // Shop Open / Shop Closed
  String? openingTime;
  String? closingTime;

  WorkingHours({
    required this.day,
    required this.status,
    this.openingTime,
    this.closingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'status': status,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }

  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      day: map['day'] ?? '',
      status: map['status'] ?? 'Available',
      openingTime: map['openingTime'],
      closingTime: map['closingTime'],
    );
  }
}
