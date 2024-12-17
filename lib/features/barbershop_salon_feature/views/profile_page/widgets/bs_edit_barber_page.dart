import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/models/bs_add_barbers_model.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSEditBarberPage extends StatefulWidget {
  final String userEmail;
  final BSAddBarbers bsAddBarbers;

  const BSEditBarberPage({
    super.key,
    required this.userEmail,
    required this.bsAddBarbers,
  });

  @override
  State<BSEditBarberPage> createState() => _BSEditBarberPageState();
}

class _BSEditBarberPageState extends State<BSEditBarberPage> {
  final _formKey = GlobalKey<FormState>();
  late String barberName;
  late String role;
  late String status;
  List<String> selectedDays = []; // Tracks selected days
  List<String> availability = []; // Tracks availability text

  final List<String> allDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  final List<String> statusOptions = ['Working', 'Dayoff'];
  BSAddBarberController addBarberController = BSAddBarberController();

  Future<void> fetchBarbers() async {
    final data = await FirebaseFirestore.instance
        .collection('availableBarbers')
        .where('userEmail', isEqualTo: widget.userEmail)
        .get();
    setState(() {
      availability =
          data.docs.map((doc) => doc['availability'] as String).toList();
    });
  }

  @override
  void initState() {
    super.initState();

    role = widget.bsAddBarbers.role;
    status = statusOptions.contains(widget.bsAddBarbers.status)
        ? widget.bsAddBarbers.status
        : statusOptions[
            0]; // Set a default status if the current one is invalid
    availability = widget.bsAddBarbers.availability;
    barberName = widget.bsAddBarbers.barberName;
    fetchBarbers();

    availability = selectedDays;
  }

  static bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    setState(() {});
  }

  void updateAvailabilityFromText(String value) {
    setState(() {
      // Parse and clean input text
      availability = value
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      selectedDays = availability
          .where((day) => allDays.contains(day))
          .toList(); // Ensure only valid days are selected
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit barbers',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: AnimatedBuilder(
        animation: addBarberController,
        builder: (context, _) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(screenWidth * 0.05),
              children: [
                TextFormField(
                  initialValue: role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  onChanged: (value) {
                    role = value;
                  },
                ),
                Gap(screenHeight * 0.02),
                DropdownButtonFormField<String>(
                  value: status,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle:
                        GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  items: statusOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a status' : null,
                ),
                Gap(screenHeight * 0.02),
                Wrap(
                  spacing: screenWidth * 0.02,
                  children: allDays.map((day) {
                    return ChoiceChip(
                      label: Text(
                        day,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: selectedDays.contains(day)
                              ? const Color.fromARGB(255, 248, 248, 248)
                              : const Color.fromARGB(255, 18, 18, 18),
                        ),
                      ),
                      selected: selectedDays.contains(day),
                      selectedColor: const Color.fromARGB(255, 45, 65, 69),
                      onSelected: (bool selected) {
                        setState(() {
                          // Update selectedDays and availability list
                          if (selected) {
                            if (!selectedDays.contains(day)) {
                              selectedDays.add(day);
                            }
                          } else {
                            selectedDays.remove(day);
                          }
                          availability = selectedDays; // Sync availability
                        });
                      },
                    );
                  }).toList(),
                ),
                Gap(screenHeight * 0.04),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final updatedBarber = BSAddBarbers(
                        id: widget.bsAddBarbers.id,
                        affiliatedShop: widget.bsAddBarbers.affiliatedShop,
                        barberName: barberName,
                        role: role,
                        status: status,
                        availability: availability,
                        userEmail: widget.userEmail,
                      );

                      addBarberController.editBarber(
                        barberName: updatedBarber.barberName,
                        role: updatedBarber.role,
                        status: updatedBarber.status,
                        availability: updatedBarber.availability.join(', '),
                        userEmail: updatedBarber.userEmail,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 49, 70),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save changes',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
