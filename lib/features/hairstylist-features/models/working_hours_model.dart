class WorkingHours {
  String day;
  bool status; // Shop Open / Shop Closed
  DateTime? openingTime;
  DateTime? closingTime;

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
      status: map['status'] ?? false,
      openingTime: map['openingTime']?.toDate(),
      closingTime: map['closingTime']?.toDate(),
    );
  }
}
