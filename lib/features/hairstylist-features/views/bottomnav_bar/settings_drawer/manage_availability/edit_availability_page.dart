import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditAvailabilityPage extends StatefulWidget {
  const EditAvailabilityPage({super.key, required this.email});

  final String email;

  @override
  State<EditAvailabilityPage> createState() => _EditAvailabilityPageState();
}

class _EditAvailabilityPageState extends State<EditAvailabilityPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  Map<String, dynamic>? availabilityData;

  @override
  void initState() {
    super.initState();
    fetchAvailabilityData();
  }

  Future<void> fetchAvailabilityData() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('availability')
          .where('email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          availabilityData = querySnapshot.docs.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('No availability data found for the given email.');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching availability data: $e');
    }
  }

  Future<void> updateAvailabilityData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await FirebaseFirestore.instance
            .collection('availability')
            .doc(widget.email)
            .update(availabilityData!);
        print('Availability data updated successfully.');
      } catch (e) {
        print('Error updating availability data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit availability',
          style: GoogleFonts.poppins(
            fontSize: screenWidth * 0.04,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 189, 49, 71),
                ),
              ),
            )
          : availabilityData == null
              ? Center(
                  child: Text(
                    'No availability data found.',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: availabilityData!['day'],
                          decoration: InputDecoration(
                            labelText: 'Day',
                            labelStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a day';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            availabilityData!['day'] = value!;
                          },
                        ),
                        TextFormField(
                          initialValue: availabilityData!['openingTime'] != null
                              ? DateFormat('h:mm a').format(
                                  (availabilityData!['openingTime']
                                          as Timestamp)
                                      .toDate())
                              : '',
                          decoration: InputDecoration(
                            labelText: 'Opening Time',
                            labelStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an opening time';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            availabilityData!['openingTime'] =
                                Timestamp.fromDate(
                              DateFormat('h:mm a').parse(value!),
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: availabilityData!['closingTime'] != null
                              ? DateFormat('h:mm a').format(
                                  (availabilityData!['closingTime']
                                          as Timestamp)
                                      .toDate())
                              : '',
                          decoration: InputDecoration(
                            labelText: 'Closing Time',
                            labelStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a closing time';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            availabilityData!['closingTime'] =
                                Timestamp.fromDate(
                              DateFormat('h:mm a').parse(value!),
                            );
                          },
                        ),
                        SwitchListTile(
                          title: Text(
                            'Status',
                            style: GoogleFonts.poppins(),
                          ),
                          value: availabilityData!['status'] ?? false,
                          onChanged: (value) {
                            setState(() {
                              availabilityData!['status'] = value;
                            });
                          },
                        ),
                        SizedBox(height: screenWidth * 0.05),
                        ElevatedButton(
                          onPressed: updateAvailabilityData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 189, 49, 71),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                              vertical: screenWidth * 0.03,
                            ),
                          ),
                          child: Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
