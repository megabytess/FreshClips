import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/controllers/bs_ratings_review_controller.dart';
import 'package:freshclips_capstone/features/barbershop_salon_feature/views/profile_page/screens/bs_profile_page.dart';
import 'package:freshclips_capstone/features/client-features/controllers/client_controller.dart';
import 'package:freshclips_capstone/features/client-features/controllers/nearby_controller.dart';
import 'package:freshclips_capstone/features/hairstylist-features/views/profile_page/screen/hairstylist_profile_page.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientNearbyPage extends StatefulWidget {
  const ClientNearbyPage(
      {super.key, required this.email, required this.clientEmail});
  final String email;
  final String clientEmail;

  @override
  State<ClientNearbyPage> createState() => _ClientNearbyPageState();
}

class _ClientNearbyPageState extends State<ClientNearbyPage> {
  late GoogleMapController mapController;
  ClientController clientController = ClientController();
  Position? currentPosition;
  LatLng? selectedLocation;
  BitmapDescriptor? userMarkerIcon;
  Set<Marker> markers = {};
  Set<Marker> newMarkers = {};
  final NearbyController nearbyController = NearbyController();
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final CustomInfoWindowController newCustomInfoWindowController =
      CustomInfoWindowController();
  final TextEditingController reviewController = TextEditingController();
  late final RatingsReviewController ratingsReviewController;

  @override
  void initState() {
    super.initState();
    ratingsReviewController = RatingsReviewController(
      clientEmail: widget.clientEmail,
      reviewController: reviewController,
    );
    checkAndRequestLocationPermission();
    loadUserImage();
    fetchNearbyUsers();
  }

  /// Loads user profile image as a marker
  Future<void> loadUserImage() async {
    try {
      String imageUrl =
          await nearbyController.getUserProfileImage(widget.email);
      BitmapDescriptor customIcon =
          await nearbyController.createCircularMarker(imageUrl);
      setState(() {
        userMarkerIcon = customIcon;
      });
    } catch (e) {
      debugPrint("Error loading user image: $e");
    }
  }

