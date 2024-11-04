import 'package:flutter/material.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSAddBarbersPage extends StatefulWidget {
  const BSAddBarbersPage({super.key, required this.email});
  final String email;

  @override
  State<BSAddBarbersPage> createState() => _BSAddBarbersState();
}

class _BSAddBarbersState extends State<BSAddBarbersPage> {
  BSAddBarberController bsAddBarberController = BSAddBarberController();
  TextEditingController barberNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  String status = 'Working';
  List<String> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Add Barber',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barber Name Input

            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.02,
                screenHeight * 0.02,
                screenWidth * 0.02,
                screenHeight * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Barber name:',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  TextFormField(
                    controller: barberNameController,
                    decoration: InputDecoration(
                      hintText: 'Juan Dela Cruz',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 18, 18, 18)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 18, 18, 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Role Input
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Role:',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  TextFormField(
                    controller: roleController,
                    decoration: InputDecoration(
                      hintText: 'Barber, Stylist, etc.',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 18, 18, 18)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 18, 18, 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status Selector (Dropdown)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02),
              child: DropdownButtonFormField<String>(
                value: status,
                items: ['Working', 'Day Off'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: GoogleFonts.poppins(fontSize: screenWidth * 0.04),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Available Days',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  Wrap(
                    spacing: screenWidth * 0.02,
                    children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                        .map((day) => ChoiceChip(
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
                              selectedColor:
                                  const Color.fromARGB(255, 45, 65, 69),
                              onSelected: (bool selected) {
                                setState(() {
                                  selected
                                      ? selectedDays.add(day)
                                      : selectedDays.remove(day);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Gap(screenWidth * 0.04),
            // Submit Button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02),
              child: SizedBox(
                height: screenHeight * 0.07,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await bsAddBarberController.addBarber(
                        userEmail: widget.email,
                        barberName: barberNameController.text,
                        role: roleController.text,
                        status: status,
                        availability: selectedDays,
                      );

                      // Show success dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                            ),
                            contentPadding: EdgeInsets.all(screenWidth * 0.05),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Barber Added Successfully!',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close dialog
                                      Navigator.pop(
                                          context); // Go back to previous screen
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 45, 65, 69),
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.05),
                                      ),
                                    ),
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 45, 65, 69),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } catch (e) {
                      // Show error dialog
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                            ),
                            contentPadding: EdgeInsets.all(screenWidth * 0.05),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Failed to Add Barber',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Gap(screenHeight * 0.01),
                                Text(
                                  'Please try again later.',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Gap(screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close error dialog
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 45, 65, 69),
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.05),
                                      ),
                                    ),
                                    child: Text(
                                      'OK',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 189, 49, 71),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      print('Error adding barber: $e');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 189, 49, 71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: Text(
                    'Add Barber',
                    style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
