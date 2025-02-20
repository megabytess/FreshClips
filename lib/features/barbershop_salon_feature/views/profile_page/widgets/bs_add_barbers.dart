import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_add_barbers_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom;
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class BSAddBarbersPage extends StatefulWidget {
  const BSAddBarbersPage({
    super.key,
    required this.email,
    required this.clientEmail,
  });
  final String email;
  final String clientEmail;
  @override
  State<BSAddBarbersPage> createState() => _BSAddBarbersState();
}

class _BSAddBarbersState extends State<BSAddBarbersPage> {
  BSAddBarberController bsAddBarberController = BSAddBarberController();
  TextEditingController roleController = TextEditingController();
  final TextEditingController searchInputController = TextEditingController();
  final custom.SearchController searchController = custom.SearchController();
  List<Map<String, dynamic>> searchResults = [];

  String status = 'Working';
  List<String> selectedDays = [];
  final List<Map<String, dynamic>> selectedBarbers = [];
  final TextEditingController reviewController = TextEditingController();
  late final RatingsReviewController ratingsReviewController =
      RatingsReviewController(
    clientEmail: widget.clientEmail,
    reviewController: reviewController,
  );

  void showSearchModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.08,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchInputController,
                decoration: InputDecoration(
                  hintText: 'Search user',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 18, 18, 18)),
                onChanged: (value) async {
                  if (value.isEmpty) {
                    setState(() {
                      searchResults = [];
                    });
                  } else {
                    final results = await searchController.filterByUsertype(
                        value, widget.clientEmail);

                    setState(() {
                      searchResults = results;
                    });
                  }
                },
              ),
              Gap(screenHeight * 0.02),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: Stream.fromFuture(
                    searchController
                        .searchHairstylistUser(searchInputController.text),
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(
                            Color.fromARGB(255, 189, 49, 71),
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'An error occurred: ${snapshot.error}',
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: screenWidth * 0.04),
                        ),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      );
                    }

                    final searchResults = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final profile = searchResults[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(profile['imageUrl'] ?? ''),
                          ),
                          title: Text(profile['username'] ?? 'Unknown',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 18, 18, 18),
                              )),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/profile_page/star.svg',
                                    width: screenWidth * 0.35,
                                    height: screenWidth * 0.035,
                                  ),
                                  Gap(screenHeight * 0.004),
                                  FutureBuilder<double>(
                                    future: ratingsReviewController
                                        .computeAverageRating(profile['email']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(255, 189, 49, 71),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error loading rating',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      } else {
                                        double rating = snapshot.data ?? 0.0;
                                        return Text(
                                          rating.toStringAsFixed(1),
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Text(profile['userType'] ?? '',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          onTap: () {
                            if (!selectedBarbers.contains(profile)) {
                              setState(() {
                                selectedBarbers.add(profile);
                              });
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                screenHeight * 0.01,
                screenWidth * 0.04,
                screenHeight * 0.01,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.05,
                    child: OutlinedButton(
                      onPressed: () => showSearchModal(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey[600]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          const Gap(5),
                          Text(
                            'Search hairstylist',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.035,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(screenHeight * 0.02),
                  Text(
                    'Added barber',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Gap(screenHeight * 0.01),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedBarbers.length,
                    itemBuilder: (context, index) {
                      final profile = selectedBarbers[index];
                      return Row(
                        children: [
                          SizedBox(
                            height: screenWidth * 0.2,
                            width: screenWidth * 0.2,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                profile['imageUrl'] ?? '',
                              ),
                            ),
                          ),
                          Gap(screenWidth * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile['username'] ?? 'Unknown',
                                style: GoogleFonts.poppins(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(255, 18, 18, 18),
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/profile_page/star.svg',
                                    width: screenWidth * 0.4,
                                    height: screenWidth * 0.04,
                                  ),
                                  Gap(screenHeight * 0.004),
                                  FutureBuilder<double>(
                                    future: ratingsReviewController
                                        .computeAverageRating(profile['email']),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(255, 189, 49, 71),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error loading rating',
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      } else {
                                        double rating = snapshot.data ?? 0.0;
                                        return Text(
                                          rating.toStringAsFixed(1),
                                          style: GoogleFonts.poppins(
                                            color: const Color.fromARGB(
                                                255, 18, 18, 18),
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                profile['userType'] ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),

            // Role Input
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Role',
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
                        fontWeight: FontWeight.w400,
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
                  horizontal: screenWidth * 0.04,
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
                horizontal: screenWidth * 0.04,
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
                    children: [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday'
                    ]
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
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.02),
              child: SizedBox(
                height: screenHeight * 0.07,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (selectedBarbers.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(screenWidth * 0.05),
                              ),
                              content: Text(
                                'Please select a barber before proceeding.',
                                style: GoogleFonts.poppins(),
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'OK',
                                    style: GoogleFonts.poppins(
                                      color:
                                          const Color.fromARGB(255, 45, 65, 69),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        return;
                      }

                      await bsAddBarberController.addBarber(
                        userEmail: widget.email,
                        selectedBarber: selectedBarbers.first,
                        role: roleController.text,
                        status: status,
                        availability: selectedDays.join(', '),
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
                                      Navigator.pop(context);
                                      Navigator.pop(context);
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
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Please try again later.',
                                  style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
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


// Padding(
          //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       WoltModalSheet.show(
          //         context: context,
          //         pageListBuilder: (bottomSheetContext) => [
          //           SliverWoltModalSheetPage(
          //             mainContentSliversBuilder: (context) => [
          //               SliverList.builder(
          //                 itemBuilder: (context, index) {
          //                   return ListTile(
          //                     title: Text('Index is $index'),
          //                     onTap: Navigator.of(bottomSheetContext).pop,
          //                   );
          //                 },
          //               ),
          //             ],
          //           )
          //         ],
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color.fromARGB(255, 186, 199, 206),
          //       padding:
          //           const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //     ),
          //     child: Text(
          //       'Select Hairstyle Tags',
          //       style: GoogleFonts.poppins(
          //         fontSize: screenWidth * 0.028,
          //         color: const Color.fromARGB(255, 48, 65, 69),
          //       ),
          //     ),
          //   ),
          // ),