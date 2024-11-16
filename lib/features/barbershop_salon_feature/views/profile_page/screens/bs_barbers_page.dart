import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_add_barbers_model.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_add_barbers.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/widgets/bs_edit_barber_page.dart';
import 'package:google_fonts/google_fonts.dart';

class BSBarbersPage extends StatefulWidget {
  const BSBarbersPage(
      {super.key, required this.userEmail, required this.isClient});
  final String userEmail;
  final bool isClient;

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
    fetchBarbers();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> fetchBarbers() async {
    final barbersSnapshot = await FirebaseFirestore.instance
        .collection('availableBarbers')
        .where('userEmail', isEqualTo: widget.userEmail)
        .get();

    setState(() {
      barbers = barbersSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'userEmail': doc['userEmail'] ?? '',
          'name': doc['barberName'] ?? 'Unknown',
          'role': doc['role'] ?? 'Unknown',
          'status': doc['status'] ?? 'Unknown',
          'availability': doc['availability'] ?? 'Unknown',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Stack(
        children: [
          // Main content - either "No available barbers" message or the list of barbers
          barbers.isEmpty
              ? Center(
                  child: Text(
                    "No available barbers",
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 18, 18, 18),
                    ),
                  ),
                )
              : Padding(
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
                          backgroundImage: const AssetImage(
                            'assets/images/icons/for_servicess.jpg',
                          ),
                        ),
                        title: Text(
                          barber['name'] ?? 'Unknown Name',
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
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 100, 100, 100),
                              ),
                            ),
                          ],
                        ),
                        trailing: currentUserEmail == widget.userEmail
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        size: screenWidth * 0.06),
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
                                      ).then((value) {
                                        if (value == true) {
                                          fetchBarbers();
                                        }
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      BSAddBarberController()
                                          .deleteBarbers(
                                              widget.userEmail, barber['id'])
                                          .then((_) {
                                        fetchBarbers();
                                      });
                                    },
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
                ),

          // Conditional Positioned "Add Barber" button
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
                        builder: (context) =>
                            BSAddBarbersPage(email: widget.userEmail),
                      ),
                    );
                    if (result == true) {
                      fetchBarbers(); // Refresh list on return
                    }
                  },
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  child: Center(
                    child: Text(
                      'Add Barber',
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
