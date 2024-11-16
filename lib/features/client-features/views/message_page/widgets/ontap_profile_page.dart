// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
// import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';

// class OnTapProfilePage extends StatelessWidget {
//   final String email;
//   final bool isClient;
//   final String userType;
//   final Map<String, dynamic> userData;

//   const OnTapProfilePage({
//     super.key,
//     required this.email,
//     required this.isClient,
//     required this.userType,
//     required this.userData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (email.isEmpty) {
//       return const Text("Invalid profile ID.");
//     }

//     return FutureBuilder<QuerySnapshot>(
//       future: FirebaseFirestore.instance
//           .collection('user')
//           .where('email', isEqualTo: email)
//           .get(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }
//         if (snapshot.hasError) {
//           return const Text("Error loading profile");
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Text("Profile not found");
//         }

//         final userData =
//             snapshot.data!.docs.first.data() as Map<String, dynamic>;
//         final userType = userData['userType'];

//         if (isClient) {
//           // Direct navigation to specific profile pages based on userType
//           if (userType == 'Barbershop_Salon') {
//             return BSProfilePage(userData: userData);
//           } else if (userType == 'Hairstylist') {
//             return HairstylistProfilePage(userData: userData);
//           } else {
//             return const Text("Invalid user type");
//           }
//         } else {
//           return const Text("Only clients can view other profiles.");
//         }
//       },
//     );
//   }
// }
