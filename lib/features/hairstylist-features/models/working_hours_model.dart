import 'package:cloud_firestore/cloud_firestore.dart';

class WorkingHours {
  final String day;
  final bool status;
  final DateTime? openingTime;
  final DateTime? closingTime;

  WorkingHours({
    required this.day,
    required this.status,
    this.openingTime,
    this.closingTime,
  });

  factory WorkingHours.fromMap(Map<String, dynamic> data) {
    return WorkingHours(
      day: data['day'] as String,
      status: data['status'] as bool,
      openingTime: data['openingTime'] != null
          ? (data['openingTime'] as Timestamp).toDate()
          : null,
      closingTime: data['closingTime'] != null
          ? (data['closingTime'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'status': status,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }
}