  /// Checks and requests location permission
  Future<void> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied. Please enable them in settings.',
          ),
        ),
      );
      return;
    }

    getCurrentLocation();
  }

  /// Gets the current location of the user
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        selectedLocation = LatLng(position.latitude, position.longitude);
        currentPosition = position;
      });

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedLocation!,
            zoom: 14.0,
          ),
        ),
      );

      fetchNearbyUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get location: $e')),
      );
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
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      Set<Marker> newMarkers = {};
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
            BitmapDescriptor icon = await nearbyController.createCircularMarker(
              data['imageUrl'] ?? '',
            );

            newMarkers.add(
              Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(userLat, userLng),
                icon: icon,
                onTap: () {
                  newCustomInfoWindowController.addInfoWindow!(
                    Container(
                      width: screenWidth * 1,
                      height: screenHeight * 1,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            accountName,
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                          Gap(screenHeight * 0.001),
                          Text(
                            '${data['userType']}',
                            style: GoogleFonts.poppins(
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromARGB(255, 48, 65, 69),
                            ),
                          ),
                        ],
                      ),
                    ),
                    LatLng(userLat, userLng),
                  );
                },
              ),
            );
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

  /// Handles Google Maps controller initialization
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    customInfoWindowController.googleMapController = mapController;
    newCustomInfoWindowController.googleMapController = mapController;

    fetchNearbyUsers();
    if (currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentPosition!.latitude, currentPosition!.longitude),
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    Set<Marker> userMarker = {};

    if (selectedLocation != null && userMarkerIcon != null) {
      userMarker.add(
        Marker(
          markerId: MarkerId('user_${widget.email}'),
          position: selectedLocation!,
          icon: userMarkerIcon!,
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              Container(
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.032,
                  screenHeight * 0.011,
                  screenWidth * 0.02,
                  screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'YOU',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(255, 48, 65, 69),
                  ),
                ),
              ),
              selectedLocation!,
            );

            setState(() {}); // Refresh UI
          },
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(10.3157, 123.8854),
              zoom: 16.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: {...userMarker, ...markers},
            onTap: (location) {
              customInfoWindowController.hideInfoWindow!();
              setState(
                () {
                  customInfoWindowController.hideInfoWindow!();
                  newCustomInfoWindowController.hideInfoWindow!();
                },
              );
            },
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
              newCustomInfoWindowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 40,
            width: 60,
            offset: 50,
          ),
          CustomInfoWindow(
            controller: newCustomInfoWindowController,
            height: 100,
            width: 200,
            offset: 50,
          ),

          // Display nearby shops
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: screenHeight * 0.34,
              width: screenWidth * 1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nearbyUsers.length,
                itemBuilder: (context, index) {
                  final user = nearbyUsers[index];

                  return Container(
                    width: screenWidth * 0.8,
                    margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.03,
                      0,
                      screenWidth * 0.01,
                      0,
                    ),
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      bottom: screenHeight * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 248, 248, 248),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.flag_circle_rounded,
                              color: const Color.fromARGB(255, 48, 65, 69),
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
                        Gap(screenHeight * 0.01),
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: const Color.fromARGB(255, 48, 65, 69),
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
                        ),
                        Gap(screenHeight * 0.01),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final destinationLatLng =
                                  user['location']?['latitude'];
                              final destinationLng =
                                  user['location']?['longitude'];

                              if (destinationLatLng != null &&
                                  destinationLng != null) {
                                final url = Uri.parse(
                                  'https://www.google.com/maps/dir/?api=1&destination=$destinationLatLng,$destinationLng',
                                );

                                launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Location not available')),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.directions,
                              size: 18,
                            ),
                            label: Text(
                              'Get directions',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 248, 248, 248),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 48, 65, 69),
                              foregroundColor:
                                  const Color.fromARGB(255, 248, 248, 248),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                          ),
                        ),
                        // Gap(screenHeight * 0.01),
                        Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                        ),
                        Gap(screenHeight * 0.01),
                        Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                user['imageUrl'] ?? '',
                                height: screenHeight * 0.07,
                                width: screenHeight * 0.07,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
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
                            Gap(screenHeight * 0.01),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        user['accountName'] ?? 'Unknown',
                                        style: GoogleFonts.poppins(
                                          fontSize: screenWidth * 0.035,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 48, 65, 69),
                                        ),
                                      ),
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
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Color.fromARGB(
                                                        255, 189, 49, 71),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error loading rating',
                                                  style: GoogleFonts.poppins(
                                                    color: const Color.fromARGB(
                                                        255, 48, 65, 69),
                                                    fontSize:
                                                        screenWidth * 0.03,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                );
                                              } else {
                                                double rating =
                                                    snapshot.data ?? 0.0;
                                                return Text(
                                                  rating > 0
                                                      ? rating
                                                          .toStringAsFixed(1)
                                                      : '...',
                                                  style: GoogleFonts.poppins(
                                                    color: const Color.fromARGB(
                                                        255, 48, 65, 69),
                                                    fontSize:
                                                        screenWidth * 0.032,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Gap(screenHeight * 0.0015),
                                  Text(
                                    '@${user['username']}',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Gap(screenHeight * 0.0015),
                                  Text(
                                    user['userType'] ?? 'Unknown Type',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.025,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(screenHeight * 0.02),
                        SizedBox(
                          width: double.infinity,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
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
                                    builder: (context) =>
                                        HairstylistProfilePage(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 189, 49, 71),
                              foregroundColor:
                                  const Color.fromARGB(255, 248, 248, 248),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'View profile',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Positioned(
          //   top: 20,
          //   left: 10,
          //   child: Padding(
          //     padding: EdgeInsets.symmetric(
          //       horizontal: screenWidth * 0.03,
          //     ),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(20),
          //       child: Container(
          //         height: screenHeight * 0.05,
          //         width: screenWidth * 0.88,
          //         color: const Color.fromARGB(255, 248, 248, 248),
          //         child: TextButton(
          //           onPressed: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ClientSearchFilterNearbyPage(
          //                 email: widget.email,
          //                 clientEmail: widget.clientEmail,
          //               ),
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               const Icon(
          //                 Icons.search_rounded,
          //                 color: Colors.grey,
          //                 size: 24,
          //               ),
          //               const Gap(10),
          //               Text(
          //                 'Search',
          //                 style: GoogleFonts.poppins(
          //                   fontSize: screenWidth * 0.03,
          //                   color: Colors.grey[600],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // Zoom controls
          Positioned(
            top: 80,
            right: 10,
            child: Column(
              children: [
                OutlinedButton(
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 48, 65, 69)),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(screenWidth * 0.01),
                  ),
                  child: Icon(
                    Icons.add,
                    color: const Color.fromARGB(255, 48, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.001),
                OutlinedButton(
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 48, 65, 69)),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: const Color.fromARGB(255, 48, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
                Gap(screenHeight * 0.001),
                OutlinedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 48, 65, 69)),
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                  ),
                  child: Icon(
                    Icons.my_location,
                    color: const Color.fromARGB(255, 48, 65, 69),
                    size: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
