class WorkingHours {
  String day;
  String status; // Shop Open / Shop Closed

  WorkingHours({required this.day, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'status': status,
    };
  }

  factory WorkingHours.fromMap(Map<String, dynamic> map) {
    return WorkingHours(
      day: map['day'] ?? '',
      status: map['status'] ?? 'Available',
    );
  }
}
