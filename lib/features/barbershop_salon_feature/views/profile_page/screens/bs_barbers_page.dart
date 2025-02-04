import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_add_barbers_model.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_add_barbers.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_edit_barber_page.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSBarbersPage extends StatefulWidget {
  const BSBarbersPage({
    super.key,
    required this.userEmail,
    required this.isClient,
    required this.clientEmail,
  });
  final String userEmail;
  final bool isClient;
  final String clientEmail;
  @override
  State<BSBarbersPage> createState() => _BSBarbersPageState();
}

class _BSBarbersPageState extends State<BSBarbersPage> {
  List<Map<String, dynamic>> barbers = [];
  String? currentUserEmail;

  BSAddBarberController bsAddBarberController = BSAddBarberController();

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('availableBarbers')
                .where('userEmail', isEqualTo: widget.userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 189, 49, 71),
                  ),
                ));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error loading barbers.",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 18, 18, 18),
                    ),
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "No available barbers",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              }

              final barbers = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return {
                  'id': doc.id,
                  'userEmail': data['userEmail'] ?? '',
                  'barberName': data['barberName'] ?? 'Unknown',
                  'barberImageUrl': data['barberImageUrl'] ?? '',
                  'role': data['role'] ?? 'Unknown',
                  'status': data['status'] ?? 'Unknown',
                  'availability': data['availability'] ?? 'Unknown',
                };
              }).toList();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: ListView.builder(
                  itemCount: barbers.length,
                  itemBuilder: (context, index) {
                    final barber = barbers[index];

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.010,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: screenWidth * 0.075,
                        backgroundImage: NetworkImage(
                          barber['barberImageUrl'],
                        ),
                      ),
                      title: Text(
                        barber['barberName'] ?? 'Unknown Name',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 23, 23, 23),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barber['role'] ?? 'Role not specified',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.029,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 100, 100, 100),
                            ),
                          ),
                          Text(
                            "${barber['status'] ?? 'Unknown'}",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.028,
                              fontWeight: FontWeight.w600,
                              color: barber['status'] == "Working"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          Text(
                            "${barber['availability'] ?? 'Not available'}",
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.025,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromARGB(255, 100, 100, 100),
                            ),
                          ),
                        ],
                      ),
                      trailing: currentUserEmail == widget.userEmail
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 199, 206),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color.fromARGB(255, 49, 65, 69),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BSEditBarberPage(
                                            userEmail: widget.userEmail,
                                            bsAddBarbers:
                                                BSAddBarbers.fromMap(barber),
                                          ),
                                        ),
                                      ).then((value) {});
                                    },
                                  ),
                                ),
                                Gap(screenWidth * 0.04),
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 199, 206),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      size: 20,
                                      color: Color.fromARGB(255, 49, 65, 69),
                                    ),
                                    onPressed: () {
                                      BSAddBarberController()
                                          .deleteBarbers(
                                              widget.userEmail, barber['id'])
                                          .then((_) {});
                                    },
                                  ),
                                ),
                              ],
                            )
                          : null,
                    );
                  },
                ),
              );
            },
          ),
          if (currentUserEmail == widget.userEmail)
            Positioned(
              bottom: screenWidth * 0.04,
              right: screenWidth * 0.04,
              child: Container(
                width: screenWidth * 0.3,
                height: screenWidth * 0.12,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 45, 65, 69),
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BSAddBarbersPage(
                          email: widget.userEmail,
                          clientEmail: widget.clientEmail,
                        ),
                      ),
                    );
                    if (result == true) {}
                  },
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  child: Center(
                    child: Text(
                      'Add barber',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.033,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
