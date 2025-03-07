import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/nearby_controller.dart';
import 'package:freshclips_capstone/features/client-features/controllers/search_controller.dart'
    as custom;
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientSearchFilterNearbyPage extends StatefulWidget {
  const ClientSearchFilterNearbyPage(
      {super.key, required this.email, required this.clientEmail});
  final String email;
  final String clientEmail;

  @override
  State<ClientSearchFilterNearbyPage> createState() =>
      _ClientSearchFilterNearbyPageState();
}

class _ClientSearchFilterNearbyPageState
    extends State<ClientSearchFilterNearbyPage> {
  final TextEditingController searchInputController = TextEditingController();
  final custom.SearchController searchController = custom.SearchController();
  List<Map<String, dynamic>> searchResults = [];
  String selectedCategory = 'Hairstylist';
  final TextEditingController reviewController = TextEditingController();
  late final RatingsReviewController ratingsReviewController =
      RatingsReviewController(
    clientEmail: widget.clientEmail,
    reviewController: reviewController,
  );
  Position? currentPosition;
  Set<Marker> markers = {};
  Set<Marker> newMarkers = {};
  final NearbyController nearbyController = NearbyController();
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final CustomInfoWindowController newCustomInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((_) {
      fetchNearbyUsers();
      fetchInitialResults();
    });
  }

  Future<void> fetchInitialResults() async {
    await fetchNearbyUsers();

    setState(() {
      searchResults = nearbyUsers;
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      debugPrint("Error getting current location: $e");
    }
  }

  List<Map<String, dynamic>> nearbyUsers = [];

  // Function to sort nearby users (formula)
  // Handles unrated
  List<Map<String, dynamic>> sortNearby(
      List<Map<String, dynamic>> nearbyShops) {
    nearbyShops.sort((a, b) {
      double distanceA = a['distance'] ?? double.infinity;
      double distanceB = b['distance'] ?? double.infinity;
      double ratingA = a['rating'] ?? 0.0;
      double ratingB = b['rating'] ?? 0.0;

      double scoreA;
      double scoreB;

      // Simple condition: ignore shops with a rating of 0
      if (ratingA == 0 || ratingB == 0) {
        scoreA = ratingA;
        scoreB = ratingB;
      } else {
        scoreA = (1 / (distanceA + 1)) * ratingA;
        scoreB = (1 / (distanceB + 1)) * ratingB;
      }

      return scoreB.compareTo(scoreA);
    });

    return nearbyShops;
  }

  /// Fetches nearby barbershops and hairstylists from Firestore
  Future<void> fetchNearbyUsers() async {
    if (currentPosition == null) {
      debugPrint("fetchNearbyUsers: Current position is null, skipping fetch.");
      return;
    }

    debugPrint("fetchNearbyUsers: Fetching nearby users...");
    try {
      // Set<Marker> newMarkers = {};
      List<Map<String, dynamic>> newNearbyUsers = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('user').where(
        'userType',
        whereIn: ['Barbershop_Salon', 'Hairstylist'],
      ).get();

      debugPrint(
          "fetchNearbyUsers: Retrieved ${snapshot.docs.length} users from Firestore.");

      for (var doc in snapshot.docs) {
        var data = doc.data();

        if (data.containsKey('location') &&
            data['location'] is Map<String, dynamic> &&
            data['location'].containsKey('latitude') &&
            data['location'].containsKey('longitude')) {
          double userLat = data['location']['latitude'] ?? 0.0;
          double userLng = data['location']['longitude'] ?? 0.0;

          double distance = Geolocator.distanceBetween(
            currentPosition!.latitude,
            currentPosition!.longitude,
            userLat,
            userLng,
          );

          // Determine account name based on userType
          String accountName;
          if (data['userType'] == 'Barbershop_Salon') {
            accountName = data['shopName'] ?? 'Unknown Shop';
          } else if (data['userType'] == 'Hairstylist') {
            accountName =
                '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}'.trim();
          } else {
            accountName = 'Unknown';
          }

          // Format distance text
          // String distanceText = distance < 1000
          //     ? '${distance.toStringAsFixed(0)} meters'
          //     : '${(distance / 1000).toStringAsFixed(2)} km';

          debugPrint(
              "User: $accountName, Distance: ${(distance / 1000).toStringAsFixed(2)} km");

          if (distance <= 5000) {
            newNearbyUsers.add({
              'accountName': accountName,
              'userType': data['userType'],
              'distance': double.parse((distance / 1000).toStringAsFixed(2)),
              'imageUrl': data['imageUrl'],
              'email': data['email'],
              'username': data['username'],
              'location': data['location'],
              'rating': await ratingsReviewController.computeAverageRating(
                data['email'],
              ),
            });

            debugPrint("Added marker for $accountName at [$userLat, $userLng]");
          } else {
            debugPrint(
                "Skipped $accountName, too far (${(distance / 1000).toStringAsFixed(2)} km)");
          }
        } else {
          debugPrint(
              "User ${doc.id} missing latitude/longitude in location field, skipping.");
        }
      }
      newNearbyUsers = sortNearby(newNearbyUsers);

      // Ensure markers and nearbyUsers update in state
      setState(() {
        markers.clear();
        markers.addAll(newMarkers);
        nearbyUsers.clear();
        nearbyUsers.addAll(newNearbyUsers);
      });

      debugPrint(
          "Successfully added ${newMarkers.length} markers and found ${nearbyUsers.length} nearby users.");
    } catch (e) {
      debugPrint("Error fetching users - $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
              child: TextField(
                controller: searchInputController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 20),
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 48, 65, 69),
                  fontSize: screenWidth * 0.035,
                ),
                onChanged: (value) async {
                  if (value.isEmpty) {
                    setState(() {
                      searchResults = [];
                    });
                  } else {
                    final results =
                        await searchController.searchByUsername(value);

                    setState(() {
                      searchResults = nearbyUsers = results;
                    });
                  }
                },
              ),
            ),

            Gap(screenHeight * 0.02),
            // Category Buttons (Hairstylist and Barbershop_Salon)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      selectedCategory = 'Hairstylist';
                      print('Selected category: $selectedCategory');
                    });

                    final results =
                        await searchController.filterByNearbyUsertype(
                      searchInputController.text,
                      selectedCategory,
                      currentPosition!,

                      5000, //  radius
                    );

                    setState(() {
                      searchResults = results;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Hairstylist'
                        ? const Color.fromARGB(255, 45, 65, 69)
                        : Colors.transparent,
                    side: BorderSide(
                      color: selectedCategory == 'Hairstylist'
                          ? const Color.fromARGB(255, 45, 65, 69)
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Hairstylist',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: selectedCategory == 'Hairstylist'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Gap(screenWidth * 0.02),
                OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      selectedCategory = 'Barbershop_Salon';
                      print('Selected category: $selectedCategory');
                    });

                    final results =
                        await searchController.filterByNearbyUsertype(
                      searchInputController.text,
                      selectedCategory,
                      currentPosition!,
                      5000, //  radius
                    );

                    if (results.isEmpty) {
                      print('No results found');
                    }

                    setState(() {
                      searchResults = results;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Barbershop_Salon'
                        ? const Color.fromARGB(255, 45, 65, 69)
                        : Colors.transparent,
                    side: BorderSide(
                      color: selectedCategory == 'Barbershop_Salon'
                          ? const Color.fromARGB(255, 45, 65, 69)
                          : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Barbershop/Salon',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.03,
                      color: selectedCategory == 'Barbershop_Salon'
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            Gap(screenHeight * 0.02),
            // Search Results List
            Expanded(
              child: searchResults.isEmpty
                  ? Center(
                      child: Text(
                        'Loading...',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemExtent: screenHeight * 0.12,
                      itemBuilder: (context, index) {
                        // final user = nearbyUsers[index];
                        final user = searchResults[index];

                        return InkWell(
                          onTap: () {
                            if (user['userType'] == 'Barbershop_Salon') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BSProfilePage(
                                    email: user['email'],
                                    isClient: true,
                                    clientEmail: widget.email,
                                  ),
                                ),
                              );
                            } else if (user['userType'] == 'Hairstylist') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HairstylistProfilePage(
                                    email: user['email'],
                                    isClient: true,
                                    clientEmail: widget.email,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Only barbershop or hairstylist profiles are viewable")),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color:
                                        const Color.fromARGB(255, 48, 65, 69),
                                    size: screenWidth * 0.045,
                                  ),
                                  Gap(screenHeight * 0.005),
                                  Expanded(
                                    child: Text(
                                      user['location'] != null
                                          ? user['location']['address']
                                          : 'Coordinates not available',
                                      style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.027,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[700],
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(screenHeight * 0.01),
                              Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      user['imageUrl'] ?? '',
                                      height: screenHeight * 0.05,
                                      width: screenHeight * 0.05,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: screenHeight * 0.07,
                                          width: screenHeight * 0.07,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.person,
                                              size: 50, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  Gap(screenWidth * 0.02),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              user['accountName'] ?? 'Unknown',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.035,
                                                fontWeight: FontWeight.w500,
                                                color: const Color.fromARGB(
                                                    255, 48, 65, 69),
                                              ),
                                            ),
                                            Spacer(),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/profile_page/star.svg',
                                                  width: screenWidth * 0.04,
                                                  height: screenWidth * 0.04,
                                                ),
                                                Gap(screenHeight * 0.004),
                                                FutureBuilder<double>(
                                                  future: user['email'] != null
                                                      ? ratingsReviewController
                                                          .computeAverageRating(
                                                              user['email'])
                                                      : Future.value(0.0),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          Color.fromARGB(
                                                              255, 189, 49, 71),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                        'Error loading rating',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 48, 65, 69),
                                                          fontSize:
                                                              screenWidth *
                                                                  0.03,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      );
                                                    } else {
                                                      double rating =
                                                          snapshot.data ?? 0.0;
                                                      return Text(
                                                        rating > 0
                                                            ? rating
                                                                .toStringAsFixed(
                                                                    1)
                                                            : '...',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 48, 65, 69),
                                                          fontSize:
                                                              screenWidth *
                                                                  0.032,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Text(
                                          user['userType'] ?? 'Unknown Type',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.025,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.flag_circle_rounded,
                                              color: const Color.fromARGB(
                                                  255, 48, 65, 69),
                                              size: screenWidth * 0.045,
                                            ),
                                            Gap(screenHeight * 0.005),
                                            Text(
                                              '${user['distance']} km away',
                                              style: GoogleFonts.poppins(
                                                fontSize: screenWidth * 0.027,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
