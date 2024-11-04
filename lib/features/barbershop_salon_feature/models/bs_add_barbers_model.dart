class BSAddBarbers {
  final String id; // Unique identifier for the barber (from Firestore)
  final String barberName;
  final String role;
  final String status;
  final List<String> availability;
  final String userEmail;

  // Constructor
  BSAddBarbers({
    required this.id,
    required this.barberName,
    required this.role,
    required this.status,
    required this.availability,
    required this.userEmail,
  });

  // Factory constructor to create BSAddBarbers from a Map with null safety
  factory BSAddBarbers.fromMap(Map<String, dynamic> map) {
    print("Map data: $map"); // Add this line for debugging
    return BSAddBarbers(
      id: map['id'] as String? ?? 'no-id',
      barberName: map['barberName'] as String? ?? 'barberName',
      role: map['role'] as String? ?? 'Unknown',
      status: map['status'] as String? ?? 'Unknown',
      availability: map['availability'] != null
          ? (map['availability'] as String)
              .split(',')
              .map((day) => day.trim())
              .toList()
          : <String>[],
      userEmail: map['userEmail'] as String? ?? 'Unknown',
    );
  }

  // Method to convert BSAddBarbers to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id, // Include ID for updating or deleting records
      'barberName': barberName,
      'role': role,
      'status': status,
      'availability':
          availability.join(', '), // Join availability list to a string
      'userEmail': userEmail, // Include userEmail if needed
    };
  }
}
